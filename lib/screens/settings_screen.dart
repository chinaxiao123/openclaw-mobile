import 'package:flutter/material.dart';
import 'model_settings_screen.dart';

/// 设置屏幕
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 关于
          _buildSectionHeader(context, '关于'),
          _buildListTile(
            context,
            icon: Icons.info_outline,
            title: '关于 OpenClaw',
            subtitle: '版本 1.0.0',
            onTap: () => _showAbout(context),
          ),
          _buildListTile(
            context,
            icon: Icons.description_outlined,
            title: '用户协议',
            onTap: () {},
          ),
          _buildListTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: '隐私政策',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // 模型设置
          _buildSectionHeader(context, '模型'),
          _buildListTile(
            context,
            icon: Icons.psychology_outlined,
            title: '大模型设置',
            subtitle: 'Qwen3.5-Plus · 自动思考',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ModelSettingsScreen()),
              );
            },
          ),

          const SizedBox(height: 24),

          // 连接设置
          _buildSectionHeader(context, '连接'),
          _buildListTile(
            context,
            icon: Icons.dns_outlined,
            title: 'Gateway 配置',
            subtitle: '127.0.0.1:18789',
            onTap: () {
              // TODO: 跳转到配置页面
            },
          ),
          _buildListTile(
            context,
            icon: Icons.wifi_find,
            title: '测试连接',
            onTap: () {
              // TODO: 测试连接
            },
          ),

          const SizedBox(height: 24),

          // 大模型设置
          _buildSectionHeader(context, '大模型'),
          _buildListTile(
            context,
            icon: Icons.psychology_outlined,
            title: '模型选择',
            subtitle: 'qwen3.5-plus',
            onTap: () {
              _showModelSelector(context);
            },
          ),
          _buildListTile(
            context,
            icon: Icons.speed_outlined,
            title: '思考模式',
            subtitle: '自动',
            onTap: () {
              _showThinkingMode(context);
            },
          ),
          _buildListTile(
            context,
            icon: Icons.memory_outlined,
            title: '上下文长度',
            subtitle: '默认',
            onTap: () {
              // TODO: 上下文设置
            },
          ),

          const SizedBox(height: 24),

          // 部署管理
          _buildSectionHeader(context, '部署'),
          _buildListTile(
            context,
            icon: Icons.refresh,
            title: '重启 Gateway',
            onTap: () {
              _showConfirmDialog(
                context,
                '确定要重启 Gateway 吗？',
                () {
                  // TODO: 重启 Gateway
                  Navigator.pop(context);
                },
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.bug_report,
            title: '查看日志',
            onTap: () {
              // TODO: 查看日志
            },
          ),
          _buildListTile(
            context,
            icon: Icons.delete_outline,
            title: '清除部署',
            subtitle: '删除所有本地数据',
            isDestructive: true,
            onTap: () {
              _showConfirmDialog(
                context,
                '确定要清除部署吗？此操作不可恢复！',
                () {
                  // TODO: 清除部署
                  Navigator.pop(context);
                },
              );
            },
          ),

          const SizedBox(height: 24),

          // 其他
          _buildSectionHeader(context, '其他'),
          _buildListTile(
            context,
            icon: Icons.help_outline,
            title: '帮助与反馈',
            onTap: () {},
          ),
          _buildListTile(
            context,
            icon: Icons.star_outline,
            title: '给个好评',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'OpenClaw',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ),
      children: [
        const Text('OpenClaw 移动端客户端'),
        const SizedBox(height: 8),
        const Text('让 AI Agent 管理触手可及'),
        const SizedBox(height: 16),
        const Text('© 2026 OpenClaw Project'),
      ],
    );
  }

  void _showConfirmDialog(BuildContext context, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  void _showModelSelector(BuildContext context) {
    final models = [
      {'name': 'qwen3.5-plus', 'desc': '通义千问，平衡性能和速度'},
      {'name': 'qwen-max', 'desc': '通义千问，最强性能'},
      {'name': 'gpt-4', 'desc': 'OpenAI GPT-4'},
      {'name': 'claude-3', 'desc': 'Anthropic Claude 3'},
      {'name': 'gemini-pro', 'desc': 'Google Gemini Pro'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '选择大模型',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: models.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final model = models[index];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.smart_toy,
                              color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        title: Text(
                          model['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          model['desc'] as String,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Icon(Icons.check_circle,
                            color: index == 0
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent),
                        onTap: () {
                          // TODO: 保存模型选择
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThinkingMode(BuildContext context) {
    final modes = [
      {'name': '自动', 'desc': '根据问题复杂度自动选择', 'icon': Icons.auto_awesome},
      {'name': '快速', 'desc': '跳过深度思考，快速响应', 'icon': Icons.flash_on},
      {'name': '深度', 'desc': '深度思考，提供更详细答案', 'icon': Icons.psychology},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '思考模式',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: modes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mode = modes[index];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: index == 0
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            mode['icon'] as IconData,
                            color: index == 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        title: Text(
                          mode['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: index == 0
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                        subtitle: Text(mode['desc'] as String),
                        trailing: index == 0
                            ? Icon(Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary)
                            : null,
                        onTap: () {
                          // TODO: 保存思考模式
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
