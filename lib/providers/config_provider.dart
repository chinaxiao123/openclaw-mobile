import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 配置提供者 - 管理 Gateway 连接配置
class ConfigProvider extends ChangeNotifier {
  static const _keyGatewayHost = 'gateway_host';
  static const _keyGatewayPort = 'gateway_port';
  static const _keyGatewayToken = 'gateway_token';
  static const _keyIsConfigured = 'is_configured';

  String _gatewayHost = '';
  int _gatewayPort = 18789;
  String _gatewayToken = '';
  bool _isConfigured = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  String get gatewayHost => _gatewayHost;
  int get gatewayPort => _gatewayPort;
  String get gatewayToken => _gatewayToken;
  bool get isConfigured => _isConfigured;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  String get gatewayUrl => 'ws://$_gatewayHost:$_gatewayPort';

  /// 加载配置
  Future<bool> loadConfig() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      _gatewayHost = prefs.getString(_keyGatewayHost) ?? '';
      _gatewayPort = prefs.getInt(_keyGatewayPort) ?? 18789;
      _gatewayToken = prefs.getString(_keyGatewayToken) ?? '';
      _isConfigured = prefs.getBool(_keyIsConfigured) ?? false;
      
      _error = null;
      return _isConfigured;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 保存配置
  Future<bool> saveConfig({
    required String host,
    required int port,
    required String token,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyGatewayHost, host);
      await prefs.setInt(_keyGatewayPort, port);
      await prefs.setString(_keyGatewayToken, token);
      await prefs.setBool(_keyIsConfigured, true);

      _gatewayHost = host;
      _gatewayPort = port;
      _gatewayToken = token;
      _isConfigured = true;
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 测试连接
  Future<bool> testConnection() async {
    try {
      // TODO: 实现 WebSocket 连接测试
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      _error = '连接失败：${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// 清除配置
  Future<void> clearConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _gatewayHost = '';
    _gatewayPort = 18789;
    _gatewayToken = '';
    _isConfigured = false;
    _error = null;
    
    notifyListeners();
  }
}
