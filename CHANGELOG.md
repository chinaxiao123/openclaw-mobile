# 更新日志

## [1.0.0] - 2026-02-27

### ✨ 新增功能

#### 🎨 Logo 设计
- **品牌 Logo** - 机器人🤖 + 金色大 G 元素
- **Slogan** - "赚钱买大 G"
- **配色方案** - 经典紫渐变 (#667eea → #764ba2)
- **多尺寸支持** - APP 图标/启动页/聊天头像

#### 🧠 大模型设置
新增完整的模型配置界面，支持：

**模型选择** (6 款主流模型)
- ✅ Qwen3.5-Plus (推荐) - 性能均衡，日常使用
- ✅ Qwen-Max - 最强性能，复杂任务
- ✅ Qwen-Plus - 性价比高，响应快速
- ✅ DeepSeek V3 - 代码和推理能力强
- ✅ GPT-4o - 国际领先，多语言
- ✅ Claude 3.5 Sonnet - 写作和分析能力强

**思考模式**
- ⚡ 自动 - 根据任务自动选择
- 🧠 深度思考 - 推理模式，适合复杂问题
- ⚡ 快速响应 - 直接回答，简单问题

**高级参数**
- 🎚️ 随机性 (Temperature) - 0.0-1.0 可调
- 📝 最大 Token 数 - 1024-8192 可调

**智能推荐**
- 日常对话 → Qwen3.5-Plus + 自动思考
- 复杂问题 → Qwen-Max + 深度思考
- 代码生成 → DeepSeek V3 + 温度 0.3
- 创意写作 → Claude + 温度 0.8

### 📱 界面更新

#### 启动页
- 新增品牌 Logo（机器人 + 大 G）
- 添加 Slogan "赚钱买大 G"
- 优化加载动画

#### 设置页
- 新增"模型"分类
- 添加"大模型设置"入口
- 显示当前模型和思考模式

#### 新增屏幕
- `ModelSettingsScreen` - 大模型设置界面
- 卡片式模型选择
- 滑块式参数调节
- 使用建议提示卡片

### 🔧 技术更新

#### 状态管理
- `ConfigProvider` 新增模型相关字段
  - `selectedModel` - 当前选择的模型
  - `thinkingMode` - 思考模式
  - `temperature` - 随机性参数
  - `maxTokens` - 最大 Token 数
- 新增 `saveModelSettings()` 方法

#### 文件结构
```
lib/
├── screens/
│   └── model_settings_screen.dart    ← 新增
├── providers/
│   └── config_provider.dart          ← 更新
└── assets/
    └── images/
        ├── LOGO_GUIDELINES.md        ← 新增
        └── logo_design.html          ← 新增
```

### 📄 文档更新
- `LOGO_GUIDELINES.md` - Logo 使用规范
- `UI_PREVIEW_FULL.html` - 完整 UI 预览（含新界面）
- `CHANGELOG.md` - 本文件

### 🎯 待完成
- [ ] 模型设置持久化存储
- [ ] 实际切换模型 API 调用
- [ ] Logo 资源文件导出（PNG/SVG）
- [ ] APP 图标生成

---

## 预览方式

### UI 预览
双击打开 `UI_PREVIEW_FULL.html` 查看完整界面设计

### Logo 设计
双击打开 `assets/images/logo_design.html` 查看 Logo 方案

---

**赚钱买大 G，早日开豪车！** 🚀💰
