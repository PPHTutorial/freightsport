import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:rightlogistics/src/features/social/data/social_repository.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/domain/status_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository();
});

final activePostsProvider = StreamProvider<List<VendorPost>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return ref.watch(socialRepositoryProvider).watchActivePosts().map((posts) {
    // Filter out status updates from main feed
    final feedPosts = posts
        .where((p) => p.type != PostType.status_Update)
        .toList();

    if (query.isEmpty) return feedPosts;

    return feedPosts.where((post) {
      final searchContent =
          '${post.vendorName} ${post.description} ${post.title ?? ''}'
              .toLowerCase();
      return searchContent.contains(query);
    }).toList();
  });
});

final followingIdsProvider = StreamProvider.autoDispose
    .family<List<String>, String>((ref, userId) {
      return ref.watch(socialRepositoryProvider).watchFollowingIds(userId);
    });

final followingsProvider = StreamProvider.autoDispose
    .family<DocumentSnapshot, String>((ref, userId) {
      return ref.watch(socialRepositoryProvider).watchFollowings(userId);
    });

final postCommentsProvider = StreamProvider.autoDispose
    .family<List<PostComment>, String>((ref, postId) {
      return ref.watch(socialRepositoryProvider).watchComments(postId);
    });

final chatRoomsProvider = StreamProvider.autoDispose
    .family<List<ChatRoom>, String>((ref, userId) {
      return ref.watch(socialRepositoryProvider).watchChatRooms(userId);
    });

final activeStatusesProvider = StreamProvider<List<StatusModel>>((ref) {
  return ref.watch(socialRepositoryProvider).watchActiveStatuses();
});

// socialSearchQueryProvider is now deprecated in favor of global searchQueryProvider
