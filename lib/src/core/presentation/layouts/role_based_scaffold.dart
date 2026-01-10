import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:rightlogistics/src/core/presentation/widgets/modern_bottom_nav.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/responsive_layout.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/notifications/presentation/widgets/notification_center_view.dart';

class RoleBasedScaffold extends ConsumerStatefulWidget {
  final Widget body;
  final String? title;
  final bool showFab;
  final VoidCallback? onFabPressed;
  final Widget? fabIcon;
  final String? fabLabel;

  const RoleBasedScaffold({
    super.key,
    required this.body,
    this.title,
    this.showFab = false,
    this.onFabPressed,
    this.fabIcon,
    this.fabLabel,
  });

  @override
  ConsumerState<RoleBasedScaffold> createState() => _RoleBasedScaffoldState();
}

class _RoleBasedScaffoldState extends ConsumerState<RoleBasedScaffold> {
  int _selectedIndex = 0;

  String _getTitle(String location, AppBarConfig config, UserModel? user) {
    // 1. If the provider has a custom title (not default), use it.
    if (config.title != 'RightLogistics' && config.title.isNotEmpty) {
      return config.title;
    }

    // 2. If we are a Vendor, use Business Name for some screens
    if (user?.role == UserRole.vendor &&
        (location == '/dashboard' ||
            location == '/social' ||
            location == '/fleet' ||
            location == '/users' ||
            location == '/user-profile')) {
      final bizName =
          user?.vendorKyc?.businessName ??
          user?.kycData?['businessName'] as String?;
      if (bizName != null && bizName.isNotEmpty) return bizName;
    }

    if (widget.title != null) return widget.title!;

    if (location.startsWith('/dashboard')) return 'Dashboard';
    if (location.startsWith('/tracking')) return 'Shipment Tracking';
    if (location.startsWith('/courier')) return 'Courier Operations';
    if (location.startsWith('/fleet')) return 'Fleet Management';
    if (location.startsWith('/stats')) return 'Insights & Analytics';
    if (location.startsWith('/users')) return 'User Management';
    if (location.startsWith('/profile')) return 'My Profile';
    if (location.startsWith('/my-orders')) return 'My Orders';
    if (location.startsWith('/notifications')) return 'Notifications';
    if (location.startsWith('/settings')) return 'Settings';
    if (location.startsWith('/support')) return 'Support Center';
    if (location.startsWith('/admin/create-shipment')) return 'New Shipment';

    return 'RightLogistics';
  }

  void _updateSelectedIndex(String location, List<_NavItem> items) {
    // Sort items by length of route descending to match most specific routes first
    final sortedItems = List<_NavItem>.from(items)
      ..sort((a, b) => b.route.length.compareTo(a.route.length));

    final bestMatch = sortedItems.firstWhere(
      (item) =>
          location == item.route ||
          (item.route != '/dashboard' &&
              item.route != '/' &&
              location.startsWith(item.route)),
      orElse: () => items[0], // Fallback
    );

    final index = items.indexOf(bestMatch);

    if (index != -1 && index != _selectedIndex) {
      Future.microtask(() {
        if (mounted) setState(() => _selectedIndex = index);
      });
    }
  }

  DateTime? _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final authState = ref.watch(authStateChangesProvider);

    // Only show loading if we are genuinely loading the initial state
    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If not loading and user is null, we are in Guest Mode
    // user is nullable, so we proceed without returning early

    final navItems = _getNavItems(user?.role);
    final location = GoRouterState.of(context).uri.path;
    final appBarConfig = ref.watch(appBarConfigProvider(location));

    _updateSelectedIndex(location, navItems);

