# 📱 OpenClaw Mobile 部署指南

完整部署流程，从代码到 APK。

---

## 🎯 部署目标

构建一个完整的安卓 APK，用户安装后可以：
1. 自动检测/安装 Termux
2. 一键部署 OpenClaw Gateway 到 Termux
3. 内嵌聊天界面，直接使用

---

## 📋 前置条件

### 方案 A：本地编译（需要 Flutter 环境）

**系统要求：**
- Windows 10/11 或 macOS 或 Linux
- 至少 4GB 可用内存
- 至少 2GB 磁盘空间

**软件要求：**
- Flutter SDK 3.16+ 
- Java JDK 17+
- Android SDK 26+

### 方案 B：GitHub Actions（推荐⚡）

**只需要：**
- GitHub 账号
- 代码推送到仓库

---

## 🚀 方案 A：本地编译

### 步骤 1：安装 Flutter

**Windows:**
```powershell
# 1. 下载 Flutter
# https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip

# 2. 解压到 C:\Users\你的用户名\.flutter\

# 3. 添加环境变量
$flutterPath = "$env:USERPROFILE\.flutter\flutter\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$flutterPath", "User")

# 4. 验证
flutter --version
```

**macOS:**
```bash
brew install --cask flutter
```

**Linux:**
```bash
# 下载并解压
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
tar xf flutter_linux_3.24.5-stable.tar.xz

# 添加到 PATH
export PATH="$PATH:$HOME/flutter/bin"
# 添加到 ~/.bashrc 或 ~/.zshrc 永久生效
```

### 步骤 2：安装 Android Studio（可选，用于模拟器）

1. 下载：https://developer.android.com/studio
2. 安装后打开，安装 Android SDK
3. 接受许可证：
```bash
flutter doctor --android-licenses
```

### 步骤 3：克隆项目

```bash
git clone https://github.com/你的用户名/openclaw-mobile.git
cd openclaw-mobile
```

### 步骤 4：获取依赖

```bash
flutter pub get
```

### 步骤 5：构建 APK

```bash
# Debug 版本（用于测试）
flutter build apk

# Release 版本（用于发布）
flutter build apk --release

# 输出位置
# build/app/outputs/flutter-apk/app-release.apk
```

### 步骤 6：安装到手机

```bash
# 连接手机后
flutter install

# 或手动传输 APK 到手机安装
```

---

## ☁️ 方案 B：GitHub Actions 自动构建

### 步骤 1：创建 GitHub 仓库

1. 登录 GitHub
2. 创建新仓库 `openclaw-mobile`
3. 设为公开或私有均可

### 步骤 2：推送代码

```bash
cd openclaw-mobile

# 初始化 Git
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: OpenClaw Mobile"

# 关联远程仓库
git branch -M main
git remote add origin https://github.com/你的用户名/openclaw-mobile.git

# 推送
git push -u origin main
```

### 步骤 3：触发自动构建

推送后 GitHub Actions 会自动开始构建：

1. 进入仓库页面
2. 点击 **Actions** 标签
3. 查看构建进度
4. 构建完成后下载 APK（Artifacts）

### 步骤 4：下载 APK

1. 在 Actions 页面点击最新的构建
2. 在底部找到 **Artifacts**
3. 点击 `openclaw-mobile-apk` 下载
4. 解压后得到 `app-release.apk`

### 步骤 5：发布版本（可选）

```bash
# 创建标签
git tag v1.0.0
git push origin v1.0.0
```

Actions 会自动创建 GitHub Release 并上传 APK。

---

## 📱 测试和验证

### 在真机上测试

1. **开启开发者选项**
   - 设置 → 关于手机 → 连续点击"版本号"7 次
   
2. **开启 USB 调试**
   - 设置 → 开发者选项 → USB 调试

3. **连接电脑**
   ```bash
   flutter devices
   ```

4. **运行应用**
   ```bash
   flutter run
   ```

### 测试部署流程

1. 安装 APP
2. 选择"本地部署"
3. 按照向导完成 Termux 安装
4. 等待自动部署（约 3-5 分钟）
5. 测试聊天功能

---

## 🔧 常见问题

### Q: 构建失败，提示 Java 版本问题？
```bash
# 检查 Java 版本
java -version

# 需要 Java 17+
# 下载：https://adoptium.net/
```

### Q: Android SDK 找不到？
```bash
# 设置 ANDROID_HOME
# Windows:
setx ANDROID_HOME "C:\Users\你的用户名\AppData\Local\Android\Sdk"

# macOS/Linux:
export ANDROID_HOME="$HOME/Android/Sdk"
```

### Q: 构建太慢？
```bash
# 使用国内镜像
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### Q: APK 太大？
- 正常，Flutter APP 约 20-30MB
- 可以使用 App Bundle 减小体积
```bash
flutter build appbundle --release
```

---

## 📦 发布到应用商店（可选）

### Google Play

1. 构建 App Bundle：
```bash
flutter build appbundle --release
```

2. 输出位置：`build/app/outputs/bundle/release/app-release.aab`

3. 上传到 Google Play Console

### 其他商店

直接上传 APK 即可。

---

## 📊 构建时间参考

| 方式 | 首次构建 | 后续构建 |
|------|----------|----------|
| 本地（ Release） | 5-10 分钟 | 2-3 分钟 |
| GitHub Actions | 10-15 分钟 | 8-10 分钟 |

---

## ✅ 完成检查清单

- [ ] Flutter 环境安装完成
- [ ] 代码获取依赖成功
- [ ] 构建 APK 无错误
- [ ] APK 安装到手机成功
- [ ] Termux 检测功能正常
- [ ] 部署流程测试通过
- [ ] 聊天功能测试通过
- [ ] 后台服务保活测试通过

---

_部署成功，开始使用！_ 🚀
