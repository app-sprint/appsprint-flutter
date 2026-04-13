import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('required binary artifacts are present', () {
    const requiredPaths = <String>[
      'android/libs/appsprint-sdk.aar',
      'ios/AppSprintSDK.xcframework/ios-arm64/AppSprintSDK.framework/AppSprintSDK',
      'ios/AppSprintSDK.xcframework/ios-arm64_x86_64-simulator/AppSprintSDK.framework/AppSprintSDK',
    ];

    for (final relativePath in requiredPaths) {
      expect(File(relativePath).existsSync(), isTrue, reason: '$relativePath should exist');
    }
  });
}
