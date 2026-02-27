import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket 服务 - 连接 OpenClaw Gateway
class WebSocketService extends ChangeNotifier {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _isConnecting = false;
  String? _error;
  String? _host;
  int? _port;
  String? _token;

  // Getters
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  String? get error => _error;
  String? get host => _host;
  int? get port => _port;

  // 消息流控制器
  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  /// 连接到 Gateway
  Future<bool> connect({
    required String host,
    required int port,
    required String token,
  }) async {
    try {
      _isConnecting = true;
      _error = null;
      notifyListeners();

      _host = host;
      _port = port;
      _token = token;

      // 构建 WebSocket URL
      final wsUrl = 'ws://$host:$port';
      
      // 创建 WebSocket 连接
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // 监听连接
      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          _handleError(error);
        },
        onDone: () {
          _handleDisconnect();
        },
      );

      // 发送认证消息
      await _sendAuth(token);

      // 等待连接确认
      await Future.delayed(const Duration(milliseconds: 500));

      if (_isConnected) {
        _isConnecting = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('连接超时');
      }
    } catch (e) {
      _error = '连接失败：${e.toString()}';
      _isConnecting = false;
      _isConnected = false;
      notifyListeners();
      return false;
    }
  }

  /// 发送认证
  Future<void> _sendAuth(String token) async {
    if (_channel == null) return;

    final authMessage = jsonEncode({
      'type': 'auth',
      'token': token,
    });

    _channel!.sink.add(authMessage);
  }

  /// 处理接收到的消息
  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        final data = jsonDecode(message);
        
        // 检查是否是认证响应
        if (data['type'] == 'auth_response') {
          if (data['success'] == true) {
            _isConnected = true;
            _isConnecting = false;
            notifyListeners();
          } else {
            _error = '认证失败：${data['message']}';
            _isConnected = false;
            notifyListeners();
          }
        } else {
          // 转发其他消息
          _messageController.add(message);
        }
      }
    } catch (e) {
      debugPrint('解析消息失败：$e');
    }
  }

  /// 处理错误
  void _handleError(dynamic error) {
    _error = 'WebSocket 错误：${error.toString()}';
    _isConnected = false;
    _isConnecting = false;
    notifyListeners();
  }

  /// 处理断开连接
  void _handleDisconnect() {
    _isConnected = false;
    _channel = null;
    notifyListeners();
  }

  /// 发送消息
  Future<bool> send(Map<String, dynamic> message) async {
    if (!_isConnected || _channel == null) {
      _error = '未连接';
      notifyListeners();
      return false;
    }

    try {
      final jsonMessage = jsonEncode(message);
      _channel!.sink.add(jsonMessage);
      return true;
    } catch (e) {
      _error = '发送失败：${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// 发送聊天消息
  Future<bool> sendChatMessage(String content) async {
    return send({
      'type': 'message',
      'role': 'user',
      'content': content,
    });
  }

  /// 断开连接
  Future<void> disconnect() async {
    try {
      if (_channel != null) {
        await _channel!.sink.close();
        _channel = null;
      }
      _isConnected = false;
      _isConnecting = false;
      notifyListeners();
    } catch (e) {
      debugPrint('断开连接失败：$e');
    }
  }

  /// 重连
  Future<bool> reconnect() async {
    if (_host != null && _port != null && _token != null) {
      return connect(
        host: _host!,
        port: _port!,
        token: _token!,
      );
    }
    return false;
  }

  @override
  void dispose() {
    disconnect();
    _messageController.close();
    super.dispose();
  }
}
