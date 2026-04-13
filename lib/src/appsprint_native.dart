import 'package:flutter/services.dart';

import 'types.dart';

class AppSprintNative {
  AppSprintNative._();

  static const MethodChannel _channel = MethodChannel('appsprint_flutter/native');

  // Core SDK

  static Future<void> configure(Map<String, dynamic> config) {
    return _channel.invokeMethod<void>('configure', config);
  }

  static Future<void> sendEvent(Map<String, dynamic> args) {
    return _channel.invokeMethod<void>('sendEvent', args);
  }

  static Future<Map<dynamic, dynamic>?> sendTestEvent() {
    return _channel.invokeMethod<Map<dynamic, dynamic>>('sendTestEvent');
  }

  static Future<void> flush() {
    return _channel.invokeMethod<void>('flush');
  }

  static Future<void> clearData() {
    return _channel.invokeMethod<void>('clearData');
  }

  static Future<void> setCustomerUserId(String userId) {
    return _channel.invokeMethod<void>('setCustomerUserId', {'userId': userId});
  }

  static Future<void> enableAppleAdsAttribution() {
    return _channel.invokeMethod<void>('enableAppleAdsAttribution');
  }

  static Future<String?> getAppSprintId() {
    return _channel.invokeMethod<String>('getAppSprintId');
  }

  static Future<Map<dynamic, dynamic>?> getAttribution() {
    return _channel.invokeMethod<Map<dynamic, dynamic>>('getAttribution');
  }

  static Future<bool> isInitialized() async {
    return await _channel.invokeMethod<bool>('isInitialized') ?? false;
  }

  static Future<bool> isSdkDisabled() async {
    return await _channel.invokeMethod<bool>('isSdkDisabled') ?? false;
  }

  static Future<void> destroy() {
    return _channel.invokeMethod<void>('destroy');
  }

  // Utility

  static Future<DeviceInfo> getDeviceInfo() async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('getDeviceInfo');
    return DeviceInfo.fromJson(result ?? const <dynamic, dynamic>{});
  }

  static Future<String?> getAdServicesToken() {
    return _channel.invokeMethod<String>('getAdServicesToken');
  }

  static Future<bool> requestTrackingAuthorization() async {
    return await _channel.invokeMethod<bool>('requestTrackingAuthorization') ?? false;
  }
}
