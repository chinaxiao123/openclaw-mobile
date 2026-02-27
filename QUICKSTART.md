# 🚀 OpenClaw Mobile - 快速开始

## 项目概述

OpenClaw 安卓客户端，让用户在手机上本地部署 OpenClaw Gateway，实现真正的随身 AI 助手。

**核心特性：**
- 📱 一键部署到 Termux
- 🔧 向导式配置
- 💬 实时聊天对话
- 📊 Agent 状态监控
- 🔒 本地运行，隐私安全

---

## 📦 部署方式

### 方式 1：本地部署（推荐）

APP 自动在手机上安装 Termux 并部署 OpenClaw Gateway。

**优点：**
- ✅ 数据不出手机
- ✅ 无需外部服务器
- ✅ 完全免费

**缺点：**
- ⚠️ 手机需要保持运行
- ⚠️ 耗电稍高

### 方式 2：远程配置

连接已有的 OpenClaw Gateway（电脑/服务器）。

**优点：**
- ✅ 手机省电
- ✅ 性能更好

**缺点：**
- ⚠️ 需要外网可达的服务器

---

## 🛠️ 开发环境搭建

### 1. 安装 Flutter

**Windows:**
```powershell
# 下载 Flutter
# https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip

# 解压到 C:\Users\你的用户名\.flutter\

# 添加环境变量
$flutterPath = "$env:USERPROFILE\.flutter\flutter\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$flutterPath", "User")
```

**验证安装:**
```bash
flutter --version
flutter doctor
```

### 2. 安装 Android Studio（可选）

用于安卓模拟器和 SDK：
1. 下载：https://developer.android.com/studio
2. 安装后配置 Android SDK
3. 接受许可证：`flutter doctor --android-licenses`

### 3. 获取项目依赖

```bash
cd openclaw-mobile
flutter pub get
```

---

## 📱 运行和测试

### 连接设备

**方式 1：真机**
1. 手机开启开发者选项
2. 开启 USB 调试
3. 连接电脑
4. `flutter devices` 查看设备

**方式 2：模拟器**
1. Android Studio 启动模拟器
2. `flutter devices` 查看

### 运行应用

```bash
# 开发模式运行
flutter run

# 热重载：按 r
# 热重启：按 R
# 退出：按 q
```

### 构建 APK

```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# 输出位置
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 🤖 自动构建（GitHub Actions）

项目已配置 GitHub Actions，推送到 main 分支自动构建 APK。

**启用自动构建：**
1. 创建 GitHub 仓库
2. 推送代码
3. 在 Actions 中查看构建进度
4. 下载 APK（Artifacts）

**发布新版本：**
```bash
git tag v1.0.0
git push origin v1.0.0
```

自动创建 GitHub Release 并上传 APK。

---

## 📂 项目结构

```
openclaw-mobile/
├── lib/
│   ├── main.dart                    # 入口
│   ├── providers/                   # 状态管理
│   ├── services/                    # 业务逻辑
│   ├── screens/                     # 界面
│   └── models/                      # 数据模型
├── termux/
│   └── install.sh                   # Termux 部署脚本
├── .github/workflows/
│   └── build.yml                    # CI/CD 配置
├── pubspec.yaml                     # 依赖配置
└── README.md                        # 说明文档
```

---

## 🔧 核心功能实现

### 1. Termux 自动部署

流程：
```
APP → 检测 Termux → 推送脚本 → 执行安装 → 启动服务 → 返回连接信息
```

关键文件：
- `lib/services/termux_deploy_service.dart` - 部署逻辑
- `termux/install.sh` - 安装脚本
- `android/README.md` - 原生集成

### 2. WebSocket 连接

```dart
final service = WebSocketService();
await service.connect(
  host: '127.0.0.1',
  port: 18789,
  token: 'your-token',
);
```

### 3. 状态管理

使用 Provider 模式：
- `ConfigProvider` - 配置管理
- `SessionProvider` - 会话管理
- `TermuxDeployService` - 部署服务
- `WebSocketService` - 连接服务

---

## 🐛 常见问题

### Q: Termux 安装失败？
A: 检查网络连接，或手动在 F-Droid 下载 Termux。

### Q: 部署脚本报错？
A: 在 Termux 中手动运行脚本查看详细错误：
```bash
curl -fsSL https://your-url/install.sh | bash
```

### Q: 后台被杀？
A: 在手机设置中给 APP 和 Termux 添加电池优化白名单。

### Q: WebSocket 连不上？
A: 检查 Gateway 是否运行，防火墙是否开放端口。

---

## 📄 下一步

1. **完善原生代码** - 实现 Platform Channel 调用 Termux
2. **测试部署流程** - 真机测试完整部署
3. **优化 UI/UX** - 根据反馈调整界面
4. **添加更多功能** - 文件管理、插件系统等

---

## 📞 反馈和支持

- GitHub Issues: 提交 bug 和建议
- 文档：查看项目根目录的文档

---

_让 AI Agent 真正随身而行_
