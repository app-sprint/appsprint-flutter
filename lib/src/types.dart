enum AppSprintEventType {
  login,
  signUp,
  register,
  purchase,
  subscribe,
  startTrial,
  addToCart,
  addToWishlist,
  initiateCheckout,
  viewContent,
  viewItem,
  search,
  share,
  tutorialComplete,
  levelStart,
  levelComplete,
  custom,
}

const Map<AppSprintEventType, String> appSprintEventTypeValues = {
  AppSprintEventType.login: 'login',
  AppSprintEventType.signUp: 'sign_up',
  AppSprintEventType.register: 'register',
  AppSprintEventType.purchase: 'purchase',
  AppSprintEventType.subscribe: 'subscribe',
  AppSprintEventType.startTrial: 'start_trial',
  AppSprintEventType.addToCart: 'add_to_cart',
  AppSprintEventType.addToWishlist: 'add_to_wishlist',
  AppSprintEventType.initiateCheckout: 'initiate_checkout',
  AppSprintEventType.viewContent: 'view_content',
  AppSprintEventType.viewItem: 'view_item',
  AppSprintEventType.search: 'search',
  AppSprintEventType.share: 'share',
  AppSprintEventType.tutorialComplete: 'tutorial_complete',
  AppSprintEventType.levelStart: 'level_start',
  AppSprintEventType.levelComplete: 'level_complete',
  AppSprintEventType.custom: 'custom',
};

class AppSprintConfig {
  const AppSprintConfig({
    required this.apiKey,
    this.apiUrl = 'https://api.appsprint.app',
    this.enableAppleAdsAttribution = true,
    this.isDebug = false,
    this.logLevel = 2,
    this.customerUserId,
  }) : assert(logLevel >= 0 && logLevel <= 3, 'logLevel must be between 0 and 3.');

  final String apiKey;
  final String apiUrl;
  final bool enableAppleAdsAttribution;
  final bool isDebug;
  final int logLevel;
  final String? customerUserId;
}

class AttributionResult {
  const AttributionResult({required this.source, required this.confidence, this.campaignName, this.utmSource, this.utmMedium, this.utmCampaign});
  factory AttributionResult.fromJson(Map<dynamic, dynamic> json) {
    return AttributionResult(
      source: json['source'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      campaignName: json['campaignName'] as String?,
      utmSource: json['utmSource'] as String?,
      utmMedium: json['utmMedium'] as String?,
      utmCampaign: json['utmCampaign'] as String?,
    );
  }
  final String source;
  final double confidence;
  final String? campaignName;
  final String? utmSource;
  final String? utmMedium;
  final String? utmCampaign;
}

class DeviceInfo {
  const DeviceInfo({this.deviceModel, this.screenWidth, this.screenHeight, this.locale, this.timezone, this.osVersion, this.idfv, this.idfa, this.adServicesToken});
  factory DeviceInfo.fromJson(Map<dynamic, dynamic> json) {
    return DeviceInfo(
      deviceModel: json['deviceModel'] as String?,
      screenWidth: (json['screenWidth'] as num?)?.toInt(),
      screenHeight: (json['screenHeight'] as num?)?.toInt(),
      locale: json['locale'] as String?,
      timezone: json['timezone'] as String?,
      osVersion: json['osVersion'] as String?,
      idfv: json['idfv'] as String?,
      idfa: json['idfa'] as String?,
      adServicesToken: json['adServicesToken'] as String?,
    );
  }
  final String? deviceModel;
  final int? screenWidth;
  final int? screenHeight;
  final String? locale;
  final String? timezone;
  final String? osVersion;
  final String? idfv;
  final String? idfa;
  final String? adServicesToken;
}

class TestEventResult {
  const TestEventResult({required this.success, required this.message});
  final bool success;
  final String message;
}
