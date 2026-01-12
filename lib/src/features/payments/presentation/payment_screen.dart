import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/common/presentation/widgets/currency_display.dart';
import 'package:rightlogistics/src/features/social/application/coupon_service.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final VendorPost post;
  final int quantity;

  const PaymentScreen({super.key, required this.post, required this.quantity});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _couponController = TextEditingController();
  final _couponFocusNode = FocusNode();
  VendorPost? _appliedCoupon;
  String? _couponError;
  bool _isValidatingCoupon = false;

  String _selectedProvider = 'flutterwave'; // flutterwave, stripe, nowpayments
  String _selectedMethod = 'mobile_money';
  bool _isProcessing = false;

  // Constants
  static const double serviceFeePercent = 0.05;
  static const double taxPercent = 0.01;

  @override
  void dispose() {
    _couponController.dispose();
    _couponFocusNode.dispose();
    super.dispose();
  }

  double get _subtotal => widget.post.price * widget.quantity;

  double get _discount {
    if (_appliedCoupon == null) return 0.0;
    if (_appliedCoupon!.discountPercentage != null) {
      return _subtotal * (_appliedCoupon!.discountPercentage! / 100);
    }
    return _appliedCoupon!.discountAmount ?? 0.0;
  }

  double get _discountedSubtotal => _subtotal - _discount;
  double get _serviceFee => _discountedSubtotal * serviceFeePercent;
  double get _tax => _discountedSubtotal * taxPercent;
  double get _total => _discountedSubtotal + _serviceFee + _tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 32.0),
            Text(
              'Select Payment Method',
              style: GoogleFonts.redHatDisplay(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildPaymentProviders(),
            const SizedBox(height: 40.0),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          _buildItemBrief(),
          const Divider(height: 32.0),
          _buildSummaryRow('Subtotal', _subtotal),
          if (_appliedCoupon != null) ...[
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_offer_rounded,
                      size: 14,
                      color: AppTheme.successGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Discount (${_appliedCoupon!.promoCode})',
                      style: const TextStyle(color: AppTheme.successGreen),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_rounded,
                        size: 16,
                        color: Colors.red,
                      ),
                      onPressed: () => setState(() => _appliedCoupon = null),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ],
                ),
                Text(
                  '- ',
                  style: const TextStyle(color: AppTheme.successGreen),
                ),
                CurrencyDisplay(
                  amount: _discount,
                  fromCurrency: widget.post.currency,
                  style: const TextStyle(color: AppTheme.successGreen),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8.0),
          _buildSummaryRow('Service Fee (5%)', _serviceFee),
          const SizedBox(height: 8.0),
          _buildSummaryRow('Tax (1%)', _tax),
          const Divider(height: 32.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              CurrencyDisplay(
                amount: _total,
                fromCurrency: widget.post.currency,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildCouponSection(),
        ],
      ),
    );
  }

  Widget _buildItemBrief() {
    return Row(
      children: [
        Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey[200],
            image: widget.post.imageUrls.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(widget.post.imageUrls[0]),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.title ?? 'Item',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(
                'Quantity: ${widget.quantity}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        CurrencyDisplay(
          amount: _subtotal,
          fromCurrency: widget.post.currency,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        CurrencyDisplay(amount: amount, fromCurrency: widget.post.currency),
      ],
    );
  }

  Widget _buildCouponSection() {
    if (_appliedCoupon != null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                focusNode: _couponFocusNode,
                decoration: InputDecoration(
                  hintText: 'Enter Coupon Code',
                  errorText: _couponError,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _isValidatingCoupon ? null : _applyCoupon,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isValidatingCoupon
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentProviders() {
    // Determine methods based on user jurisdiction
    final user = ref.watch(currentUserProvider);
    final isGhana =
        user?.address?.countryCode == 'GH' ||
        user?.address?.country.toLowerCase() == 'ghana' ||
        widget.post.currency == 'GHS';

    return Column(
      children: [
        _buildProviderGroup(
          'Mobile Money & Others (Flutterwave)',
          'flutterwave',
          [
            // Ghana Specific non-card methods
            _buildMethodTile(
              'Mobile Money',
              'mobile_money',
              FontAwesomeIcons.mobileScreen,
              Colors.amber,
              'flutterwave',
            ),
            if (isGhana) ...[
              _buildMethodTile(
                'Hubtel',
                'hubtel',
                FontAwesomeIcons.plug,
                Colors.blueAccent,
                'flutterwave',
              ),
              _buildMethodTile(
                'Vodafone Cash',
                'vodafone_cash',
                FontAwesomeIcons.wallet,
                Colors.redAccent,
                'flutterwave',
              ),
            ],
            _buildMethodTile(
              'Bank Transfer',
              'bank_transfer',
              FontAwesomeIcons.bank,
              Colors.green,
              'flutterwave',
            ),
            _buildMethodTile(
              'Barter',
              'barter',
              FontAwesomeIcons.wallet,
              Colors.purple,
              'flutterwave',
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildProviderGroup('Card Payments (Stripe)', 'stripe', [
          _buildMethodTile(
            'Credit/Debit Card',
            'card',
            FontAwesomeIcons.creditCard,
            Colors.blue,
            'stripe',
          ),
        ]),
        const SizedBox(height: 24),
        _buildProviderGroup('Cryptocurrency (NowPayments)', 'nowpayments', [
          _buildMethodTile(
            'Crypto Wallet',
            'crypto',
            FontAwesomeIcons.bitcoin,
            Colors.orange,
            'nowpayments',
          ),
        ]),
      ],
    );
  }

  Widget _buildProviderGroup(String title, String id, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildMethodTile(
    String label,
    String id,
    IconData icon,
    Color color,
    String provider,
  ) {
    final isSelected = _selectedMethod == id && _selectedProvider == provider;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedMethod = id;
        _selectedProvider = provider;
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.0,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : () => _processPayment(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.successGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'PAY ',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  CurrencyDisplay(
                    amount: _total,
                    fromCurrency: widget.post.currency,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isValidatingCoupon = true;
      _couponError = null;
    });

    try {
      final coupon = await ref
          .read(couponServiceProvider)
          .validateCoupon(
            code: code,
            vendorId: widget.post.vendorId,
            orderAmount: _subtotal,
          );

      setState(() {
        _appliedCoupon = coupon;
        _couponController.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Coupon applied successfully!')),
        );
      }
    } catch (e) {
      setState(() => _couponError = e.toString());
    } finally {
      if (mounted) setState(() => _isValidatingCoupon = false);
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    // MOCK Server-side Processing
    try {
      // Simulate network delay to local server
      await Future.delayed(const Duration(seconds: 3));

      // Call mock endpoint
      // res = await http.post(Uri.parse('api/payments/$_selectedProvider/initiate'), body: {...});

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppTheme.successGreen,
                size: 40.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Payment Successful!',
              style: GoogleFonts.redHatDisplay(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your pre-order has been secured via $_selectedProvider.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close PaymentScreen
            },
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }
}
