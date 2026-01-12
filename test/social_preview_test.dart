import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/presentation/widgets/social_post_cards.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';

void main() {
  testWidgets('SocialPostPreviewCard renders correctly', (
    WidgetTester tester,
  ) async {
    // Initialize SizeConfig or provide a mock context with screen size
    // Since SocialPostPreviewCard uses .w and .h, we need a base size.

    final testPost = VendorPost(
      id: 'test_id',
      vendorId: 'vendor_id',
      vendorName: 'Test Vendor',
      description: 'This is a test description for the social preview card.',
      type: PostType.promotion,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      expiresAt: DateTime.now().add(const Duration(days: 1)),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              SizeConfig().init(context);
              return Scaffold(body: SocialPostPreviewCard(post: testPost));
            },
          ),
        ),
      ),
    );

    // We might need to wait for a frame if ScreenUtil is used
    await tester.pump();

    // Verify description is shown
    expect(
      find.text('This is a test description for the social preview card.'),
      findsOneWidget,
    );

    // Verify type badge (Promotion) is shown
    expect(find.text('PROMOTION'), findsOneWidget);

    // Verify time ago is shown
    expect(find.text('2h ago'), findsOneWidget);
  });
}
