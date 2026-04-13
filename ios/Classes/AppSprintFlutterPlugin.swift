import Flutter
import UIKit
import AppSprintSDK

public class AppSprintFlutterPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "appsprint_flutter/native", binaryMessenger: registrar.messenger())
    let instance = AppSprintFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {

    // MARK: - Core SDK

    case "configure":
      guard let args = call.arguments as? [String: Any],
            let apiKey = args["apiKey"] as? String, !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        result(FlutterError(code: "CONFIGURE_ERROR", message: "AppSprint.configure requires a non-empty apiKey.", details: nil))
        return
      }
      Task { @MainActor in
        let enableAppleAds = args["enableAppleAdsAttribution"] as? Bool ?? true
        let isDebug = args["isDebug"] as? Bool ?? false
        let logLevelRaw = args["logLevel"] as? Int
        let customerUserId = args["customerUserId"] as? String

        let logLevel: AppSprintLogLevel
        if let raw = logLevelRaw, let level = AppSprintLogLevel(rawValue: raw) {
          logLevel = level
        } else {
          logLevel = isDebug ? .debug : .warn
        }

        var sdkConfig = AppSprintConfig(
          apiKey: apiKey,
          enableAppleAdsAttribution: enableAppleAds,
          isDebug: isDebug,
          logLevel: logLevel,
          customerUserId: customerUserId
        )

        if let urlString = args["apiUrl"] as? String, let url = URL(string: urlString) {
          sdkConfig = AppSprintConfig(
            apiKey: apiKey,
            apiURL: url,
            enableAppleAdsAttribution: enableAppleAds,
            isDebug: isDebug,
            logLevel: logLevel,
            customerUserId: customerUserId
          )
        }

        await AppSprint.shared.configure(sdkConfig)
        result(nil)
      }

    case "sendEvent":
      guard let args = call.arguments as? [String: Any],
            let eventTypeStr = args["eventType"] as? String else {
        result(FlutterError(code: "SEND_EVENT_ERROR", message: "eventType is required", details: nil))
        return
      }
      Task { @MainActor in
        let type = AppSprintEventType(rawValue: eventTypeStr) ?? .custom
        let name = args["name"] as? String
        var params: [String: Any]? = args["parameters"] as? [String: Any]

        if let rev = args["revenue"] as? Double {
          if params == nil { params = [:] }
          params?["revenue"] = rev
        }
        if let cur = args["currency"] as? String {
          if params == nil { params = [:] }
          params?["currency"] = cur
        }

        await AppSprint.shared.sendEvent(type, name: name, params: params)
        result(nil)
      }

    case "sendTestEvent":
      Task { @MainActor in
        let r = await AppSprint.shared.sendTestEvent()
        result(["success": r.success, "message": r.message])
      }

    case "flush":
      Task { @MainActor in
        await AppSprint.shared.flush()
        result(nil)
      }

    case "clearData":
      Task { @MainActor in
        AppSprint.shared.clearData()
        result(nil)
      }

    case "setCustomerUserId":
      guard let args = call.arguments as? [String: Any],
            let userId = args["userId"] as? String else {
        result(FlutterError(code: "SET_USER_ID_ERROR", message: "userId is required", details: nil))
        return
      }
      Task { @MainActor in
        await AppSprint.shared.setCustomerUserId(userId)
        result(nil)
      }

    case "enableAppleAdsAttribution":
      Task { @MainActor in
        AppSprint.shared.enableAppleAdsAttribution()
        result(nil)
      }

    case "getAppSprintId":
      Task { @MainActor in
        result(AppSprint.shared.getAppSprintId())
      }

    case "getAttribution":
      Task { @MainActor in
        guard let attr = AppSprint.shared.getAttribution() else {
          result(nil)
          return
        }
        var dict: [String: Any] = [
          "source": attr.source,
          "confidence": attr.confidence,
        ]
        if let c = attr.campaignName { dict["campaignName"] = c }
        if let s = attr.utmSource { dict["utmSource"] = s }
        if let m = attr.utmMedium { dict["utmMedium"] = m }
        if let c = attr.utmCampaign { dict["utmCampaign"] = c }
        result(dict)
      }

    case "isInitialized":
      Task { @MainActor in
        result(AppSprint.shared.isInitialized)
      }

    case "isSdkDisabled":
      Task { @MainActor in
        result(AppSprint.shared.isSdkDisabled())
      }

    case "destroy":
      Task { @MainActor in
        AppSprint.shared.destroy()
        result(nil)
      }

    // MARK: - Utility

    case "getDeviceInfo":
      Task { @MainActor in
        let info = AppSprintNative.getDeviceInfo()
        var dict: [String: Any] = [:]
        if let m = info.deviceModel { dict["deviceModel"] = m }
        if let w = info.screenWidth { dict["screenWidth"] = w }
        if let h = info.screenHeight { dict["screenHeight"] = h }
        if let l = info.locale { dict["locale"] = l }
        if let t = info.timezone { dict["timezone"] = t }
        if let o = info.osVersion { dict["osVersion"] = o }
        if let v = info.idfv { dict["idfv"] = v }
        if let a = info.idfa { dict["idfa"] = a }
        if let tk = info.adServicesToken { dict["adServicesToken"] = tk }
        result(dict)
      }

    case "getAdServicesToken":
      let token = AppSprintNative.getAdServicesToken()
      result(token as Any)

    case "requestTrackingAuthorization":
      Task {
        let authorized = await AppSprintNative.requestTrackingAuthorization()
        result(authorized)
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
