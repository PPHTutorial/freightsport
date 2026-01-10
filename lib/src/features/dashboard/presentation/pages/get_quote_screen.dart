import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/core/constants/app_data.dart';
import 'package:rightlogistics/src/core/presentation/widgets/glass_card.dart';
import 'package:rightlogistics/src/core/presentation/widgets/gradient_button.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';

class GetQuoteScreen extends StatefulWidget {
  const GetQuoteScreen({super.key});

  @override
  State<GetQuoteScreen> createState() => _GetQuoteScreenState();
}

class _GetQuoteScreenState extends State<GetQuoteScreen> {
  String _freightType = 'Air';
  String _deliverySpeed = 'Express';
  String _itemCategory = 'Normal';
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _cbmController = TextEditingController();
  double _estimatedTotal = 0.0;
  String _currency = '\$';

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_calculatePrice);
    _cbmController.addListener(_calculatePrice);
  }

  void _calculatePrice() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double cbm = double.tryParse(_cbmController.text) ?? 0;
    double price = 0;

    if (_freightType == 'Air') {
      _currency = '\$';
      if (_itemCategory == 'Phone') {
        price = weight * AppData.phoneRateFlat; // Here weight acts as quantity
        _currency = '\$'; //'GH₵';
      } else if (_itemCategory == 'Laptop') {
        price = weight * AppData.laptopRatePerKg;
      } else {
        final rates = _deliverySpeed == 'Express'
            ? AppData.airExpressRates
            : AppData.airNormalRates;
        final rate =
            (_itemCategory == 'Sensitive (Battery/Powder/Liquid/Chemical)')
            ? rates['dangerous']!
            : rates['normal']!;
        price = weight * rate;
      }
    } else {
      _currency = '\$';
      final rate = (_itemCategory == 'Special (Machine/Battery)')
          ? AppData.seaRates['special']!
          : AppData.seaRates['normal']!;
      price = cbm * rate;
    }

    setState(() {
      _estimatedTotal = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get a Shipping Quote',
              style: GoogleFonts.redHatDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Calculate your shipping cost based on our current rates.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            _buildTypeSelector(),
            const SizedBox(height: 24),

            if (_freightType == 'Air')
              _buildAirOptions()
            else
              _buildSeaOptions(),

            const SizedBox(height: 24),
            _buildCategorySelector(),

            const SizedBox(height: 24),
            _buildInputs(),

            const SizedBox(height: 48),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: ['Air', 'Sea'].map((type) {
        final isSelected = _freightType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _freightType = type;
                _itemCategory = 'Normal';
                _calculatePrice();
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: type == 'Air' ? 12 : 0),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.accentOrange
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    type == 'Air'
                        ? Icons.airplanemode_active_rounded
                        : Icons.directions_boat_rounded,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : AppTheme.accentOrange,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$type Freight',
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : AppTheme.accentOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAirOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Speed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: ['Express', 'Normal'].map((speed) {
            final isSelected = _deliverySpeed == speed;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _deliverySpeed = speed;
                    _calculatePrice();
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: speed == 'Express' ? 12 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentOrange.withOpacity(0.1)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentOrange
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      speed,
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.accentOrange
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSeaOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sea freight duration: 45-60 days',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = _freightType == 'Air'
        ? [
            'Normal Goods',
            'Sensitive (Battery/Powder/Liquid/Chemical)',
            'Phone',
            'Laptop',
          ]
        : ['Normal Delivery', 'Special (Machine/Battery)'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final isSelected = _itemCategory == cat;
            return FilterChip(
              selected: isSelected,
              label: Text(cat),
              onSelected: (val) {
                setState(() {
                  _itemCategory = cat;
                  _calculatePrice();
                });
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
              checkmarkColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.accentOrange
                    : Theme.of(context).colorScheme.surface.withOpacity(0.6),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInputs() {
    final isWeight = _freightType == 'Air';
    final label = _itemCategory == 'Phone'
        ? 'Quantity'
        : (isWeight ? 'Weight (kg)' : 'Volume (CBM)');
    final hint = _itemCategory == 'Phone'
        ? 'Number of units'
        : (isWeight ? '0.0 kg' : '0.0 CBM');
    final controller = isWeight ? _weightController : _cbmController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,

          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              isWeight
                  ? Icons.monitor_weight_rounded
                  : Icons.view_in_ar_rounded,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      color: Theme.of(context).colorScheme.primary,
      opacity: 0.9,
      child: Column(
        children: [
          Text(
            'Estimated Total',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_currency${_estimatedTotal.toStringAsFixed(2)}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Divider(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
          ),
          const SizedBox(height: 24),
          GradientButton(
            text: 'Book This Shipment',
            onPressed: () {
              // Navigate to booking with these pre-filled values
              context.push('/admin/create-shipment');
            },
          ),
        ],
      ),
    );
  }
}
