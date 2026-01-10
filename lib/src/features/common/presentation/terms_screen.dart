import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Agreement',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: January 2026',
              style: TextStyle(
                color: AppTheme.textGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Acceptance of Terms',
              'By creating an account and using RightLogistics, you agree to comply with and be bound by these terms. If you do not agree, please do not use our services.',
            ),
            _buildSection(
              '2. Data Privacy & Verification',
              'We collect personal data (Government IDs, Phone Numbers) solely for the purpose of verifying your identity and conducting legitimate business operations (KYC). Your data is stored securely and processed in accordance with local regulations.',
            ),
            _buildSection(
              '3. User Responsibilities',
              'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to provide accurate and truthful information during onboarding.',
            ),
            _buildSection(
              '4. Prohibited Activities',
              'You may not use our platform for any illegal activities, including but not limited to fraudulent shipments, money laundering, or harassment.',
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'RightLogistics Inc.',
                style: TextStyle(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return marginBottom(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget marginBottom({required Widget child}) {
    return Padding(padding: const EdgeInsets.only(bottom: 24), child: child);
  }
}
