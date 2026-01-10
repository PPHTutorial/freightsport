import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rightlogistics/src/core/presentation/widgets/empty_state.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/tracking/presentation/tracking_controller.dart';
import 'package:rightlogistics/src/features/tracking/data/shipment_repository.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _trackingController = TextEditingController();
  String _currentTrackingQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Use microtask to ensure GoRouter is available if called from builder
    Future.microtask(() {
      if (mounted) {
        final code = GoRouterState.of(context).uri.queryParameters['code'];
        if (code != null && code.isNotEmpty) {
          _trackingController.text = code;
          setState(() {
            _currentTrackingQuery = code;
          });
        }
      }
    });
  }

  void _track() {
    if (_trackingController.text.isNotEmpty) {
      setState(() {
        _currentTrackingQuery = _trackingController.text.trim();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _trackingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // "Logistics too should have no action icon for now"
    Future.microtask(() {
      final location = GoRouterState.of(context).uri.path;
      ref
          .read(appBarConfigProvider(location).notifier)
          .setConfig(
            const AppBarConfig(
              title: 'Shipment Tracking',
              actions: [], // Explicitly empty
            ),
          );
    });

    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildMyOrdersTab(), _buildTrackingTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30.w),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30.w),
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 8.w,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(
            child: Text(
              'My Orders',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Tab(
            child: Text(
              'Track ID',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTab() {
    return Column(
      children: [
        // Search Header
        Padding(
          padding: EdgeInsets.all(24.w),
          child: TextField(
            controller: _trackingController,
            onSubmitted: (_) => _track(),
            decoration: InputDecoration(
              hintText: 'Enter Tracking ID (e.g., 123456)',
              prefixIcon: Icon(
                Icons.location_searching_rounded,
                color: Theme.of(context).colorScheme.secondary,
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: IconButton(
                  onPressed: _track,
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 1),

        // Results Area
        Expanded(
          child: _currentTrackingQuery.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64.w,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Enter a tracking number to see details',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                )
              : _ShipmentDetails(trackingNumber: _currentTrackingQuery),
        ),
      ],
    );
  }

  Widget _buildMyOrdersTab() {
    return _MyOrdersTab(tabController: _tabController);
  }
}

class _MyOrdersTab extends ConsumerStatefulWidget {
  final TabController tabController;
  const _MyOrdersTab({required this.tabController});

  @override
  ConsumerState<_MyOrdersTab> createState() => _MyOrdersTabState();
}

class _MyOrdersTabState extends ConsumerState<_MyOrdersTab> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const Center(child: Text('Please login'));

    final ordersAsync = ref.watch(_myOrdersProvider(user.id));

    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: ordersAsync.when(
            data: (orders) {
              final filteredOrders = _filterShipments(orders);
              return RefreshIndicator(
                onRefresh: () => ref.refresh(_myOrdersProvider(user.id).future),
                child: filteredOrders.isEmpty
                    ? EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'No Orders Found',
                        description: 'Your orders will appear here.',
                        actionLabel: 'Create Shipment',
                        onAction: () => widget.tabController.animateTo(0),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.all(24.w),
                        itemCount: filteredOrders.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16.h),
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

  List<Shipment> _filterShipments(List<Shipment> shipments) {
    if (_selectedFilter == 'All') return shipments;
    if (_selectedFilter == 'Created') {
      return shipments
          .where((s) => s.currentStatus != ShipmentStatusType.created)
          .toList();
    }
    if (_selectedFilter == 'Out for Delivery') {
      return shipments
          .where((s) => s.currentStatus == ShipmentStatusType.outForDelivery)
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
    if (_selectedFilter == 'Failed') {
      return shipments
          .where((s) => s.currentStatus == ShipmentStatusType.failedAttempt)
          .toList();
    }
    if (_selectedFilter == 'IN Transit') {
      return shipments
          .where((s) => s.currentStatus == ShipmentStatusType.inTransit)
          .toList();
    }
    if (_selectedFilter == 'Picked Up') {
      return shipments
          .where((s) => s.currentStatus == ShipmentStatusType.pickedUp)
          .toList();
    }
    return shipments;
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        children:
            [
              'All',
              'Created',
              'IN Transit',
              'Picked Up',
              'Out for Delivery',
              'Delivered',
              'Cancelled',
              'Failed',
            ].map((f) {
              final isSelected = _selectedFilter == f;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: Text(f),
                  selected: isSelected,
                  onSelected: (val) => setState(() => _selectedFilter = f),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildOrderCard(Shipment shipment) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15.w,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shipment.trackingNumber,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.sp),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Text(
                  shipment.currentStatus.name.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 18.w,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  shipment.recipientAddress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                DateFormat('MMM d, y').format(shipment.createdAt),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final _myOrdersProvider = FutureProvider.family
    .autoDispose<List<Shipment>, String>((ref, userId) {
      return ref.read(shipmentRepositoryProvider).getShipmentsForUser(userId);
    });

class _ShipmentDetails extends ConsumerWidget {
  final String trackingNumber;

  const _ShipmentDetails({required this.trackingNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipmentAsync = ref.watch(trackingControllerProvider(trackingNumber));

    return shipmentAsync.when(
      data: (shipment) {
        if (shipment == null) {
          return Center(
            child: Text(
              'No shipment found for $trackingNumber',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }
        return ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Status Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tracking #${shipment.trackingNumber}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _formatStatus(shipment.currentStatus),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 28.sp,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoColumn(
                            label: 'From',
                            value: shipment.senderAddress,
                            sub: shipment.senderName,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        Expanded(
                          child: _InfoColumn(
                            label: 'To',
                            value: shipment.recipientAddress,
                            sub: shipment.recipientName,
                            alignRight: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text('Timeline', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16.h),
            ...shipment.events.map((event) => _TimelineItem(event: event)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  String _formatStatus(ShipmentStatusType status) {
    return status.toString().split('.').last.replaceAll('_', ' ').toUpperCase();
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final bool alignRight;

  const _InfoColumn({
    required this.label,
    required this.value,
    required this.sub,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final crossAlign = alignRight
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final textAlign = alignRight ? TextAlign.right : TextAlign.left;

    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          textAlign: textAlign,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          sub,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ShipmentEvent event;

  const _TimelineItem({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2.w,
                height: 40.h,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.status.toString().split('.').last.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy - h:mm a').format(event.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (event.note != null) ...[
                  SizedBox(height: 4.h),
                  Text(event.note!),
                ],
                SizedBox(height: 4.h),
                Text(
                  event.location.address,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
