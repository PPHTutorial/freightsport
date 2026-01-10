import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/core/presentation/widgets/empty_state.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please login')));
    }

    final chatRoomsAsync = ref.watch(chatRoomsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: GoogleFonts.redHatDisplay(fontWeight: FontWeight.bold),
        ),
      ),
      body: chatRoomsAsync.when(
        data: (rooms) {
          if (rooms.isEmpty) {
            return EmptyState(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'No Messages Yet',
              description:
                  'Start a conversation with vendors or customers to see them here.',
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: rooms.length,
            separatorBuilder: (_, __) => Divider(height: 1.h),
            itemBuilder: (context, index) {
              final room = rooms[index];
              return _ChatRoomTile(room: room, currentUserId: user.id);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ChatRoomTile extends ConsumerWidget {
  final ChatRoom room;
  final String currentUserId;
  const _ChatRoomTile({required this.room, required this.currentUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Identify the other user ID
    final otherUserId = room.participantIds.firstWhere(
      (id) => id != currentUserId,
    );

    // In a real app, we'd fetch the other user's name/photo from a user provider
    // For now, we'll use fallback or room data if we extend the model

    return ListTile(
      onTap: () => context.push('/social/chat/${room.id}', extra: otherUserId),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: const Icon(Icons.person_outline_rounded),
      ),
      title: Text(
        'User ${otherUserId.substring(0, 5)}', // Fallback
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        room.lastMessage ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: room.lastMessageAt != null
          ? Text(
              _formatTime(room.lastMessageAt!),
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.day == time.day) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}';
  }
}
