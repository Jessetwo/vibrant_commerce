import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/components/widgets/text_box.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';
import 'package:vibrant_commerce/providers/product_provider.dart';
import 'package:vibrant_commerce/models/product.dart';

class CreateNew extends StatefulWidget {
  final Product? product;
  const CreateNew({super.key, this.product});

  @override
  State<CreateNew> createState() => _CreateNewState();
}

class _CreateNewState extends State<CreateNew> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  String _condition = 'New';
  bool _isUploading = false;
  final List<dynamic> _pickedImages = [];
  final ImagePicker _picker = ImagePicker();

  static const int _maxImages = 4;

  final List<String> _categories = ['Fashion', 'Electronics', 'Watches'];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      
      String initialCategory = widget.product!.category.trim();
      // Normalize casing to match one of the default categories if possible
      for (final cat in _categories) {
        if (cat.toLowerCase() == initialCategory.toLowerCase()) {
          initialCategory = cat;
          break;
        }
      }
      
      // If the product category is not in the default list, add it dynamically
      if (initialCategory.isNotEmpty && !_categories.contains(initialCategory)) {
        _categories.add(initialCategory);
      }
      
      _categoryController.text = initialCategory;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _pickedImages.addAll(widget.product!.images);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_pickedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 4 images allowed.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        _pickedImages.add(File(picked.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  Future<void> _handlePublish() async {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final description = _descriptionController.text.trim();
    final priceText = _priceController.text.trim();
    final stockText = _stockController.text.trim();

    if (name.isEmpty || category.isEmpty || description.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price.')),
      );
      return;
    }

    final stock = int.tryParse(stockText) ?? 0;

    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to manage products.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final productProvider = context.read<ProductProvider>();
    final isEditing = widget.product != null;

    // ── Upload images to Imgbb and collect public URLs ──────────────────
    // Replace YOUR_IMGBB_API_KEY with a free key from https://api.imgbb.com
    const imgbbApiKey = 'e5b38c050bd74827b767cb5f30946802';

    // Show uploading state if there are local files to upload
    final hasLocalImages = _pickedImages.any((img) => img is File);
    if (hasLocalImages) {
      setState(() => _isUploading = true);
    }

    List<String> images = [];
    for (var img in _pickedImages) {
      if (img is String && (img.startsWith('http://') || img.startsWith('https://'))) {
        // Already a real URL (e.g. editing an existing product)
        images.add(img);
      } else if (img is File) {
        try {
          final bytes = await img.readAsBytes();
          final base64Str = base64Encode(bytes);

          final uploadResponse = await http.post(
            Uri.parse('https://api.imgbb.com/1/upload?key=$imgbbApiKey'),
            body: {'image': base64Str},
          );

          if (uploadResponse.statusCode == 200) {
            final data = json.decode(uploadResponse.body);
            final url = data['data']['url'] as String?;
            if (url != null && url.isNotEmpty) {
              images.add(url);
            }
          }
          // If upload failed, skip this image (don't add a broken URL)
        } catch (_) {
          // skip on error
        }
      }
    }

    // If no images were successfully uploaded/provided, use category fallbacks
    if (images.isEmpty) {
      final catLower = category.toLowerCase();
      if (catLower.contains('fash') || catLower.contains('cloth') || catLower.contains('shoe') || catLower.contains('wear')) {
        images = [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=800&auto=format&fit=crop',
        ];
      } else if (catLower.contains('electron') || catLower.contains('gadget') || catLower.contains('tech') || catLower.contains('watch')) {
        images = [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop',
        ];
      } else {
        images = [
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop',
        ];
      }
    }

    setState(() => _isUploading = false);

    List<String> sizes = isEditing ? widget.product!.sizes : [];
    List<String> colors = isEditing ? widget.product!.colors : [];

    if (sizes.isEmpty || colors.isEmpty) {
      final catLower = category.toLowerCase();
      if (catLower.contains('fash') || catLower.contains('cloth') || catLower.contains('shoe') || catLower.contains('wear')) {
        sizes = ['39', '40', '41', '42', '43'];
        colors = ['Crimson Red', 'Midnight Black', 'Slate Grey'];
      } else if (catLower.contains('electron') || catLower.contains('gadget') || catLower.contains('tech') || catLower.contains('watch')) {
        sizes = ['Standard'];
        colors = ['Space Grey', 'Matte Black', 'Silver'];
      } else {
        sizes = ['One Size'];
        colors = ['Emerald Green', 'Charcoal', 'Ivory White'];
      }
    }

    final success = isEditing
        ? await productProvider.updateProduct(
            id: widget.product!.id,
            name: name,
            description: description,
            price: price,
            category: category,
            stock: stock,
            images: images,
            sizes: sizes,
            colors: colors,
            adminToken: authProvider.token!,
          )
        : await productProvider.createProduct(
            name: name,
            description: description,
            price: price,
            category: category,
            stock: stock,
            images: images,
            sizes: sizes,
            colors: colors,
            isTrending: false,
            adminToken: authProvider.token!,
          );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Product updated successfully!' : 'Product published successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(productProvider.error ?? 'Failed to process product request.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildImageSlot(int index) {
    final bool hasImage = index < _pickedImages.length;

    if (index == 0 && !hasImage) {
      // "Add" button slot
      return GestureDetector(
        onTap: _pickImage,
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: AppColors.primaryColor,
            dashPattern: const [8, 4],
            strokeWidth: 1.5,
            radius: const Radius.circular(12),
          ),
          child: Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined,
                    color: AppColors.primaryColor, size: 28),
                const SizedBox(height: 4),
                Text('Add',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );
    } else if (hasImage) {
      final img = _pickedImages[index];
      // Filled image slot
      return Stack(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.3)),
              image: DecorationImage(
                image: img is File
                    ? FileImage(img)
                    : NetworkImage(img as String) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Remove button
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 13),
              ),
            ),
          ),
          // Add more badge on last filled slot if not at max
          if (index == _pickedImages.length - 1 && _pickedImages.length < _maxImages)
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 14),
                ),
              ),
            ),
        ],
      );
    } else {
      // Empty placeholder slot
      return Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(Icons.image_outlined, color: Colors.grey[400], size: 30),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProductProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar ──────────────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
                                blurRadius: 6)
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.product != null ? 'Edit Product' : 'Create New Product',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Image Picker Section ──────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Images (${_pickedImages.length}/$_maxImages)',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'JPEG or PNG',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _maxImages,
                    (index) => _buildImageSlot(index),
                  ),
                ),

                // Hint text
                const SizedBox(height: 8),
                Text(
                  _pickedImages.isEmpty
                      ? 'Tap the + button to add product photos'
                      : '${_pickedImages.length} photo${_pickedImages.length > 1 ? 's' : ''} selected. Tap + on the image to add more.',
                  style: TextStyle(
                    fontSize: 12,
                    color: _pickedImages.isEmpty ? Colors.grey[500] : AppColors.primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Product Form ──────────────────────────────
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconlessTextBox(
                        hintText: 'Enter a descriptive name...',
                        title: 'Product Name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      // Category Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.4),
                                width: 0.8,
                              ),
                              color: const Color(0xffF3F3F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _categories.contains(_categoryController.text)
                                    ? _categoryController.text
                                    : null,
                                hint: Text(
                                  'Select a category...',
                                  style: TextStyle(
                                    color: Colors.grey.withValues(alpha: 0.6),
                                  ),
                                ),
                                isExpanded: true,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Colors.grey,
                                ),
                                items: _categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _categoryController.text = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      IconlessTextBox(
                        hintText: 'Tell buyers about your product...',
                        title: 'Product Description',
                        maxLines: 6,
                        minLines: 4,
                        controller: _descriptionController,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconlessTextBox(
                            hintText: '0.00',
                            title: 'Price (₦)',
                            width: 149,
                            controller: _priceController,
                          ),
                          IconlessTextBox(
                            hintText: '1',
                            title: 'Stock Qty',
                            width: 149,
                            controller: _stockController,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Condition Toggle ──────────────────
                      const Text(
                        'Product Condition',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _condition = 'New'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _condition == 'New'
                                      ? AppColors.primaryColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_condition == 'New')
                                      const Icon(Icons.check_circle,
                                          color: Colors.white, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      'New',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: _condition == 'New'
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _condition = 'Used'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _condition == 'Used'
                                      ? AppColors.primaryColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_condition == 'Used')
                                      const Icon(Icons.check_circle,
                                          color: Colors.white, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Used',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: _condition == 'Used'
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Publish Button ────────────────────────────
                if (_isUploading)
                  Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(
                        'Uploading images…',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  )
                else if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  MyButton(
                        title: widget.product != null ? 'Save Changes' : 'Publish Product',
                        onPressed: _handlePublish,
                        color: AppColors.primaryColor,
                      ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
