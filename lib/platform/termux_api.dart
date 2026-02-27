import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Termux 平台通道 API 调用
class TermuxApi {
  static const platform = MethodChannel('com.openclaw.mobile/termux');

  /// 检查 Termux 是否已安装
  static Future<bool> isTermuxInstalled() async {
    try {
      final result = await platform.invokeMethod('isTermuxInstalled');
      return result as bool;
    } on PlatformException catch (e) {
      debugPrint('检查 Termux 失败：${e.message}');
      return false;
    }
  }

  /// 检查 Termux:API 是否已安装
  static Future<bool> isTermuxApiInstalled() async {
    try {
      final result = await platform.invokeMethod('isTermuxApiInstalled');
      return result as bool;
    } on PlatformException catch (e) {
      debugPrint('检查 Termux:API 失败：${e.message}');
      return false;
    }
  }

  /// 打开 Termux
  static Future<void> openTermux() async {
    try {
      await platform.invokeMethod('openTermux');
    } on PlatformException catch (e) {
      debugPrint('打开 Termux 失败：${e.message}');
      rethrow;
    }
  }

  /// 安装 Termux（跳转应用商店）
  static Future<void> installTermux() async {
    try {
      await platform.invokeMethod('installTermux');
    } on PlatformException catch (e) {
      debugPrint('安装 Termux 失败：${e.message}');
      rethrow;
    }
  }

  /// 安装 Termux:API
  static Future<void> installTermuxApi() async {
    try {
      await platform.invokeMethod('installTermuxApi');
    } on PlatformException catch (e) {
      debugPrint('安装 Termux:API 失败：${e.message}');
      rethrow;
    }
  }

  /// 在 Termux 中执行脚本
  static Future<Map<String, dynamic>> executeInTermux(String script, {String? sessionId}) async {
    try {
      final result = await platform.invokeMethod('executeInTermux', {
        'script': script,
        'sessionId': sessionId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      });
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      debugPrint('执行脚本失败：${e.message}');
      throw Exception('执行失败：${e.message}');
    }
  }

  /// 请求电池优化白名单
  static Future<void> requestBatteryOptimizationExemption() async {
    try {
      await platform.invokeMethod('requestBatteryOptimizationExemption');
    } on PlatformException catch (e) {
      debugPrint('请求电池优化白名单失败：${e.message}');
    }
  }

  /// 检查是否已忽略电池优化
  static Future<bool> isIgnoringBatteryOptimizations() async {
    try {
      final result = await platform.invokeMethod('isIgnoringBatteryOptimizations');
      return result as bool;
    } on PlatformException catch (e) {
      debugPrint('检查电池优化失败：${e.message}');
      return false;
    }
  }

  /// 启动前台服务
  static Future<void> startForegroundService() async {
    try {
      await platform.invokeMethod('startForegroundService');
    } on PlatformException catch (e) {
      debugPrint('启动前台服务失败：${e.message}');
    }
  }

  /// 停止前台服务
  static Future<void> stopForegroundService() async {
    try {
      await platform.invokeMethod('stopForegroundService');
    } on PlatformException catch (e) {
      debugPrint('停止前台服务失败：${e.message}');
    }
  }
}
