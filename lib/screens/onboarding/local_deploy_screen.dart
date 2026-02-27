import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../services/termux_deploy_service.dart';
import '../home_screen.dart';

/// 本地部署屏幕 - Termux 自动部署
class LocalDeployScreen extends StatefulWidget {
  const LocalDeployScreen({super.key});

  @override
  State<LocalDeployScreen> createState() => _LocalDeployScreenState();
}

class _LocalDeployScreenState extends State<LocalDeployScreen> {
  @override
  void initState() {
    super.initState();
    _checkTermux();
  }

  Future<void> _checkTermux() async {
    final service = Provider.of<TermuxDeployService>(context, listen: false);
    await service.checkTermuxInstalled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('本地部署'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<TermuxDeployService>(
        builder: (context, service, child) {
          if (service.isDeployed) {
            return _buildDeployedView(context, service);
          }

          if (service.isDeploying) {
            return _buildDeployingView(context, service);
          }

          if (!service.isTermuxInstalled) {
            return _buildInstallTermuxView(context, service);
          }

          return _buildReadyToDeployView(context, service);
        },
      ),
    );
  }

  Widget _buildInstallTermuxView(BuildContext context, TermuxDeployService service) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.android,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          )
              .animate()
              .scale(delay: 200.ms, duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 32),

          Text(
            '需要安装 Termux',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 16),

          Text(
            'Termux 是一个强大的终端模拟器，OpenClaw 需要它来运行 Gateway 服务。',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 48),

          // 功能介绍
          _buildFeatureItem(
            context,
            Icons.terminal,
            '完整 Linux 环境',
            '可以运行 Python、Node.js 等工具',
          ),
          _buildFeatureItem(
            context,
            Icons.security,
            '无需 Root',
            '安全运行，不影响系统',
          ),
          _buildFeatureItem(
            context,
            Icons.cloud_sync,
            '本地运行',
            '数据不出手机，隐私安全',
          ),

          const Spacer(),

          // 安装按钮
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => service.installTermux(),
              icon: const Icon(Icons.download),
              label: const Text(
                '安装 Termux',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ).animate().fadeIn(delay: 1000.ms),

          const SizedBox(height: 16),

          TextButton(
            onPressed: () {
              // TODO: 切换到远程配置
            },
            child: const Text('我想配置远程 Gateway'),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyToDeployView(BuildContext context, TermuxDeployService service) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          )
              .animate()
              .scale(delay: 200.ms, duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 48),

          Text(
            '准备部署 OpenClaw',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 16),

          Text(
            '将在 Termux 中自动安装并配置 OpenClaw Gateway',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 48),

          // 部署步骤
          _buildStepItem(context, '安装 Python 和 Node.js', 1),
          _buildStepItem(context, '安装 OpenClaw Gateway', 2),
          _buildStepItem(context, '安装 Agent Reach', 3),
          _buildStepItem(context, '配置并启动服务', 4),

          const Spacer(),

          // 开始部署按钮
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => service.startDeployment(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '开始部署',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ).animate().fadeIn(delay: 1000.ms),

          const SizedBox(height: 16),

          Text(
            '预计需要 3-5 分钟，请保持网络畅通',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ).animate().fadeIn(delay: 1200.ms),
        ],
      ),
    );
  }

  Widget _buildDeployingView(BuildContext context, TermuxDeployService service) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 加载动画
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: service.progress,
                  strokeWidth: 8,
                ),
                Text(
                  '${(service.progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ).animate().scale(delay: 200.ms, duration: 500.ms),

          const SizedBox(height: 48),

          Text(
            service.currentStep,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 16),

          Text(
            '请稍候，正在自动安装和配置...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 48),

          // 日志输出区域
          Container(
            width: double.infinity,
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
                    Icon(Icons.terminal,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      '安装日志',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '> ${service.currentStep}\n...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }

  Widget _buildDeployedView(BuildContext context, TermuxDeployService service) {
    final info = service.connectionInfo;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // 成功图标
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green,
            ),
          ).animate().scale(delay: 200.ms, duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 48),

          Text(
            '部署成功！',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 32),

          // 连接信息卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildInfoRow(context, '地址', info?['gateway_host'] ?? '127.0.0.1'),
                const Divider(height: 32),
                _buildInfoRow(context, '端口', '${info?['gateway_port'] ?? 18789}'),
                const Divider(height: 32),
                _buildInfoRow(context, '状态', '运行中', success: true),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 32),

          // 操作按钮
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text('进入应用', style: TextStyle(fontSize: 18)),
            ),
          ).animate().fadeIn(delay: 800.ms),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () => service.restartGateway(),
            icon: const Icon(Icons.refresh),
            label: const Text('重启 Gateway'),
          ).animate().fadeIn(delay: 1000.ms),

          const SizedBox(height: 12),

          TextButton.icon(
            onPressed: () => service.viewLogs(),
            icon: const Icon(Icons.bug_report),
            label: const Text('查看日志'),
          ).animate().fadeIn(delay: 1200.ms),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$index', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool success = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Row(
          children: [
            if (success)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              ),
            const SizedBox(width: 8),
            Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
