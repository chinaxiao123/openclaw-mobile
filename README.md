# OpenClaw Mobile

📱 在安卓手机上本地部署 OpenClaw，让 AI Agent 真正随身而行。

[![Build](https://img.shields.io/github/actions/workflow/status/your-repo/openclaw-mobile/build.yml)](https://github.com/your-repo/openclaw-mobile/actions)
[![Release](https://img.shields.io/github/v/release/your-repo/openclaw-mobile)](https://github.com/your-repo/openclaw-mobile/releases)
[![License](https://img.shields.io/github/license/your-repo/openclaw-mobile)](LICENSE)

---

## ✨ 特性

- 🚀 **一键部署** - 自动在 Termux 中安装配置 OpenClaw
- 🔧 **向导配置** - 3 步完成设置，上手即用
- 💬 **实时对话** - 与您的 Agent 随时随地聊天
- 📊 **状态监控** - 查看 Agent 运行状态和日志
- 🔒 **隐私安全** - 本地运行，数据不出手机
- 🎨 **精美 UI** - Material Design 3，深色模式

---

## 📸 截图

（待添加）

---

## 🚀 快速开始

### 方式 1：下载 APK（推荐）

从 [Releases](https://github.com/your-repo/openclaw-mobile/releases) 下载最新 APK 安装。

### 方式 2：自行编译

```bash
# 1. 克隆项目
git clone https://github.com/your-repo/openclaw-mobile.git
cd openclaw-mobile

# 2. 获取依赖
flutter pub get

# 3. 运行
flutter run

# 4. 构建 APK
flutter build apk --release
```

---

## 📦 使用说明

### 首次使用

1. **安装 APP** - 下载并安装 APK
2. **选择部署方式**
   - 本地部署（推荐）- 自动安装到 Termux
   - 远程配置 - 连接已有 Gateway
3. **完成配置** - 跟随向导完成设置
4. **开始使用** - 与 Agent 对话！

### 本地部署流程

```
安装 APP → 检测 Termux → 自动部署 → 启动服务 → 完成
         ↓
    如需安装
         ↓
   跳转应用商店
```

---

## 🏗️ 架构设计

```
┌────────────────────────────────────────┐
│         Flutter APP (UI 层)             │
│  ┌──────────────────────────────────┐  │
│  │  Providers (状态管理)            │  │
│  │  - ConfigProvider                │  │
│  │  - SessionProvider               │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  Services (业务逻辑)             │  │
│  │  - TermuxDeployService           │  │
│  │  - WebSocketService              │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
              │
              │ Platform Channel
              ▼
┌────────────────────────────────────────┐
│      Android Native (原生层)            │
│  - Termux 检测和安装                    │
│  - 脚本执行                             │
│  - 后台服务保活                         │
└────────────────────────────────────────┘
              │
              │ 自动部署
              ▼
┌────────────────────────────────────────┐
│         Termux (Linux 环境)             │
│  ├─ Python 3.12                        │
│  ├─ Node.js LTS                        │
│  ├─ OpenClaw Gateway                   │
│  ├─ Agent Reach                        │
│  └─ 工具链 (gh, yt-dlp, mcporter...)   │
└────────────────────────────────────────┘
```

---

## 📁 项目结构

```
openclaw-mobile/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── providers/                   # 状态管理
│   │   ├── config_provider.dart
│   │   └── session_provider.dart
│   ├── services/                    # 业务逻辑
│   │   ├── termux_deploy_service.dart
│   │   ├── websocket_service.dart
│   │   └── gateway_service.dart
│   ├── screens/                     # 界面
│   │   ├── splash_screen.dart
│   │   ├── onboarding/
│   │   ├── home_screen.dart
│   │   ├── chat_screen.dart
│   │   └── ...
│   └── models/                      # 数据模型
│       └── message.dart
├── termux/
│   ├── install.sh                   # 部署脚本
│   └── README.md
├── android/
│   ├── README.md                    # 原生集成文档
│   └── app/                         # Android 原生代码
├── .github/workflows/
│   └── build.yml                    # CI/CD
├── pubspec.yaml                     # Flutter 依赖
├── README.md                        # 本文件
├── QUICKSTART.md                    # 快速开始指南
└── INSTALL_FLUTTER.md               # Flutter 安装指南
```

---

## 🛠️ 开发

### 环境要求

- Flutter SDK 3.16+
- Dart 3.2+
- Android SDK 26+
- Termux（测试用）

### 配置环境

详见 [INSTALL_FLUTTER.md](INSTALL_FLUTTER.md)

### 运行测试

```bash
flutter pub get
flutter run
flutter test
```

### 构建发布

```bash
# Debug
flutter build apk

# Release
flutter build apk --release

# App Bundle
flutter build appbundle --release
```

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 🙏 致谢

- [OpenClaw](https://github.com/openclaw/openclaw) - AI Agent 框架
- [Termux](https://termux.dev/) - 安卓终端模拟器
- [Flutter](https://flutter.dev/) - 跨平台 UI 框架
- [Agent Reach](https://github.com/Panniantong/agent-reach) - 网络访问工具

---

## 📞 联系方式

- GitHub Issues: 提交 bug 和建议
- 项目主页：https://github.com/your-repo/openclaw-mobile

---

_让 AI Agent 真正随身而行_ 🚀
