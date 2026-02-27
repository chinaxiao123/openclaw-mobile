import 'package:flutter/material.dart';

/// 大模型设置屏幕
class ModelSettingsScreen extends StatefulWidget {
  const ModelSettingsScreen({super.key});

  @override
  State<ModelSettingsScreen> createState() => _ModelSettingsScreenState();
}

class _ModelSettingsScreenState extends State<ModelSettingsScreen> {
  String _selectedModel = 'qwen3.5-plus';
  String _thinkingMode = 'auto';
  double _temperature = 0.7;
  int _maxTokens = 4096;

  final List<Map<String, dynamic>> _availableModels = [
    {
      'id': 'qwen3.5-plus',
      'name': 'Qwen3.5-Plus',
      'provider': '通义千问',
      'description': '性能均衡，适合日常对话和任务处理',
      'icon': '🤖',
      'recommended': true,
    },
    {
      'id': 'qwen-max',
      'name': 'Qwen-Max',
      'provider': '通义千问',
      'description': '最强性能，适合复杂任务',
      'icon': '🚀',
      'recommended': false,
    },
    {
      'id': 'qwen-plus',
      'name': 'Qwen-Plus',
      'provider': '通义千问',
      'description': '性价比高，响应快速',
      'icon': '⚡',
      'recommended': false,
    },
    {
      'id': 'deepseek-v3',
      'name': 'DeepSeek V3',
      'provider': '深度求索',
      'description': '代码和推理能力强',
      'icon': '💻',
      'recommended': false,
    },
    {
      'id': 'gpt-4o',
      'name': 'GPT-4o',
      'provider': 'OpenAI',
      'description': '国际领先，多语言支持',
      'icon': '🌐',
      'recommended': false,
    },
    {
      'id': 'claude-3.5-sonnet',
      'name': 'Claude 3.5 Sonnet',
      'provider': 'Anthropic',
      'description': '写作和分析能力强',
      'icon': '✍️',
      'recommended': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('大模型设置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 模型选择
          _buildSectionTitle(context, '选择模型'),
          ..._availableModels.map((model) => _buildModelCard(context, model)),

          const SizedBox(height: 32),

          // 思考模式
          _buildSectionTitle(context, '思考模式'),
          _buildThinkingModeSelector(context),

          const SizedBox(height: 32),

          // 高级设置
          _buildSectionTitle(context, '高级设置'),
          _buildTemperatureSlider(context),
          _buildMaxTokensSlider(context),

          const SizedBox(height: 32),

          // 说明
          _buildHelpCard(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildModelCard(BuildContext context, Map<String, dynamic> model) {
    final isSelected = _selectedModel == model['id'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _selectedModel = model['id']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 图标
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(model['icon'], style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              
              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          model['name'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (model['recommended'] == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '推荐',
                              style: TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model['provider'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model['description'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              
              // 选择框
              Radio<String>(
                value: model['id'],
                groupValue: _selectedModel,
                onChanged: (value) {
                  setState(() => _selectedModel = value!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThinkingModeSelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRadioTile(
              context,
              'auto',
              '⚡ 自动',
              '根据任务复杂度自动选择是否深度思考',
            ),
            const Divider(),
            _buildRadioTile(
              context,
              'on',
              '🧠 深度思考',
              '启用推理模式，适合复杂问题（耗时较长）',
            ),
            const Divider(),
            _buildRadioTile(
              context,
              'off',
              '⚡ 快速响应',
              '直接回答，适合简单问题（响应最快）',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(BuildContext context, String value, String title, String subtitle) {
    final isSelected = _thinkingMode == value;
    
    return ListTile(
      leading: Text(title.split(' ').first, style: const TextStyle(fontSize: 24)),
      title: Text(title.split(' ').skip(1).join(' ')),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: Radio<String>(
        value: value,
        groupValue: _thinkingMode,
        onChanged: (v) => setState(() => _thinkingMode = v!),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildTemperatureSlider(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('随机性 (Temperature)'),
                Text(
                  _temperature.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _temperature,
              min: 0,
              max: 1,
              divisions: 10,
              label: _temperature.toStringAsFixed(1),
              onChanged: (value) => setState(() => _temperature = value),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('严谨', style: Theme.of(context).textTheme.bodySmall),
                Text('发散', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaxTokensSlider(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('最大 Token 数'),
                Text(
                  _maxTokens.toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _maxTokens.toDouble(),
              min: 1024,
              max: 8192,
              divisions: 14,
              label: _maxTokens.toString(),
              onChanged: (value) => setState(() => _maxTokens = value.toInt()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('简短', style: Theme.of(context).textTheme.bodySmall),
                Text('详细', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '💡 使用建议',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('日常对话', '推荐 Qwen3.5-Plus + 自动思考'),
          _buildTipItem('复杂问题', '推荐 Qwen-Max + 深度思考'),
          _buildTipItem('代码生成', '推荐 DeepSeek V3 + 温度 0.3'),
          _buildTipItem('创意写作', '推荐 Claude + 温度 0.8'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String scene, String suggestion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(height: 1.5)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$scene：',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: suggestion),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    // TODO: 保存设置到配置
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('设置已保存！当前模型：$_selectedModel'),
        backgroundColor: Colors.green,
      ),
    );
    
    // TODO: 更新 ConfigProvider
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }
}
