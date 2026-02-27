import 'package:flutter/material.dart';

/// Agent 状态屏幕
class AgentStatusScreen extends StatelessWidget {
  const AgentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent 状态'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 状态卡片
          _buildStatusCard(
            context,
            '运行状态',
            '在线',
            Icons.check_circle,
            Colors.green,
          ),
          const SizedBox(height: 16),
          
          _buildStatusCard(
            context,
            '模型',
            'qwen3.5-plus',
            Icons.memory,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          
          _buildStatusCard(
            context,
            '会话数',
            '1',
            Icons.chat,
            Colors.orange,
          ),
          const SizedBox(height: 32),
          
          // 操作按钮
          ElevatedButton.icon(
            onPressed: () {
              // TODO: 重启 Agent
            },
            icon: const Icon(Icons.refresh),
            label: const Text('重启 Agent'),
          ),
          const SizedBox(height: 12),
          
          OutlinedButton.icon(
            onPressed: () {
              // TODO: 查看日志
            },
            icon: const Icon(Icons.bug_report),
            label: const Text('查看日志'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
