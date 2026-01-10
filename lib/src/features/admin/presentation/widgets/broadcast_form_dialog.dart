import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/domain/admin_models.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

class BroadcastFormDialog extends ConsumerStatefulWidget {
  final BroadcastMessage? broadcast;

  const BroadcastFormDialog({super.key, this.broadcast});

  @override
  ConsumerState<BroadcastFormDialog> createState() =>
      _BroadcastFormDialogState();
}

class _BroadcastFormDialogState extends ConsumerState<BroadcastFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _actionUrlController;
  late TextEditingController _actionLabelController;
  late BroadcastPriority _selectedPriority;
  late Set<UserRole> _selectedTargetRoles;
  DateTime? _scheduledFor;
  DateTime? _expiresAt;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.broadcast?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.broadcast?.content ?? '',
    );
    _actionUrlController = TextEditingController(
      text: widget.broadcast?.actionUrl ?? '',
    );
    _actionLabelController = TextEditingController(
      text: widget.broadcast?.actionLabel ?? '',
    );
    _selectedPriority = widget.broadcast?.priority ?? BroadcastPriority.normal;
    _selectedTargetRoles = widget.broadcast?.targetRoles.toSet() ?? {};
    _scheduledFor = widget.broadcast?.scheduledFor;
    _expiresAt = widget.broadcast?.expiresAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _actionUrlController.dispose();
    _actionLabelController.dispose();
    super.dispose();
  }

  Future<void> _saveBroadcast() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      final currentUser = ref.read(currentUserProvider);

      if (currentUser == null) throw Exception('No authenticated user');

      final now = DateTime.now();

      if (widget.broadcast == null) {
        // Create new broadcast
        final newBroadcast = BroadcastMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          senderId: currentUser.id,
          senderName: currentUser.name,
          senderRole: currentUser.role,
          targetRoles: _selectedTargetRoles.toList(),
          priority: _selectedPriority,
          status: _scheduledFor != null
              ? BroadcastStatus.scheduled
              : BroadcastStatus.draft,
          createdAt: now,
          scheduledFor: _scheduledFor,
          expiresAt: _expiresAt,
          actionUrl: _actionUrlController.text.trim().isEmpty
              ? null
              : _actionUrlController.text.trim(),
          actionLabel: _actionLabelController.text.trim().isEmpty
              ? null
              : _actionLabelController.text.trim(),
        );

        await repository.createBroadcast(newBroadcast);
      } else {
        // Update existing broadcast
        final updatedBroadcast = widget.broadcast!.copyWith(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          targetRoles: _selectedTargetRoles.toList(),
          priority: _selectedPriority,
          scheduledFor: _scheduledFor,
          expiresAt: _expiresAt,
          actionUrl: _actionUrlController.text.trim().isEmpty
              ? null
              : _actionUrlController.text.trim(),
          actionLabel: _actionLabelController.text.trim().isEmpty
              ? null
              : _actionLabelController.text.trim(),
        );

        await repository.updateBroadcast(updatedBroadcast);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.broadcast == null
                  ? 'Broadcast created successfully'
                  : 'Broadcast updated successfully',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600.w, maxHeight: 700.h),
        padding: EdgeInsets.all(24.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.broadcast == null
                          ? 'Create Broadcast'
                          : 'Edit Broadcast',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 24.w),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                  validator: (value) => value?.trim().isEmpty ?? true
                      ? 'Title is required'
                      : null,
                ),
                SizedBox(height: 16.h),

                // Content
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    prefixIcon: const Icon(Icons.message),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) => value?.trim().isEmpty ?? true
                      ? 'Content is required'
                      : null,
                ),
                SizedBox(height: 16.h),

                // Priority
                Text(
                  'Priority',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  children: BroadcastPriority.values.map((priority) {
                    final isSelected = _selectedPriority == priority;
                    return FilterChip(
                      selected: isSelected,
                      label: Text(priority.name.toUpperCase()),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedPriority = priority);
                        }
                      },
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      selectedColor: _getPriorityColor(
                        priority,
                      ).withOpacity(0.2),
                      checkmarkColor: _getPriorityColor(priority),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),

                // Target Roles
                Text(
                  'Target Roles (empty = all)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  children: UserRole.values.map((role) {
                    final isSelected = _selectedTargetRoles.contains(role);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(role.name.toUpperCase()),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTargetRoles.add(role);
                          } else {
                            _selectedTargetRoles.remove(role);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),

                // Action URL & Label
                TextFormField(
                  controller: _actionUrlController,
                  decoration: InputDecoration(
                    labelText: 'Action URL (Optional)',
                    prefixIcon: const Icon(Icons.link),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _actionLabelController,
                  decoration: InputDecoration(
                    labelText: 'Action Label (Optional)',
                    prefixIcon: const Icon(Icons.label),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Schedule & Expiry
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _scheduledFor ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null && mounted) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                _scheduledFor = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          }
                        },
                        icon: const Icon(Icons.schedule),
                        label: Text(
                          _scheduledFor == null
                              ? 'Schedule'
                              : 'Scheduled: ${_scheduledFor!.toString().substring(0, 16)}',
                          style: TextStyle(fontSize: 11.sp),
                        ),
                      ),
                    ),
                    if (_scheduledFor != null) ...[
                      SizedBox(width: 8.w),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _scheduledFor = null),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate:
                                _expiresAt ??
                                DateTime.now().add(const Duration(days: 7)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) setState(() => _expiresAt = date);
                        },
                        icon: const Icon(Icons.event),
                        label: Text(
                          _expiresAt == null
                              ? 'Set Expiry'
                              : 'Expires: ${_expiresAt!.toString().substring(0, 10)}',
                          style: TextStyle(fontSize: 11.sp),
                        ),
                      ),
                    ),
                    if (_expiresAt != null) ...[
                      SizedBox(width: 8.w),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _expiresAt = null),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 24.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveBroadcast,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            widget.broadcast == null
                                ? 'CREATE BROADCAST'
                                : 'UPDATE BROADCAST',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(BroadcastPriority priority) {
    switch (priority) {
      case BroadcastPriority.low:
        return Colors.grey;
      case BroadcastPriority.normal:
        return Colors.blue;
      case BroadcastPriority.high:
        return Colors.orange;
      case BroadcastPriority.urgent:
        return Colors.red;
    }
  }
}
