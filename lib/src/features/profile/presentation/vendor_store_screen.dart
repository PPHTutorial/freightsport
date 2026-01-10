import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/presentation/widgets/social_post_cards.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:rightlogistics/src/features/reviews/presentation/widgets/rating_display_widget.dart';
import 'package:rightlogistics/src/features/reviews/presentation/widgets/review_card.dart';
import 'package:rightlogistics/src/features/reviews/data/review_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

final vendorPostsProvider = StreamProvider.autoDispose
    .family<List<VendorPost>, String>((ref, vendorId) {
      return FirebaseFirestore.instance
          .collection('posts')
          .where('vendorId', isEqualTo: vendorId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((d) => VendorPost.fromJson({...d.data(), 'id': d.id}))
                .toList(),
          );
    });

class VendorStoreScreen extends ConsumerStatefulWidget {
  final UserModel vendor;
  const VendorStoreScreen({super.key, required this.vendor});

  @override
  ConsumerState<VendorStoreScreen> createState() => _VendorStoreScreenState();
}

class _VendorStoreScreenState extends ConsumerState<VendorStoreScreen> {
  late ScrollController _scrollController;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final collapsed = _scrollController.offset > 140;
      if (collapsed != _isCollapsed) {
        setState(() {
          _isCollapsed = collapsed;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to real-time updates for this vendor
    final vendorAsync = ref.watch(userProvider(widget.vendor.id));

    // Use the latest data if available, fallback to the passed model
    final v = vendorAsync.value ?? widget.vendor;
    final currentUser = ref.watch(currentUserProvider);
    final isOwner = currentUser?.id == v.id;

    final vk = v.vendorKyc;
    final bizName = (vk?.businessName.isNotEmpty ?? false)
        ? vk!.businessName
        : v.name;
    final rates = vk?.vendorRates ?? [];
    final routes = vk?.vendorRoutes ?? [];
    final faqs = vk?.vendorFAQs ?? [];
    final services = vk?.vendorServices ?? [];
    final phones = vk?.vendorPhones ?? [];
    final locations = vk?.vendorAddresses ?? [];
    final socials = vk?.vendorSocials ?? [];

    // Update Parent AppBar Branding
    Future.microtask(() {
      final location = GoRouterState.of(context).uri.path;
      final config = ref.read(appBarConfigProvider(location));
      if (config.title != bizName) {
        ref
            .read(appBarConfigProvider(location).notifier)
            .setConfig(
              AppBarConfig(
                title: bizName,
                actions: [
                  if (isOwner)
                    AppBarAction(
                      icon: FontAwesomeIcons.penToSquare,
                      label: 'Edit',
                      onPressed: () => context.push('/onboarding/setup?step=1'),
                    ),
                  AppBarAction(
                    icon: FontAwesomeIcons.shareNodes,
                    label: 'Share',
                    onPressed: () {
                      Share.share("Check out $bizName on RightLogistics!");
                    },
                  ),
                ],
              ),
            );
      }
    });

    final iconColor = _isCollapsed
        ? Colors.orange
        : (Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.solidMessage,
                    color: iconColor,
                    size: 24,
                  ),
                  onPressed: () => context.push('/social/chat/${v.id}'),
                  tooltip: 'Chat',
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.solidThumbsUp,
                    color: iconColor,
                    size: 24,
                  ),
                  onPressed: () {
                    if (currentUser != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You recommended $bizName!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please sign in to recommend.'),
                        ),
                      );
                    }
                  },
                  tooltip: 'Recommend',
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.shareNodes,
                    color: iconColor,
                    size: 24,
                  ),
                  onPressed: () {
                    Share.share("Check out $bizName on RightLogistics!");
                  },
                  tooltip: 'Share',
                ),
                if (!isOwner && currentUser != null)
                  Consumer(
                    builder: (context, ref, child) {
                      final updatedUser = ref.watch(currentUserProvider);
                      final isFollowing =
                          updatedUser?.followingIds.contains(v.id) ?? false;
                      return IconButton(
                        icon: FaIcon(
                          isFollowing
                              ? FontAwesomeIcons.userCheck
                              : FontAwesomeIcons.userPlus,
                          color: iconColor,
                          size: 24,
                        ),
                        onPressed: () {
                          if (isFollowing) {
                            ref
                                .read(socialRepositoryProvider)
                                .unfollowUser(currentUser.id, v.id);
                          } else {
                            ref
                                .read(socialRepositoryProvider)
                                .followUser(currentUser.id, v.id);
                          }
                        },
                        tooltip: isFollowing ? 'Unfollow' : 'Follow',
                      );
                    },
                  ),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (v.companyBanner != null)
                    CachedNetworkImage(
                      imageUrl: v.companyBanner!,
                      fit: BoxFit.cover,
                    )
                  else if (v.companyLogo != null)
                    CachedNetworkImage(
                      imageUrl: v.companyLogo!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(color: AppTheme.primaryBlue),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (v.companyLogo != null)
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                            v.companyLogo!,
                          ),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bizName,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (v.address?.fullAddress.isNotEmpty ??
                                false || v.kycData?['address'] != null)
                              Text(
                                v.address?.fullAddress ??
                                    v.kycData?['address'] as String? ??
                                    '',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                      // Redundant actions removed from here (now in SliverAppBar)
                    ],
                  ),
                  if (socials.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Connect with Us',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: socials.reversed.map((s) {
                        final platform = s['platform'] ?? '';
                        IconData icon = FontAwesomeIcons.globe;
                        if (platform.contains('Instagram'))
                          icon = FontAwesomeIcons.instagram;
                        if (platform.contains('Facebook'))
                          icon = FontAwesomeIcons.facebook;
                        if (platform.contains('Twitter') ||
                            platform.contains('X'))
                          icon = FontAwesomeIcons.twitter;
                        if (platform.contains('WhatsApp'))
                          icon = FontAwesomeIcons.whatsapp;
                        if (platform.contains('YouTube'))
                          icon = FontAwesomeIcons.youtube;
                        if (platform.contains('TikTok'))
                          icon = FontAwesomeIcons.tiktok;
                        if (platform.contains('LinkedIn'))
                          icon = FontAwesomeIcons.linkedin;

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            onTap: () {
                              if (s['link'] != null) {
                                launchUrl(Uri.parse(s['link']!));
                              }
                            },
                            child: FaIcon(
                              icon,
                              size: 30,
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.7),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Rating and Reviews Section
                  if (v.totalReviews > 0) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rating & Reviews',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Navigate to full reviews page
                                  },
                                  child: const Text('See All'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            RatingDisplayWidget(
                              averageRating: v.averageRating,
                              totalReviews: v.totalReviews,
                              ratingBreakdown: v.ratingBreakdown,
                            ),
                            const SizedBox(height: 16),
                            StreamBuilder(
                              stream: ReviewRepository().watchReviewsForUser(
                                v.id,
                                limit: 3,
                              ),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final reviews = snapshot.data!;
                                if (reviews.isEmpty)
                                  return const SizedBox.shrink();
                                return Column(
                                  children: reviews
                                      .map(
                                        (review) => ReviewCard(review: review),
                                      )
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  const SizedBox(height: 24),
                  const Text(
                    'About Us',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    v.vendorKyc?.businessDescription ??
                        v.kycData?['description'] as String? ??
                        'We provide top-notch logistics services globally.',
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Contact & Locations',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ContactActionButton(
                          icon: Icons.call,
                          label: 'Call Us',
                          color: Colors.green,
                          onTap: () {
                            _showPhoneDialog(context, phones, locations);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ContactActionButton(
                          icon: Icons.location_on,
                          label: 'Locations',
                          color: AppTheme.primaryBlue,
                          onTap: () {
                            _showLocationDialog(context, locations);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Our Services & Updates',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  if (services.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: services
                          .map(
                            (s) => Chip(
                              label: Text(
                                s,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: AppTheme.primaryBlue.withOpacity(
                                0.1,
                              ),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),

                  if (rates.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const _SectionHeader(
                      title: 'Shipping Rates',
                      icon: Icons.local_shipping_outlined,
                    ),
                    const SizedBox(height: 12),
                    ...rates.map((r) => _RateTile(rate: r)),
                  ],

                  if (routes.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const _SectionHeader(
                      title: 'Routes Covered',
                      icon: Icons.map_outlined,
                    ),
                    const SizedBox(height: 12),
                    ...routes.map((r) => _RouteTile(route: r)),
                  ],

                  if (faqs.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const _SectionHeader(
                      title: 'Frequently Asked Questions',
                      icon: Icons.help_outline,
                    ),
                    const SizedBox(height: 12),
                    ...faqs.map((f) => _FAQTile(faq: f)),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final postsAsync = ref.watch(vendorPostsProvider(v.id));
              return postsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.w),
                          child: Text('No updates yet.'),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: EdgeInsets.all(16.w),
                        child: SocialPostCard(post: posts[index]),
                      );
                    }, childCount: posts.length),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => SliverToBoxAdapter(child: Text('Error: $e')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ],
    );
  }
}

class _RateTile extends StatelessWidget {
  final Map<String, String> rate;
  const _RateTile({required this.rate});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          rate['service'] ?? 'Shipping Service',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(rate['type'] ?? ''),
        trailing: Text(
          "${rate['currency'] ?? r'$'} ${rate['amount'] ?? '0'}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _RouteTile extends StatelessWidget {
  final Map<String, String> route;
  const _RouteTile({required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '${route['origin'] ?? route['from'] ?? ''} \u2192 ${route['destination'] ?? route['to'] ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _FAQTile extends StatefulWidget {
  final Map<String, String> faq;
  const _FAQTile({required this.faq});

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _isExpanded
            ? AppTheme.primaryBlue.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.faq['question'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.faq['answer'] ?? '',
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContactActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContactActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPhoneDialog(
  BuildContext context,
  List<Map<String, String>> phones, // Global phones
  List<Map<String, dynamic>> locations, // Locations with phones
) {
  // Aggregate all phones
  final allPhones = <Map<String, String>>[];

  // Add global phones
  for (final p in phones) {
    allPhones.add({
      'label': p['label'] ?? 'General',
      'number': p['number'] ?? '',
    });
  }

  // Add location phones
  for (final loc in locations) {
    final locName = loc['label'] ?? 'Warehouse';
    final locPhones = (loc['phones'] as List?)?.cast<String>() ?? [];
    for (final num in locPhones) {
      if (num.isNotEmpty) {
        allPhones.add({'label': '$locName', 'number': num});
      }
    }
  }

  showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.contact_phone_rounded,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Contact Numbers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (allPhones.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text('No contact numbers available.'),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: allPhones.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = allPhones[index];
                    final number = item['number']!;
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['label']!.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  number,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final uri = Uri.parse('tel:$number');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                            icon: const Icon(
                              Icons.call_rounded,
                              color: Colors.green,
                            ),
                            tooltip: 'Call',
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: number));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Phone number copied to clipboard',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.copy_rounded,
                              color: AppTheme.primaryBlue,
                            ),
                            tooltip: 'Copy',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showLocationDialog(
  BuildContext context,
  List<Map<String, dynamic>> locations,
) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.store_rounded,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Warehouses & Offices',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (locations.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text('No locations listed.'),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 500),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: locations.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final loc = locations[index];
                    final label = loc['label'] ?? 'Warehouse';
                    final street = loc['street'] ?? '';
                    final city = loc['city'] ?? '';
                    final fullAddress = "$street, $city";
                    final pCount = (loc['phones'] as List?)?.length ?? 0;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      label,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      fullAddress,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _DialogActionButton(
                                icon: Icons.map_rounded,
                                label: 'Navigate',
                                color: Colors.blue,
                                onTap: () async {
                                  final query = Uri.encodeComponent(
                                    fullAddress,
                                  );
                                  final googleMapsUrl =
                                      "https://www.google.com/maps/search/?api=1&query=$query";
                                  final uri = Uri.parse(googleMapsUrl);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                              _DialogActionButton(
                                icon: Icons.copy_rounded,
                                label: 'Copy',
                                color: Colors.grey[700]!,
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: fullAddress),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Address copied to clipboard',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              _DialogActionButton(
                                icon: Icons.share_rounded,
                                label: 'Share',
                                color: AppTheme.primaryBlue,
                                onTap: () {
                                  Share.share(
                                    "Visit us at $label: $fullAddress",
                                  );
                                },
                              ),
                            ],
                          ),
                          if (pCount > 0) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 12,
                                    color: Colors.green[700],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$pCount active contact number(s)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DialogActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DialogActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
