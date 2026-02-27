import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/config_provider.dart';

/// Gateway 配置屏幕
class GatewayConfigScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const GatewayConfigScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<GatewayConfigScreen> createState() => _GatewayConfigScreenState();
}

class _GatewayConfigScreenState extends State<GatewayConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: '18789');
  final _tokenController = TextEditingController();

  bool _isTesting = false;
  bool? _testResult;
  String? _testError;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              '配置 Gateway',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '输入您的 OpenClaw Gateway 连接信息',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),

            const SizedBox(height: 48),

            // Gateway 主机地址
            TextFormField(
              controller: _hostController,
              decoration: const InputDecoration(
                labelText: 'Gateway 地址',
                hintText: '例如：192.168.1.100 或 openclaw.example.com',
                prefixIcon: Icon(Icons.dns_outlined),
                helperText: '本地运行通常为 127.0.0.1 或局域网 IP',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入 Gateway 地址';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // 端口
            TextFormField(
              controller: _portController,
              decoration: const InputDecoration(
                labelText: '端口',
                hintText: '18789',
                prefixIcon: Icon(Icons.numbers_outlined),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入端口';
                }
                final port = int.tryParse(value);
                if (port == null || port < 1 || port > 65535) {
                  return '请输入有效的端口号 (1-65535)';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Token
            TextFormField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: '认证 Token',
                hintText: '您的 Gateway 访问令牌',
                prefixIcon: Icon(Icons.key_outlined),
                helperText: '可在 Gateway 配置中获取',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入 Token';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // 测试连接按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isTesting ? null : _testConnection,
                icon: _isTesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.wifi_find),
                label: Text(_isTesting ? '测试中...' : '测试连接'),
              ),
            ),

            // 测试结果显示
            if (_testResult == true)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '连接成功！可以继续使用',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            else if (_testResult == false)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _testError ?? '连接失败，请检查配置',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            // 帮助信息
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        '如何获取这些信息？',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. Gateway 地址：运行 OpenClaw 的设备 IP\n'
                    '2. 端口：默认为 18789\n'
                    '3. Token：在 Gateway 配置文件中查看',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isTesting = true;
      _testResult = null;
      _testError = null;
    });

    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    
    // 保存配置并测试
    final success = await configProvider.saveConfig(
      host: _hostController.text.trim(),
      port: int.parse(_portController.text.trim()),
      token: _tokenController.text.trim(),
    );

    if (success) {
      final testSuccess = await configProvider.testConnection();
      setState(() {
        _testResult = testSuccess;
        _isTesting = false;
      });

      if (testSuccess) {
        // 延迟后自动进入下一步
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) widget.onNext();
        });
      }
    } else {
      setState(() {
        _testResult = false;
        _testError = configProvider.error;
        _isTesting = false;
      });
    }
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _tokenController.dispose();
    super.dispose();
  }
}
