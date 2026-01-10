import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';

class ChatMessagesScreen extends ConsumerStatefulWidget {
  final String otherUserId;
  final String? initialMessage;
  const ChatMessagesScreen({
    super.key,
    required this.otherUserId,
    this.initialMessage,
  });

  @override
  ConsumerState<ChatMessagesScreen> createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends ConsumerState<ChatMessagesScreen> {
  final _messageController = TextEditingController();
  String? _roomId;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final repo = ref.read(socialRepositoryProvider);
    final room = await repo.getOrCreateChatRoom(
      currentUser.id,
      widget.otherUserId,
    );
    setState(() => _roomId = room.id);

    if (widget.initialMessage != null) {
      final message = Message(
        id: '',
        senderId: currentUser.id,
        content: widget.initialMessage!,
        createdAt: DateTime.now(),
      );
      repo.sendMessage(room.id, message);
    }
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty || _roomId == null) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final text = _messageController.text.trim();
    _messageController.clear();

    final message = Message(
      id: '',
      senderId: currentUser.id,
      content: text,
      createdAt: DateTime.now(),
    );

    ref.read(socialRepositoryProvider).sendMessage(_roomId!, message);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (_roomId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final messagesAsync = ref.watch(
      postCommentsProvider(_roomId!),
    ); // Using this as a proxy for messages for now if not defined

    return Scaffold(
      /* appBar: AppBar(
        title: Text(
          'Chat',
          style: GoogleFonts.redHatDisplay(fontWeight: FontWeight.bold),
        ),
      ), */
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: ref
                  .watch(socialRepositoryProvider)
                  .watchMessages(_roomId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUser?.id;
                    return _MessageBubble(message: msg, isMe: isMe);
                  },
                );
              },
            ),
          ),
          _buildInputArea(colorScheme),
        ],
      ),
    );
  }

  Widget _buildInputArea(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send_rounded, color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(20),
            bottomLeft: isMe
                ? const Radius.circular(20)
                : const Radius.circular(0),
          ),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
