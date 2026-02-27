# Flutter 环境安装指南

老板，Flutter 文件比较大（约 600MB），自动下载容易失败。请按以下步骤手动安装：

## 📥 步骤 1：下载 Flutter

访问官方下载页面：
**https://docs.flutter.dev/get-started/install/windows**

或者直接用这个链接（稳定版）：
**https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip**

下载到：`C:\Users\web3pc1\.flutter\flutter.zip`

## 📦 步骤 2：解压

解压到：`C:\Users\web3pc1\.flutter\`

解压后目录结构：
```
C:\Users\web3pc1\.flutter\flutter\
├── bin\
│   └── flutter.bat
├── packages\
└── ...
```

## 🔧 步骤 3：添加环境变量

**PowerShell 执行：**
```powershell
# 添加 Flutter 到 PATH
$flutterPath = "$env:USERPROFILE\.flutter\flutter\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$flutterPath", "User")

# 立即生效（当前会话）
$env:Path = [Environment]::GetEnvironmentVariable("Path","User") + ";" + [Environment]::GetEnvironmentVariable("Path","Machine")
```

## ✅ 步骤 4：验证安装

```powershell
flutter --version
flutter doctor
```

## 📱 步骤 5：安装 Android Studio（可选，用于模拟器）

1. 下载 Android Studio: https://developer.android.com/studio
2. 安装后打开，安装 Android SDK
3. 接受许可证：`flutter doctor --android-licenses`

## 🚀 步骤 6：运行项目

```powershell
cd C:\Users\web3pc1\.openclaw\workspace\openclaw-mobile

# 获取依赖
flutter pub get

# 连接手机后运行
flutter run

# 或构建 APK
flutter build apk --release
```

---

## 💡 快速方案

如果不想装完整的 Flutter 开发环境，可以：

### 方案 A：在线编译
使用 GitHub Actions 自动构建 APK

### 方案 B：找我继续写代码
我先把所有代码写完，您回头再编译

### 方案 C：用现成的构建服务
比如 Codemagic、AppCircle 等 CI/CD 服务

---

**老板，您想咋整？**

1. 您手动安装 Flutter，我继续完善代码
2. 我帮您写 GitHub Actions 配置，自动构建 APK
3. 先不管编译，我把所有代码和文档写完整

*-*
