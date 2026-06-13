/// Returns a local asset image path based on a product's category string.
/// Used as a fallback when a product has no backend-stored image.
String categoryFallbackImage(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('electron') || cat.contains('gadget') || cat.contains('tech')) {
    return 'assets/images/electronics.png';
  }
  if (cat.contains('fash') || cat.contains('cloth') || cat.contains('wear')) {
    return 'assets/images/fashion.png';
  }
  if (cat.contains('shoe') || cat.contains('boot') || cat.contains('sneaker')) {
    return 'assets/images/shoe.png';
  }
  if (cat.contains('watch') || cat.contains('accessory') || cat.contains('accessories')) {
    return 'assets/images/watch.png';
  }
  if (cat.contains('home') || cat.contains('furniture') || cat.contains('kitchen')) {
    return 'assets/images/home.png';
  }
  if (cat.contains('beaut') || cat.contains('cosmet') || cat.contains('care') ||
      cat.contains('perfume') || cat.contains('fragrance')) {
    return 'assets/images/perfume.png';
  }
  if (cat.contains('audio') || cat.contains('headphone') || cat.contains('speaker')) {
    return 'assets/images/headphone.png';
  }
  return 'assets/images/product_image.png';
}
