import 'package:flutter/foundation.dart';
import 'message.dart';

/// 会话提供者 - 管理聊天消息
class SessionProvider extends ChangeNotifier {
  final List<Message> _messages = [];
  String? _currentSessionId;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Message> get messages => List.unmodifiable(_messages);
  String? get currentSessionId => _currentSessionId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 添加消息
  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  /// 添加多条消息
  void addMessages(List<Message> newMessages) {
    _messages.addAll(newMessages);
    notifyListeners();
  }

  /// 清除所有消息
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  /// 删除最后一条消息
  void removeLastMessage() {
    if (_messages.isNotEmpty) {
      _messages.removeLast();
      notifyListeners();
    }
  }

  /// 设置当前会话
  void setCurrentSession(String sessionId) {
    _currentSessionId = sessionId;
    notifyListeners();
  }

  /// 加载历史消息（从本地存储或服务器）
  Future<void> loadHistory({String? sessionId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: 从本地存储或服务器加载历史消息
      // 模拟延迟
      await Future.delayed(const Duration(milliseconds: 500));

      _currentSessionId = sessionId ?? DateTime.now().millisecondsSinceEpoch.toString();
    } catch (e) {
      _error = '加载失败：${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 发送消息到 Gateway
  Future<bool> sendMessageToGateway(String content) async {
    try {
      // TODO: 通过 WebSocket 发送到 Gateway
      // 这里先模拟
      await Future.delayed(const Duration(milliseconds: 1000));
      return true;
    } catch (e) {
      _error = '发送失败：${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
