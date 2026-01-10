import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rightlogistics/src/core/presentation/widgets/glass_card.dart';
import 'package:rightlogistics/src/core/presentation/widgets/gradient_button.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    }
  }

  void _shareApp() {
    Share.share(
      'Track your shipments globally with Right Logistics Gh! Download our app today: https://rightlogistics.gh',
    );
  }

  Future<void> _rateApp() async {
    // Placeholder URL for store
    final url = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.rightlogistics.app',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              errorBuilder: (_, __, ___) =>
                  const FaIcon(FontAwesomeIcons.truck, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Right Logistics Gh'),
          ],
        ),
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          margin: EdgeInsets.only(top: 10.h),
          width: MediaQuery.of(context).size.width * .75,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your trusted partner for Global Logistics between China and Ghana.',
              ),
              SizedBox(height: 16),
              Text('Developed with by Antigravity Team.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionHeader(context, 'App Preferences'),
        const SizedBox(height: 16),
        _buildSettingTile(
          icon: FontAwesomeIcons.moon,
          title: 'Dark Mode',
          subtitle: 'Enable dark theme for the application',
          trailing: Switch(
            value: ref.watch(themeModeProvider) == ThemeMode.dark,
            onChanged: (val) {
              ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
            },
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          icon: FontAwesomeIcons.bell,
          title: 'Push Notifications',
          subtitle: 'Receive updates about your shipments',
          trailing: Switch(
            value: true,
            onChanged: (val) {},
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
        ),

        const SizedBox(height: 32),
        _buildSectionHeader(context, 'Account'),
        const SizedBox(height: 16),
        _buildSettingTile(
          icon: FontAwesomeIcons.user,
          title: 'My Profile',
          subtitle: 'Edit personal details & avatar',
          onTap: () => context.push('/profile'),
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          icon: FontAwesomeIcons.lock,
          title: 'Change Password',
          subtitle: 'Update your account security',
          onTap: () {},
        ),

        const SizedBox(height: 32),
        _buildSectionHeader(context, 'Support & Legal'),
        const SizedBox(height: 16),
        _buildSettingTile(
          icon: FontAwesomeIcons.headset,
          title: 'FAQs & Support',
          onTap: () => context.push('/support'),
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          icon: FontAwesomeIcons.fileContract,
          title: 'Terms of Service',
          onTap: () => context.push('/terms'),
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          icon: FontAwesomeIcons.shieldHalved,
          title: 'Privacy Policy',
          onTap: () => context.push('/privacy'),
        ),

        const SizedBox(height: 32),
        _buildSectionHeader(context, 'About & Feedback'),
        const SizedBox(height: 16),
        _buildSettingTile(
          icon: FontAwesomeIcons.shareNodes,
          title: 'Share App',
          subtitle: 'Share with friends & family',
          onTap: _shareApp,
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          icon: FontAwesomeIcons.solidStar,
          title: 'Rate Us',
          subtitle: 'Review on Play Store',
          onTap: _rateApp,
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          icon: FontAwesomeIcons.circleInfo,
          title: 'About App',
          onTap: _showAboutDialog,
        ),

        const SizedBox(height: 48),
        GradientButton(
          text: 'Sign Out',
          onPressed: () => _showLogoutConfirmation(context, ref),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Version $_version',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FaIcon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 12))
            : null,
        trailing:
            trailing ??
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          margin: EdgeInsets.only(top: 10.h),
          width: MediaQuery.of(context).size.width * .75,
          child: const Text(
            'Are you sure you want to log out of your account?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authRepositoryProvider).signOut();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
