# 修复 Flutter Embedding V2 问题

## 问题
GitHub Actions 报错：`Build failed due to use of deleted Android v1 embedding`

## 解决方案

### 在本地执行以下命令：

```bash
cd C:\Users\web3pc1\.openclaw\workspace\openclaw-mobile

# 1. 完全清理
flutter clean
rm -rf android/.gradle
rm -rf android/app/build
rm -rf build

# 2. 重新获取依赖
flutter pub get

# 3. 重新生成 Android 配置（关键步骤）
flutter create --platforms=android --org com.openclaw .

# 4. 验证 embedding 版本
# 检查 android/app/src/main/kotlin/.../MainActivity.kt
# 应该继承自 io.flutter.embedding.android.FlutterActivity

# 5. 测试构建
flutter build apk --release

# 6. 如果成功，推送代码
git add .
git commit -m "fix: 重新生成 Android Embedding V2 配置"
git push
```

### 验证清单

检查以下文件确保使用 V2：

1. **android/app/src/main/kotlin/.../MainActivity.kt**
   ```kotlin
   import io.flutter.embedding.android.FlutterActivity
   class MainActivity: FlutterActivity()
   ```

2. **android/app/build.gradle**
   ```gradle
   android {
       defaultConfig {
           manifestPlaceholders = [
               flutterEmbedding: '2'
           ]
       }
   }
   ```

3. **pubspec.yaml**
   ```yaml
   flutter:
     uses-material-design: true
   ```

### 如果还是不行

删除整个 android 文件夹重新生成：

```bash
# 备份自定义文件
cp android/app/src/main/AndroidManifest.xml AndroidManifest.xml.backup
cp -r android/app/src/main/kotlin kotlin.backup

# 删除 android 文件夹
rm -rf android

# 重新生成
flutter create --platforms=android --org com.openclaw .

# 恢复自定义文件
# （需要手动合并）
```

---

**执行完后推送到 GitHub，应该就能成功了！**
