import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/features/social/domain/status_model.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';

class StatusViewerScreen extends ConsumerStatefulWidget {
  final List<StatusModel> statuses;
  final int initialIndex;

  const StatusViewerScreen({
    super.key,
    required this.statuses,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<StatusViewerScreen> createState() => _StatusViewerScreenState();
}

class _StatusViewerScreenState extends ConsumerState<StatusViewerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStatus();
      }
    });

    _animController.forward();

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    // Restore status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _nextStatus() {
    if (_currentIndex < widget.statuses.length - 1) {
      setState(() {
        _currentIndex++;
        _animController.reset();
        _animController.forward();
      });
    } else {
      context.pop();
    }
  }

  void _prevStatus() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _animController.reset();
        _animController.forward();
      });
    }
  }

  void _pause() {
    _animController.stop();
  }

  void _resume() {
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.statuses.isEmpty) return const SizedBox();
    final currentStatus = widget.statuses[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 3) {
            _prevStatus();
          } else {
            _nextStatus(); // Tap middle or right -> next
          }
          _resume();
        },
        onDoubleTap: () {
          _handleLike();
          _showLikeAnimation();
        },
        onLongPressStart: (_) => _pause(),
        onLongPressEnd: (_) => _resume(),
        child: Stack(
          children: [
            // Image/Media
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: currentStatus.mediaUrl,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) =>
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.white),
              ),
            ),

            // Top Gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Bottom Gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // UI Content
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
              ),
              child: Column(
                children: [
                  // Progress Bars
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      children: List.generate(widget.statuses.length, (index) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _buildProgressBar(index),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: currentStatus.vendorPhotoUrl != null
                              ? CachedNetworkImageProvider(
                                  currentStatus.vendorPhotoUrl!,
                                )
                              : null,
                          child: currentStatus.vendorPhotoUrl == null
                              ? Text(currentStatus.vendorName[0])
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentStatus.vendorName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _formatTime(currentStatus.createdAt),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Caption
                  if (currentStatus.caption != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        currentStatus.caption!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  _buildBottomEngagement(context, currentStatus),
                ],
              ),
            ),
            if (_showHeart)
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value < 0.8 ? value : 1.0 - value,
                      child: Transform.scale(
                        scale: value * 2,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _showHeart = false;
  void _showLikeAnimation() {
    setState(() => _showHeart = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  void _handleLike() {
    final status = widget.statuses[_currentIndex];
    final user = ref.read(currentUserProvider);
    if (user != null) {
      if (status.likeIds.contains(user.id)) {
        ref.read(socialRepositoryProvider).unlikeStatus(status.id, user.id);
      } else {
        ref.read(socialRepositoryProvider).likeStatus(status.id, user.id);
      }
    }
  }

  Widget _buildBottomEngagement(BuildContext context, StatusModel status) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Reply to ${status.vendorName}...',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _StatusActionButton(icon: Icons.favorite_border, onTap: _handleLike),
          const SizedBox(width: 8),
          _StatusActionButton(icon: Icons.send_rounded, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int index) {
    if (index < _currentIndex) {
      // Completed
      return const LinearProgressIndicator(
        value: 1.0,
        valueColor: AlwaysStoppedAnimation(Colors.white),
        backgroundColor: Colors.white24,
      );
    } else if (index == _currentIndex) {
      // Current
      return AnimatedBuilder(
        animation: _animController,
        builder: (context, child) => LinearProgressIndicator(
          value: _animController.value,
          valueColor: const AlwaysStoppedAnimation(Colors.white),
          backgroundColor: Colors.white24,
        ),
      );
    } else {
      // Future
      return const LinearProgressIndicator(
        value: 0.0,
        valueColor: AlwaysStoppedAnimation(Colors.white),
        backgroundColor: Colors.white24,
      );
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _StatusActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StatusActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
