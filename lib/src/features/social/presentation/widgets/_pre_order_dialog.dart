import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';

class _PreOrderDialog extends StatefulWidget {
  final VendorPost post;
  const _PreOrderDialog({required this.post});

  @override
  State<_PreOrderDialog> createState() => _PreOrderDialogState();
}

class _PreOrderDialogState extends State<_PreOrderDialog> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalPrice = widget.post.price * _quantity;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400.w),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24.w),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Product Preview
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.post.imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.w),
                    child: CachedNetworkImage(
                      imageUrl: widget.post.imageUrls[0],
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.title ?? 'Pre-Order Item',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '${widget.post.currency} ${widget.post.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Quantity Selector
            Text(
              'Quantity',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _QuantityButton(
                  icon: Icons.remove,
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                ),
                SizedBox(width: 16.w),
                Container(
                  width: 60.w,
                  alignment: Alignment.center,
                  child: Text(
                    '$_quantity',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                _QuantityButton(
                  icon: Icons.add,
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Total
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${widget.post.currency} ${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _proceedToPurchase();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentOrange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'PROCEED TO PURCHASE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToPurchase() {
    // TODO: Implement purchase/payment flow
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchase of $_quantity item(s) initiated!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: onPressed != null
          ? AppTheme.accentOrange
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8.w),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.w),
        child: Container(
          width: 40.w,
          height: 40.w,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: onPressed != null
                ? Colors.white
                : colorScheme.onSurfaceVariant.withOpacity(0.5),
            size: 20.w,
          ),
        ),
      ),
    );
  }
}
