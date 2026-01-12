import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/features/common/presentation/terms_screen.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/core/services/persistence_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:rightlogistics/src/features/authentication/presentation/login_screen.dart';
import 'package:rightlogistics/src/features/authentication/presentation/forgot_password_screen.dart';
import 'package:rightlogistics/src/features/authentication/presentation/signup_screen.dart';
import 'package:rightlogistics/src/features/authentication/presentation/legal_screens.dart'
    hide TermsScreen;
import 'package:rightlogistics/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:rightlogistics/src/features/common/presentation/seeding_dashboard_screen.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/pages/insights_screen.dart';
import 'package:rightlogistics/src/features/profile/presentation/public_profile_screen.dart';
import 'package:rightlogistics/src/features/profile/presentation/vendor_store_screen.dart';
import 'package:rightlogistics/src/features/courier/presentation/courier_dashboard_screen.dart';
import 'package:rightlogistics/src/features/courier/presentation/update_status_screen.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/tracking/presentation/tracking_screen.dart';
import 'package:rightlogistics/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:rightlogistics/src/features/onboarding/presentation/profile_builder_screen.dart';
import 'package:rightlogistics/src/features/settings/presentation/settings_screen.dart';
import 'package:rightlogistics/src/features/profile/presentation/profile_screen.dart';
import 'package:rightlogistics/src/features/notifications/presentation/notifications_screen.dart';
import 'package:rightlogistics/src/features/notifications/presentation/notification_details_screen.dart';
import 'package:rightlogistics/src/features/notifications/domain/notification_model.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/pages/get_quote_screen.dart';
import 'package:rightlogistics/src/features/social/presentation/social_hub_screen.dart';
import 'package:rightlogistics/src/features/social/presentation/status_viewer_screen.dart';
import 'package:rightlogistics/src/features/social/presentation/social_post_creator.dart';
import 'package:rightlogistics/src/features/social/presentation/chat_list_screen.dart';
import 'package:rightlogistics/src/features/social/presentation/chat_messages_screen.dart';
import 'package:rightlogistics/src/features/support/presentation/support_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/create_shipment_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/broadcast_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/client_directory_screen.dart';
import 'package:rightlogistics/src/core/presentation/layouts/role_based_scaffold.dart';
import 'package:rightlogistics/src/features/social/domain/status_model.dart';
import 'package:rightlogistics/src/features/admin/presentation/admin_fleet_screen.dart';
import 'package:rightlogistics/src/features/social/presentation/followers_list_screen.dart';
import 'package:rightlogistics/src/features/courier/presentation/courier_history_screen.dart';
import 'package:rightlogistics/src/features/authentication/presentation/account_status_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges),
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final user = ref.read(
        currentUserProvider,
      ); // Make sure this is up to date or use authRepo.currentUser
      // Better: we can't easily access the stream value here without watching it,
      // but watching it rebuilds the router.
      // Instead, let's rely on refreshListenable to trigger this redirect,
      // and read the current value from the repository or a non-watching provider read.

      final isLoggedIn = user != null;
      final location = state.uri.path;

      final persistence = ref.read(persistenceServiceProvider);
      final hasSeenOnboarding = persistence.hasSeenOnboarding();

      final path = state.uri.path;

      // Debug log - you'll see this in console
      print(
        'Router Redirect: path=$path, location=$location, hasSeenOnboarding=$hasSeenOnboarding, isLoggedIn=$isLoggedIn',
      );

      if (!hasSeenOnboarding && path != '/onboarding') {
        return '/onboarding';
      }

      // 1. Redirect to Dashboard/Target if logged in and on Auth Pages
      final isAuthPage =
          path == '/login' ||
          path == '/register' ||
          path == '/forgot-password' ||
          path == '/onboarding';
      if (isLoggedIn && isAuthPage) {
        // If there is a redirect parameter, go there
        final redirectUrl = state.uri.queryParameters['redirect'];
        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          return redirectUrl;
        }
        // Default entry point
        return '/dashboard';
      }

      // Guest/Public Mode Logic
      // Define routes accessible without login
      const publicRoutes = [
        '/login',
        '/register',
        '/forgot-password',
        '/onboarding',
        '/terms',
        '/privacy',
        '/social',
        '/social/status', // sub-routes ideally matched by startswith
        '/tracking',
        '/support',
        '/get-quote',
        // '/otp', // If OTP is used
      ];

      // Helper to check if location is public
      // We check exact match OR if it starts with a public prefix that is meant to be browsable (like /social)
      bool isPublic =
          publicRoutes.contains(path) ||
          path.startsWith('/social') ||
          path.startsWith('/tracking') ||
          path.startsWith('/support');

      if (!isLoggedIn && !isPublic) {
        // If trying to access a protected route as guest, redirect to Login
        // But if they are just launching app (location == '/'), send to /social
        if (path == '/') return '/social';

        // Append the current location as a redirect parameter
        final encodedLocation = Uri.encodeComponent(location);
        return '/login?redirect=$encodedLocation';
      }

      // 4. Verification Gate (Redirect to Profile Setup if incomplete)
      if (isLoggedIn && path != '/onboarding/setup') {
        // Critical: Check Account Status first
        if (user.accountStatus != AccountStatus.active) {
          if (path != '/account-status') {
            return '/account-status';
          }
          // If already on /account-status, allow it
          return null;
        } else if (path == '/account-status') {
          // If active but on /account-status, go home
          return '/dashboard';
        }

        final needsProfileSetup = !user.isProfileComplete;
        final needsVerification =
            user.verificationStatus != VerificationStatus.verified &&
            user.verificationStatus != VerificationStatus.pending;

        // Strict Mode: Block unless Verified
        if (needsProfileSetup || needsVerification) {
          return '/onboarding/setup';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/account-status',
        builder: (context, state) => const AccountStatusScreen(),
      ),
      GoRoute(
        path: '/onboarding/setup',
        builder: (context, state) {
          final step =
              int.tryParse(state.uri.queryParameters['step'] ?? '0') ?? 0;
          return ProfileBuilderScreen(initialStep: step);
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) =>
            const SignupScreen(), // Changed from LoginScreen to SignupScreen
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: '/terms', builder: (context, state) => const TermsScreen()),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => RoleBasedScaffold(body: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/tracking',
            builder: (context, state) => const TrackingScreen(),
          ),
          GoRoute(
            path: '/courier',
            builder: (context, state) => const CourierDashboardScreen(),
            routes: [
              GoRoute(
                path: 'update/:id',
                builder: (context, state) {
                  final trackingNumber = state.pathParameters['id']!;
                  final extra = state.extra;
                  final shipment = extra is Shipment
                      ? extra
                      : (extra is Map<String, dynamic>
                            ? Shipment.fromJson(extra)
                            : null);
                  return UpdateStatusScreen(
                    trackingNumber: trackingNumber,
                    shipment: shipment,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
            routes: [
              GoRoute(
                path: 'details',
                builder: (context, state) {
                  final extra = state.extra;
                  final NotificationModel notification;
                  if (extra is NotificationModel) {
                    notification = extra;
                  } else if (extra is Map<String, dynamic>) {
                    notification = NotificationModel.fromJson(extra);
                  } else {
                    return const Scaffold(
                      body: Center(child: Text('Invalid notification data')),
                    );
                  }
                  return NotificationDetailsScreen(notification: notification);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/social',
            builder: (context, state) => const SocialHubScreen(),
            routes: [
              GoRoute(
                path: 'chats',
                builder: (context, state) => const ChatListScreen(),
              ),
              GoRoute(
                path: 'chat/:otherUserId',
                builder: (context, state) {
                  final otherUserId = state.pathParameters['otherUserId']!;
                  final initialMessage = state.uri.queryParameters['msg'];
                  return ChatMessagesScreen(
                    otherUserId: otherUserId,
                    initialMessage: initialMessage,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/support',
            builder: (context, state) => const SupportScreen(),
          ),
          GoRoute(
            path: '/get-quote',
            builder: (context, state) => const GetQuoteScreen(),
          ),
          GoRoute(
            path: '/admin/broadcast',
            builder: (context, state) => const BroadcastScreen(),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const ClientDirectoryScreen(),
          ),
          GoRoute(
            path: '/fleet',
            builder: (context, state) => const AdminFleetScreen(),
          ),
          GoRoute(
            path: '/followers/:uid',
            builder: (context, state) {
              final uid = state.pathParameters['uid']!;
              return FollowersListScreen(userId: uid);
            },
          ),
          GoRoute(
            path: '/courier/history',
            builder: (context, state) => const CourierHistoryScreen(),
          ),
          GoRoute(
            path: '/stats',
            builder: (context, state) => const InsightsScreen(),
          ),
          GoRoute(
            path: '/seeding',
            builder: (context, state) => const SeedingDashboardScreen(),
          ),
          GoRoute(
            path: '/user-profile',
            builder: (context, state) {
              final extra = state.extra;
              final UserModel user;
              if (extra is UserModel) {
                user = extra;
              } else if (extra is Map<String, dynamic>) {
                user = UserModel.fromJson(extra);
              } else {
                return const Scaffold(
                  body: Center(child: Text('Invalid user data')),
                );
              }

              if (user.role == UserRole.vendor) {
                return VendorStoreScreen(vendor: user);
              }
              return PublicProfileScreen(userId: user.id, user: user);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/admin/create-shipment',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: CreateShipmentScreen(),
        ),
      ),
      GoRoute(
        path: '/social/status',
        builder: (context, state) {
          final extra = state.extra;
          final List<StatusModel> statuses;
          if (extra is List<StatusModel>) {
            statuses = extra;
          } else if (extra is List) {
            statuses = extra
                .map(
                  (e) => e is StatusModel
                      ? e
                      : StatusModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          } else {
            return const Scaffold(
              body: Center(child: Text('Invalid status data')),
            );
          }
          return StatusViewerScreen(statuses: statuses);
        },
      ),
      GoRoute(
        path: '/social/create',
        builder: (context, state) => const SocialPostCreator(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
