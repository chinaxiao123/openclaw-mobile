import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Termux 部署服务 - 管理 Termux 自动化部署
class TermuxDeployService extends ChangeNotifier {
  bool _isTermuxInstalled = false;
  bool _isDeploying = false;
  bool _isDeployed = false;
  String? _deployError;
  Map<String, dynamic>? _connectionInfo;
  double _progress = 0;
  String _currentStep = '';

  // Getters
  bool get isTermuxInstalled => _isTermuxInstalled;
  bool get isDeploying => _isDeploying;
  bool get isDeployed => _isDeployed;
  String? get deployError => _deployError;
  Map<String, dynamic>? get connectionInfo => _connectionInfo;
  double get progress => _progress;
  String get currentStep => _currentStep;

  /// 检查 Termux 是否已安装
  Future<bool> checkTermuxInstalled() async {
    try {
      // 通过 Android Intent 检查
      // 实际实现需要平台通道调用原生代码
      // 这里模拟检测逻辑
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: 实现原生检测
      _isTermuxInstalled = true; // 模拟已安装
      notifyListeners();
      return _isTermuxInstalled;
    } catch (e) {
      _isTermuxInstalled = false;
      _deployError = '无法检测 Termux: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// 引导用户安装 Termux
  Future<void> installTermux() async {
    // 打开 Google Play 或 F-Droid
    // TODO: 实现原生跳转
    print('打开 Termux 安装页面...');
  }

  /// 开始部署
  Future<bool> startDeployment() async {
    try {
      _isDeploying = true;
      _deployError = null;
      _progress = 0;
      notifyListeners();

      // 步骤 1: 检查 Termux
      _currentStep = '检查 Termux 环境...';
      _progress = 0.1;
      notifyListeners();

      if (!await checkTermuxInstalled()) {
        throw Exception('Termux 未安装');
      }

      // 步骤 2: 推送部署脚本
      _currentStep = '推送部署脚本...';
      _progress = 0.2;
      notifyListeners();

      final scriptUrl = 'https://raw.githubusercontent.com/your-repo/openclaw-mobile/main/termux/install.sh';
      final scriptContent = await _downloadScript(scriptUrl);

      // 步骤 3: 通过 Termux API 执行脚本
      _currentStep = '执行安装脚本...';
      _progress = 0.3;
      notifyListeners();

      final result = await _executeInTermux(scriptContent);

      // 步骤 4: 解析结果
      _currentStep = '解析部署结果...';
      _progress = 0.9;
      notifyListeners();

      if (result['success'] == true) {
        _connectionInfo = result;
        _isDeployed = true;
        
        // 保存连接信息
        await _saveConnectionInfo(result);
        
        _progress = 1.0;
        _currentStep = '部署完成！';
        notifyListeners();
        return true;
      } else {
        throw Exception(result['message'] ?? '部署失败');
      }
    } catch (e) {
      _deployError = e.toString();
      _isDeploying = false;
      _progress = 0;
      notifyListeners();
      return false;
    } finally {
      _isDeploying = false;
    }
  }

  /// 下载部署脚本
  Future<String> _downloadScript(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('下载脚本失败：${response.statusCode}');
      }
    } catch (e) {
      // 如果下载失败，使用本地脚本
      throw Exception('无法下载部署脚本：${e.toString()}');
    }
  }

  /// 在 Termux 中执行命令
  Future<Map<String, dynamic>> _executeInTermux(String script) async {
    // 通过 Termux:API 执行
    // 需要使用 platform channel 调用原生代码
    // 这里模拟执行过程
    
    // 模拟执行延迟
    await Future.delayed(const Duration(seconds: 2));
    _progress = 0.5;
    notifyListeners();

    // 模拟脚本执行中的各个阶段
    final steps = [
      '更新 Termux 包...',
      '安装 Python...',
      '安装 Node.js...',
      '安装 OpenClaw...',
      '安装 Agent Reach...',
      '配置环境...',
      '启动 Gateway...',
    ];

    for (final step in steps) {
      _currentStep = step;
      _progress = 0.3 + (steps.indexOf(step) / steps.length) * 0.5;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 800));
    }

    // 模拟返回结果
    return {
      'success': true,
      'gateway_host': '127.0.0.1',
      'gateway_port': 18789,
      'gateway_token': 'oc-mock-token-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'running',
      'message': '部署成功',
    };
  }

  /// 保存连接信息
  Future<void> _saveConnectionInfo(Map<String, dynamic> info) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gateway_host', info['gateway_host']);
    await prefs.setInt('gateway_port', info['gateway_port']);
    await prefs.setString('gateway_token', info['gateway_token']);
    await prefs.setBool('is_deployed', true);
    await prefs.setBool('deploy_type', true); // true = local, false = remote
  }

  /// 检查部署状态
  Future<bool> checkDeploymentStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isDeployed = prefs.getBool('is_deployed') ?? false;
    
    if (_isDeployed) {
      _connectionInfo = {
        'gateway_host': prefs.getString('gateway_host') ?? '127.0.0.1',
        'gateway_port': prefs.getInt('gateway_port') ?? 18789,
        'gateway_token': prefs.getString('gateway_token') ?? '',
      };
    }
    
    notifyListeners();
    return _isDeployed;
  }

  /// 重启 Gateway 服务
  Future<bool> restartGateway() async {
    try {
      // 通过 Termux API 发送重启命令
      await _executeInTermux('pkill -f "openclaw gateway" && ~/.openclaw/start_gateway.sh');
      return true;
    } catch (e) {
      _deployError = '重启失败：${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// 停止 Gateway 服务
  Future<bool> stopGateway() async {
    try {
      await _executeInTermux('pkill -f "openclaw gateway"');
      return true;
    } catch (e) {
      _deployError = '停止失败：${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// 查看日志
  Future<String> viewLogs({int lines = 50}) async {
    try {
      // 通过 Termux API 获取日志
      // 模拟返回
      return '[INFO] Gateway started\n[INFO] Listening on 127.0.0.1:18789\n...';
    } catch (e) {
      return '无法获取日志：${e.toString()}';
    }
  }

  /// 清除部署
  Future<void> clearDeployment() async {
    try {
      await _executeInTermux('rm -rf ~/.openclaw && pkill -f "openclaw"');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      _isDeployed = false;
      _connectionInfo = null;
      notifyListeners();
    } catch (e) {
      _deployError = '清除失败：${e.toString()}';
      notifyListeners();
    }
  }
}