    final canPop = context.canPop();
    final isSearching = ref.watch(isSearchingProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppTheme.primaryBlue;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        if (isSearching) {
          ref.read(isSearchingProvider.notifier).state = false;
          ref.read(searchQueryProvider.notifier).state = '';
          return;
        }

        if (canPop) {
          context.pop();
        } else {
          final now = DateTime.now();
          if (_lastBackPressTime == null ||
              now.difference(_lastBackPressTime!) >
                  const Duration(seconds: 2)) {
            _lastBackPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Press back again to exit'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        extendBody: false,
        appBar: AppBar(
          leading: isSearching
              ? IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    size: 20,
                    color: iconColor,
                  ),
                  onPressed: () {
                    ref.read(isSearchingProvider.notifier).state = false;
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : (canPop
                    ? IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          size: 20,
                          color: iconColor,
                        ),
                        onPressed: () => context.pop(),
                      )
                    : Builder(
                        builder: (context) => IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.bell,
                            size: 20,
                            color: iconColor,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      )),
          title: isSearching
              ? TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: appBarConfig.searchHint ?? 'Search...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: iconColor.withOpacity(0.5)),
                  ),
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) =>
                      ref.read(searchQueryProvider.notifier).state = value,
                )
              : Text(_getTitle(location, appBarConfig, user)),
          centerTitle: isSearching ? false : appBarConfig.centerTitle,
          actions: isSearching
              ? [
                  if (searchQuery.isNotEmpty)
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.xmark, size: 18),
                      onPressed: () {
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    ),
                  const SizedBox(width: 8),
                ]
              : _buildAppBarActions(
                  context,
                  appBarConfig.actions,
                  user,
                  location,
                  appBarConfig.isSearchEnabled,
                ),
        ),
        drawer: ResponsiveLayout.isMobile(context)
            ? Drawer(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: const NotificationCenterView(),
              )
            : null,
        body: Row(
          children: [
            if (!ResponsiveLayout.isMobile(context))
              _buildNavRail(context, user, navItems),
            if (!ResponsiveLayout.isMobile(context))
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    right: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: const NotificationCenterView(),
              ),
            Expanded(child: widget.body),
          ],
        ),
        bottomNavigationBar: ResponsiveLayout.isMobile(context)
            ? _buildBottomNav(navItems)
            : null,
        /* floatingActionButton: _shouldShowFab(location, user)
            ? FloatingActionButton.extended(
                onPressed: () => _handleFabPress(context, location, user),
                label: Text(_getFabLabel(location, user)),
                icon: const FaIcon(FontAwesomeIcons.plus, size: 18),
                backgroundColor: AppTheme.accentOrange,
                foregroundColor: Colors.white,
              )
            : null, */
      ),
    );
  }

  List<_NavItem> _getNavItems(UserRole? role) {
    if (role == null) {
      return [
        _NavItem(FontAwesomeIcons.earthAfrica, 'Social', '/social'),
        _NavItem(
          FontAwesomeIcons.magnifyingGlassLocation,
          'Logistics',
          '/tracking',
        ),
        _NavItem(FontAwesomeIcons.headset, 'Support', '/support'),
      ];
    }
    switch (role) {
      case UserRole.admin:
        return [
          _NavItem(FontAwesomeIcons.house, 'Overview', '/dashboard'),
          _NavItem(FontAwesomeIcons.truck, 'Fleet', '/fleet'),
          _NavItem(FontAwesomeIcons.earthAfrica, 'Social', '/social'),
          _NavItem(FontAwesomeIcons.globe, 'Network', '/users'),
          _NavItem(FontAwesomeIcons.userLarge, 'Profile', '/profile'),
        ];
      case UserRole.vendor:
        return [
          _NavItem(FontAwesomeIcons.house, 'Overview', '/dashboard'),
          _NavItem(FontAwesomeIcons.truck, 'Fleet', '/fleet'),
          _NavItem(FontAwesomeIcons.earthAfrica, 'Social', '/social'),
          _NavItem(FontAwesomeIcons.globe, 'Network', '/users'),
          _NavItem(FontAwesomeIcons.userLarge, 'Profile', '/profile'),
        ];
      case UserRole.courier:
        return [
          _NavItem(FontAwesomeIcons.listCheck, 'Tasks', '/courier'),
          _NavItem(
            FontAwesomeIcons.clockRotateLeft,
            'History',
            '/courier/history',
          ),
          _NavItem(FontAwesomeIcons.earthAfrica, 'Social', '/social'),
          _NavItem(FontAwesomeIcons.globe, 'Network', '/users'),
          _NavItem(FontAwesomeIcons.userLarge, 'Profile', '/profile'),
        ];
      case UserRole.customer:
        return [
          _NavItem(FontAwesomeIcons.house, 'Dashboard', '/dashboard'),
          _NavItem(
            FontAwesomeIcons.magnifyingGlassLocation,
            'Logistics',
            '/tracking',
          ),
          _NavItem(FontAwesomeIcons.earthAfrica, 'Social', '/social'),
          _NavItem(FontAwesomeIcons.globe, 'Network', '/users'),
          _NavItem(FontAwesomeIcons.userLarge, 'Profile', '/profile'),
        ];
    }
  }

  Widget _buildNavRail(
    BuildContext context,
    UserModel? user,
    List<_NavItem> items,
  ) {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
        context.go(items[index].route);
      },
      labelType: NavigationRailLabelType.none,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surface
          : AppTheme.primaryBlue,
      selectedIconTheme: IconThemeData(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
        size: 28,
      ),
      unselectedIconTheme: IconThemeData(
        color:
            (Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.white)
                .withOpacity(0.5),
        size: 24,
      ),
      indicatorColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : AppTheme.accentOrange,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const FaIcon(
            FontAwesomeIcons.boltLightning,
            color: AppTheme.accentOrange,
            size: 20,
          ),
        ),
      ),
      trailing: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: FaIcon(
                user != null
                    ? FontAwesomeIcons.rightFromBracket
                    : FontAwesomeIcons.rightToBracket,
                color: Colors.white70,
                size: 20,
              ),
              onPressed: () {
                if (user != null) {
                  ref.read(authRepositoryProvider).signOut();
                } else {
                  context.push('/login');
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      destinations: items
          .map(
            (item) => NavigationRailDestination(
              icon: FaIcon(item.icon, size: 22),
              selectedIcon: FaIcon(item.icon, size: 22),
              label: Text(item.label),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBottomNav(List<_NavItem> items) {
    return ModernBottomNav(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
        context.go(items[index].route);
      },
      destinations: items
          .map((item) => ModernNavItem(icon: item.icon, label: item.label))
          .toList(),
    );
  }

  bool _shouldShowFab(String location, UserModel user) {
    if (location == '/dashboard' && user.role == UserRole.admin) return true;
    if (location == '/dashboard' && user.role == UserRole.customer) return true;
    return false;
  }

  String _getFabLabel(String location, UserModel user) {
    if (user.role == UserRole.admin) return 'New Shipment';
    return 'Book Now';
  }

  void _handleFabPress(BuildContext context, String location, UserModel user) {
    context.push('/admin/create-shipment');
  }

  List<Widget> _buildAppBarActions(
    BuildContext context,
    List<AppBarAction> actions,
    UserModel? user,
    String location,
    bool isSearchEnabled,
  ) {
    final List<Widget> customActions = [];
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppTheme.primaryBlue;

    if (isSearchEnabled) {
      customActions.add(
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 20,
            color: iconColor,
          ),
          onPressed: () => ref.read(isSearchingProvider.notifier).state = true,
        ),
      );
    }

    // 1. If we have actions from the provider, construct them
    // Logic: Max 2 visible icons. If more, bundling into popover.
    if (actions.isNotEmpty) {
      if (actions.length <= 2) {
        // Show all
        for (final action in actions) {
          customActions.add(
            IconButton(
              icon: FaIcon(action.icon, size: 20, color: iconColor),
              tooltip: action.label,
              onPressed: action.onPressed,
            ),
          );
        }
      } else {
        // Show first 2
        for (var i = 0; i < 2; i++) {
          final action = actions[i];
          customActions.add(
            IconButton(
              icon: FaIcon(action.icon, size: 20, color: iconColor),
              tooltip: action.label,
              onPressed: action.onPressed,
            ),
          );
        }
        // Bundle rest into Popover
        customActions.add(
          PopupMenuButton<VoidCallback>(
            icon: FaIcon(
              FontAwesomeIcons.ellipsisVertical,
              size: 20,
              color: iconColor,
            ),
            onSelected: (callback) => callback(),
            itemBuilder: (context) {
              return actions.sublist(2).map((action) {
                return PopupMenuItem(
                  value: action.onPressed,
                  child: Row(
                    children: [
                      FaIcon(
                        action.icon,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 12),
                      Text(action.label),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        );
      }
    }

    // 2. Add Profile avatar (User Profile) action if not on profile screen
    // The user requested: "Dashboard screen will have ... user profile".
    // If it's explicitly in actions, we don't duplicate.
    // However, existing logic added it globaly. Let's keep it global if actions list is empty OR explicitly appended.
    // User Requirement: "Dashboard screen will have get quuote, book shipmment, user profile, tracking, etc."
    // This implies Profile is now just another action managed by the screen.
    // So if the screen provides actions, we ONLY show those.
    // BUT we need to ensure we don't break other screens that don't set actions yet.
    // Strategy: If actions are provided via provider, use them exclusively.
    // If NO actions provided (actions array is empty), fallback to default Profile Avatar logic for now to avoid regression.

    if (actions.isEmpty && location != '/profile') {
      customActions.add(const SizedBox(width: 8));
      if (user != null) {
        customActions.add(
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
              backgroundImage:
                  user.photoUrl != null && user.photoUrl!.isNotEmpty
                  ? CachedNetworkImageProvider(user.photoUrl!)
                  : null,
              child: user.photoUrl == null || user.photoUrl!.isEmpty
                  ? Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : null,
            ),
          ),
        );
      }
      customActions.add(const SizedBox(width: 8));
    } else if (actions.isEmpty && user == null && location != '/login') {
      // Guest User - Show Login Button
      customActions.add(
        TextButton(
          onPressed: () => context.push('/login'),
          child: const Text('Login'),
        ),
      );
      customActions.add(const SizedBox(width: 8));
    }

    return customActions;
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  _NavItem(this.icon, this.label, this.route);
}
