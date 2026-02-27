## Gradle 配置说明

### 版本要求

| 组件 | 版本 | 说明 |
|------|------|------|
| Gradle | 8.2 | 构建工具 |
| Android Gradle Plugin | 8.2.1 | Android 构建插件 |
| Kotlin | 1.9.20 | Kotlin 版本 |
| Java | 17 | JDK 版本 |
| compileSdk | 34 | Android SDK |
| minSdk | 26 | 最低支持 Android 8.0 |
| targetSdk | 34 | 目标 Android 版本 |

### 配置文件

```
android/
├── gradle/
│   └── wrapper/
│       └── gradle-wrapper.properties    ← Gradle 8.2
├── build.gradle                         ← AGP 8.2.1 + Kotlin 1.9.20
├── settings.gradle                      ← 插件配置
└── app/
    └── build.gradle                     ← 应用配置
```

### 兼容性

- ✅ Gradle 8.2 + AGP 8.2.1
- ✅ Java 17
- ✅ Kotlin 1.9.20
- ✅ Flutter 3.24+

### 本地构建

```bash
# Windows
cd android
gradlew.bat build

# macOS/Linux
cd android
./gradlew build
```

### GitHub Actions

自动使用 Gradle 8.2，无需本地配置。
