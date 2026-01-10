import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/common/data/seeding_service.dart';
import 'package:rightlogistics/src/features/common/data/cascade_delete_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:intl/intl.dart';

class SeedingDashboardScreen extends ConsumerStatefulWidget {
  const SeedingDashboardScreen({super.key});

  @override
  ConsumerState<SeedingDashboardScreen> createState() =>
      _SeedingDashboardScreenState();
}

class _SeedingDashboardScreenState
    extends ConsumerState<SeedingDashboardScreen> {
  // --- Seeding State ---
  UserRole _selectedRole = UserRole.customer;
  int _userSeedCount = 10;
  int _shipmentSeedCount = 20;
  int _reviewSeedCount = 5;

  bool _isWorking = false;
  // ignore: unused_field
  String? _statusMessage;
  List<String> _logs = [];

  // --- Data Management State ---
  List<Map<String, dynamic>> _loadedUsers = [];
  Set<String> _selectedUserIds = {};
  String _searchQuery = '';
  bool _isLoadingUsers = false;

  // --- Counts ---
  int _totalUsers = 0;
  int _totalShipments = 0;
  int _totalSocial = 0;

  final ScrollController _consoleController = ScrollController();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    await Future.wait([_fetchStats(), _fetchUsers()]);
  }

  Future<void> _fetchStats() async {
    try {
      final db = FirebaseFirestore.instance;
      final results = await Future.wait([
        db.collection('users').count().get(),
        db.collection('shipments').count().get(),
        db.collection('posts').count().get(),
        db.collection('reviews').count().get(),
      ]);
      if (mounted) {
        setState(() {
          _totalUsers = results[0].count ?? 0;
          _totalShipments = results[1].count ?? 0;
          // Combine posts + reviews for social stats
          _totalSocial = (results[2].count ?? 0) + (results[3].count ?? 0);
        });
      }
    } catch (e) {
      _logError('Stats Error', e);
    }
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoadingUsers = true);
    try {
      // Basic fetch, optimized for admin view
      // Removed orderBy('createdAt') as it might filter out older seeded users without that field
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          // .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      _loadedUsers = snapshot.docs.map((d) {
        final data = d.data();
        return {
          'id': d.id,
          'name': data['name'] ?? 'Unknown',
          'email': data['email'] ?? 'No Email',
          'role': data['role'] ?? 'unknown',
          'photoUrl': data['photoUrl'],
        };
      }).toList();
    } catch (e) {
      _logError('Fetch Users Error', e);
    } finally {
      if (mounted) setState(() => _isLoadingUsers = false);
    }
  }

  // --- Actions ---

  Future<void> _executeTask(String name, Future<void> Function() task) async {
    if (_isWorking) return;
    setState(() {
      _isWorking = true;
      _logs.add('> START: $name');
    });

    try {
      await task();
      _log('✅ $name Complete');
      _refreshData();
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$name Done')));
    } catch (e, st) {
      _logError(name, e);
      debugPrintStack(stackTrace: st);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  void _log(String msg) {
    if (!mounted) return;
    setState(() {
      _logs.add('${DateFormat('HH:mm:ss').format(DateTime.now())} $msg');
    });
    _scrollToBottom();
  }

  void _logError(String context, Object error) {
    _log('❌ $context: $error');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_consoleController.hasClients) {
        _consoleController.animateTo(
          _consoleController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // --- Generators ---

  Future<void> _seedUsers() async {
    await _executeTask(
      'Generating ${_selectedRole.name.toUpperCase()}s',
      () async {
        await ref
            .read(seedingServiceProvider)
            .seedUsers(
              // Map UI selection to specific counts
              adminCount: _selectedRole == UserRole.admin ? _userSeedCount : 0,
              vendorCount: _selectedRole == UserRole.vendor
                  ? _userSeedCount
                  : 0,
              courierCount: _selectedRole == UserRole.courier
                  ? _userSeedCount
                  : 0,
              customerCount: _selectedRole == UserRole.customer
                  ? _userSeedCount
                  : 0,
              onProgress: (p, m) => _log(m),
            );
      },
    );
  }

  Future<void> _seedShipments() async {
    await _executeTask('Generating $_shipmentSeedCount Shipments', () async {
      await ref
          .read(seedingServiceProvider)
          .seedShipments(
            count: _shipmentSeedCount,
            onProgress: (p, m) => _log(m),
          );
    });
  }

  Future<void> _seedSocial() async {
    await _executeTask('Generating Social Content', () async {
      final service = ref.read(seedingServiceProvider);
      await service.seedSocial(onProgress: (p, m) => _log(m));
      await service.seedChats(onProgress: (p, m) => _log(m));
      await service.seedNotifications(onProgress: (p, m) => _log(m));
      await service.seedReviews(
        reviewsPerUser: _reviewSeedCount,
        onProgress: (p, m) => _log(m),
      );
    });
  }

  // --- Deletion ---

  Future<void> _deleteSelected() async {
    if (_selectedUserIds.isEmpty) return;
    await _executeTask('Deleting ${_selectedUserIds.length} Users', () async {
      await CascadeDeleteService().deleteSelectedUsers(
        _selectedUserIds.toList(),
        onProgress: (m) => _log(m),
      );
      setState(() => _selectedUserIds.clear());
    });
  }

  Future<void> _nukeSystem() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('⚠️ FACTORY RESET'),
        content: const Text('Delete ALL data? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('DELETE EVERYTHING'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final currentUserId = ref.read(currentUserProvider)?.id;
      final protected = currentUserId != null ? [currentUserId] : <String>[];
      await _executeTask('System Wipe', () async {
        await CascadeDeleteService().deleteAllDataExcept(protected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: const Text('Data Management'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: _isWorking ? const LinearProgressIndicator(minHeight: 2) : const SizedBox(height: 1, child: Divider(height: 1)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
      ), */
      body: Column(
        children: [
          SizedBox(height: 16.h),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildUserManagementPanel(),
                const SizedBox(height: 8),
                _buildLogisticsPanel(),
                const SizedBox(height: 8),
                _buildEngagementPanel(),
                const SizedBox(height: 8),
                _buildDangerZone(),
              ],
            ),
          ),
          _buildConsole(),
        ],
      ),
    );
  }

  // --- Panels ---

  Widget _buildUserManagementPanel() {
    return Card(
      child: ExpansionTile(
        title: Text('User Management (${_totalUsers})'),
        leading: const Icon(Icons.people),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.all(16),
        children: [
          // Generator
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<UserRole>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: UserRole.values
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedRole = v!),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 70,
                child: TextFormField(
                  initialValue: _userSeedCount.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Count',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (v) => _userSeedCount = int.tryParse(v) ?? 10,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _isWorking ? null : _seedUsers,
                icon: const Icon(Icons.add),
                label: const Text('Generate'),
              ),
            ],
          ),
          const Divider(height: 32),

          // User List Controls
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search By Name...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
              const SizedBox(width: 12),
              if (_selectedUserIds.isNotEmpty)
                FilledButton.icon(
                  onPressed: _deleteSelected,
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  icon: const Icon(Icons.delete),
                  label: Text('Del (${_selectedUserIds.length})'),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // User Table
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: _isLoadingUsers
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: _filteredUsers.length,
                    separatorBuilder: (c, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      final isSelected = _selectedUserIds.contains(user['id']);
                      return ListTile(
                        dense: true,
                        selected: isSelected,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundImage: user['photoUrl'] != null
                              ? NetworkImage(user['photoUrl'])
                              : null,
                          child: user['photoUrl'] == null
                              ? const Icon(Icons.person, size: 16)
                              : null,
                        ),
                        title: Text(
                          user['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${user['role']} • ${user['email']}'),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedUserIds.add(user['id']);
                              } else {
                                _selectedUserIds.remove(user['id']);
                              }
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedUserIds.remove(user['id']);
                            } else {
                              _selectedUserIds.add(user['id']);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogisticsPanel() {
    return Card(
      child: ExpansionTile(
        title: Text('Logistics (${_totalShipments} items)'),
        leading: const Icon(Icons.local_shipping),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          // Shipments
          Row(
            children: [
              const Expanded(child: Text('Shipments to Generate:')),
              SizedBox(
                width: 120,
                child: _buildCounterControl(
                  _shipmentSeedCount,
                  (v) => setState(() => _shipmentSeedCount = v),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _isWorking ? null : _seedShipments,
                child: const Text('Seed'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementPanel() {
    return Card(
      child: ExpansionTile(
        title: Text('Engagement (Total: $_totalSocial)'),
        leading: const Icon(Icons.favorite),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          // Reviews Control
          Row(
            children: [
              const Expanded(child: Text('Generate Reviews per User:')),
              SizedBox(
                width: 120,
                child: _buildCounterControl(
                  _reviewSeedCount,
                  (v) => setState(() => _reviewSeedCount = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Seed Social Content & Reviews'),
            subtitle: const Text(
              'Posts, Comments, Chats, Notifications, Reviews',
            ),
            trailing: FilledButton(
              onPressed: _isWorking ? null : _seedSocial,
              child: const Text('Run'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return Card(
      color: Colors.red.shade50,
      child: ExpansionTile(
        title: const Text(
          'System Zone',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.warning, color: Colors.red),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _nukeSystem,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.all(16),
              ),
              icon: const Icon(Icons.delete_forever),
              label: const Text('WIPE ALL DATABASE DATA'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsole() {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        color: Color(0xFF222222),
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Console Output',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _consoleController,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemCount: _logs.length,
              itemBuilder: (c, i) => Text(
                _logs[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterControl(int value, Function(int) onChange) {
    return Row(
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.remove, size: 16),
          onPressed: () => onChange((value - 10).clamp(0, 500)),
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        ),
        Expanded(
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.add, size: 16),
          onPressed: () => onChange((value + 10).clamp(0, 500)),
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchQuery.isEmpty) return _loadedUsers;
    return _loadedUsers.where((u) {
      final name = u['name'].toString().toLowerCase();
      final email = u['email'].toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase()) ||
          email.contains(_searchQuery.toLowerCase());
    }).toList();
  }
}
