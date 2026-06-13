import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/models/user.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<AuthProvider>(context, listen: false).getPayments();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;
    final user = authProvider.currentUser;
    final List<PaymentMethod> payments = user?.paymentMethods ?? [];

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : payments.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.credit_card_off_outlined,
                            size: 80,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Saved Cards',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your saved debit/credit cards will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24.0),
                    itemCount: payments.length,
                    itemBuilder: (ctx, idx) {
                      final card = payments[idx];
                      return _buildPremiumCard(card, user?.name ?? 'Cardholder');
                    },
                  ),
      ),
    );
  }

  Widget _buildPremiumCard(PaymentMethod card, String cardHolderName) {
    // Curate elegant card brands and gradients
    final String brandName = card.brand.toUpperCase();
    final bool isVisa = brandName.contains('VISA');
    final bool isMastercard = brandName.contains('MASTERCARD');

    // Create unique gradients based on card brands for supreme aesthetics
    final Gradient cardGradient = isVisa
        ? const LinearGradient(
            colors: [Color(0xff09203f), Color(0xff537895)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : isMastercard
            ? const LinearGradient(
                colors: [Color(0xfff857a6), Color(0xffff5858)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xff141e30), Color(0xff243b55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              );

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vibrant Pay',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              // Show card brand text with high clarity or icons
              Text(
                brandName.isNotEmpty ? brandName : 'CARD',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          // Card Chip asset representation
          Row(
            children: [
              Container(
                width: 45,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.yellow[600]?.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 35,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.wifi_rounded,
                color: Colors.white60,
                size: 24,
              ),
            ],
          ),
          // Masked Card Number
          Text(
            '••••  ••••  ••••  ${card.last4.isNotEmpty ? card.last4 : '••••'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARDHOLDER',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cardHolderName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${card.expiryMonth.toString().padLeft(2, '0')}/${card.expiryYear.toString().substring(card.expiryYear.toString().length - 2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
