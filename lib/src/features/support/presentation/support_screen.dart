import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/core/constants/app_data.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Direct Contact'),
          const SizedBox(height: 16),
          _buildGroupedContactTile(
            context,
            FaIcon(
              FontAwesomeIcons.phone,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
            'Call Support',
            'Connect with our specialists',
            Theme.of(context).colorScheme.primary,
            () => _showContactDialog(
              context,
              'Call Support',
              AppData.phoneNumbers
                  .map((p) => (p, 'tel:$p', Icons.call))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _buildGroupedContactTile(
            context,
            FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 20),
            'WhatsApp Support',
            'Instant messaging & assistance',
            Colors.green,
            () => _showContactDialog(
              context,
              'WhatsApp Support',
              AppData.whatsappNumbers
                  .map(
                    (n) => (
                      '+${n.substring(0, 3)} ${n.substring(3, 5)} ${n.substring(5, 8)} ${n.substring(8)}',
                      'https://wa.me/$n',
                      FontAwesomeIcons.whatsapp,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _buildGroupedContactTile(
            context,
            FaIcon(
              FontAwesomeIcons.solidEnvelope,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            'Email Support',
            AppData.email,
            Theme.of(context).colorScheme.secondary,
            () => _launchURL('mailto:${AppData.email}'),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Follow Our Journey'),
          const SizedBox(height: 16),
          _buildSocialGrid(context),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Frequently Asked Questions'),
          const SizedBox(height: 16),
          _buildFAQList(context),
          const SizedBox(height: 80), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support Center',
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'How can we help you scale your logistics today?',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.8),
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildGroupedContactTile(
    BuildContext context,
    Widget icon,
    String title,
    String subtitle,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return _buildContactCard(
      context,
      icon,
      title,
      subtitle,
      accentColor,
      onTap,
    );
  }

  void _showContactDialog(
    BuildContext context,
    String title,
    List<(String, String, dynamic)> items,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          margin: EdgeInsets.only(top: 10.h),
          width: MediaQuery.of(context).size.width * .75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map((item) {
              final icon = item.$3;
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: icon is IconData
                      ? Icon(
                          icon,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        )
                      : FaIcon(
                          icon as IconData,
                          color: Theme.of(context).colorScheme.primary,
                          size: 16,
                        ),
                ),
                title: Text(
                  item.$1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text(
                  'Tap to connect',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 12),
                onTap: () {
                  Navigator.pop(context);
                  _launchURL(item.$2);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    Widget icon,
    String title,
    String subtitle,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 12,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 4,
      ),
      itemCount: AppData.socials.length,
      itemBuilder: (context, index) {
        final entry = AppData.socials.entries.elementAt(index);
        final platformName = entry.key;
        final handle = entry.value.$1;
        final url = entry.value.$2;

        return InkWell(
          onTap: () => _launchURL(url),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                _getSocialIcon(context, platformName),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        platformName,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        handle,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getSocialIcon(BuildContext context, String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCAF45)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const FaIcon(
            FontAwesomeIcons.instagram,
            color: Colors.white,
            size: 16,
          ),
        );
      case 'facebook':
        return const FaIcon(
          FontAwesomeIcons.facebook,
          color: Color(0xFF1877F2),
          size: 28,
        );
      case 'tiktok':
        return FaIcon(
          FontAwesomeIcons.tiktok,
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        );
      case 'snapchat':
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFC00),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const FaIcon(
            FontAwesomeIcons.snapchat,
            color: Colors.black,
            size: 16,
          ),
        );
      default:
        return FaIcon(
          FontAwesomeIcons.link,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        );
    }
  }

  Widget _buildFAQList(BuildContext context) {
    return Column(
      children: AppData.faqs.map((faq) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  faq['question']!,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                iconColor: Theme.of(context).colorScheme.secondary,
                collapsedIconColor: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withOpacity(0.5),
                childrenPadding: const EdgeInsets.all(16),
                children: [
                  Text(
                    faq['answer']!,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.8),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
