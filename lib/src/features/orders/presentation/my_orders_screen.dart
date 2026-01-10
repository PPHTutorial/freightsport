import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/core/presentation/widgets/empty_state.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/tracking/data/shipment_repository.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:intl/intl.dart';

final myOrdersProvider = FutureProvider.autoDispose<List<Shipment>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  // Use .id as fixed in user_model
  return ref.read(shipmentRepositoryProvider).getShipmentsForUser(user.id);
});

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  String _selectedFilter = 'All';

  List<Shipment> _filterShipments(List<Shipment> shipments) {
    if (_selectedFilter == 'All') return shipments;
    if (_selectedFilter == 'Active') {
      return shipments
          .where(
            (s) =>
                s.currentStatus != ShipmentStatusType.delivered &&
                s.currentStatus != ShipmentStatusType.cancelled,
          )
          .toList();
    }
    if (_selectedFilter == 'Delivered') {
      return shipments
          .where((s) => s.currentStatus == ShipmentStatusType.delivered)
          .toList();
    }
    if (_selectedFilter == 'Cancelled') {
      return shipments
          .where((s) => s.currentStatus == ShipmentStatusType.cancelled)
          .toList();
    }
    return shipments;
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: ordersAsync.when(
            data: (orders) {
              final filteredOrders = _filterShipments(orders);
              return RefreshIndicator(
                onRefresh: () => ref.refresh(myOrdersProvider.future),
                child: filteredOrders.isEmpty
                    ? EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'No Orders Found',
                        description:
                            'You haven\'t placed any orders with this status yet.',
                        actionLabel: 'Create Shipment',
                        onAction: () {
                          // Trigger new shipment flow
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(24),
                        itemCount: filteredOrders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _buildOrderCard(filteredOrders[index]);
                        },
                      ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 8),
          _buildFilterChip('Created'),
          const SizedBox(width: 8),
          _buildFilterChip('Picked Up'),
          const SizedBox(width: 8),
          _buildFilterChip('In Transit'),
          const SizedBox(width: 8),
          _buildFilterChip('Out For Delivery'),
          const SizedBox(width: 8),
          _buildFilterChip('Delivered'),
          const SizedBox(width: 8),
          _buildFilterChip('Cancelled'),
          const SizedBox(width: 8),
          _buildFilterChip('Failed'),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Shipment shipment) {
    Color statusColor;
    String statusText = '';

    switch (shipment.currentStatus) {
      case ShipmentStatusType.created:
        statusColor = Colors.blue;
        statusText = 'CREATED';
        break;
      case ShipmentStatusType.pickedUp:
        statusColor = Colors.orange;
        statusText = 'PICKED UP';
        break;
      case ShipmentStatusType.inTransit:
        statusColor = AppTheme.accentOrange;
        statusText = 'IN TRANSIT';
        break;
      case ShipmentStatusType.outForDelivery:
        statusColor = Colors.purple;
        statusText = 'OUT FOR DELIVERY';
        break;
      case ShipmentStatusType.delivered:
        statusColor = AppTheme.successGreen;
        statusText = 'DELIVERED';
        break;
      case ShipmentStatusType.failedAttempt:
        statusColor = AppTheme.errorRed;
        statusText = 'FAILED';
        break;
      case ShipmentStatusType.cancelled:
        statusColor = Colors.red;
        statusText = 'CANCELLED';
        break;
    }

    return GestureDetector(
      onTap: () => context.push('/tracking?code=${shipment.trackingNumber}'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          shipment.trackingNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: shipment.trackingNumber),
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Tracking ID copied to clipboard',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.copy_rounded,
                            size: 16,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppTheme.textGrey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        shipment.recipientAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM d, y').format(shipment.createdAt),
                      style: const TextStyle(
                        color: AppTheme.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
