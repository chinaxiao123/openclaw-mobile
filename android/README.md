# Android 原生集成 - Termux API

## 概述

为了让 Flutter APP 与 Termux 交互，需要原生代码支持。

## 需要的权限

在 `AndroidManifest.xml` 中添加：

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />
```

## Platform Channel 实现

### MainActivity.kt

```kotlin
package com.openclaw.mobile

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.openclaw.mobile/termux"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "isTermuxInstalled" -> {
                    val isInstalled = isPackageInstalled("com.termux")
                    result.success(isInstalled)
                }
                "openTermux" -> {
                    openTermux()
                    result.success(true)
                }
                "installTermux" -> {
                    openPlayStore("com.termux")
                    result.success(true)
                }
                "executeInTermux" -> {
                    val script = call.argument<String>("script") ?: ""
                    executeScript(script, result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun isPackageInstalled(packageName: String): Boolean {
        return try {
            packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun openTermux() {
        val intent = packageManager.getLaunchIntentForPackage("com.termux")
        if (intent != null) {
            startActivity(intent)
        }
    }

    private fun openPlayStore(packageName: String) {
        try {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$packageName")))
        } catch (e: Exception) {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=$packageName")))
        }
    }

    private fun executeScript(script: String, result: MethodChannel.Result) {
        // 通过 Termux:API 执行脚本
        // 需要安装 Termux:API 插件
        
        try {
            // 方式 1: 使用 Termux:API 的 termux-exec
            val intent = Intent("com.termux.api.execute")
            intent.setPackage("com.termux")
            intent.putExtra("script", script)
            intent.putExtra("receiver_class", "com.openclaw.mobile.TermuxResultReceiver")
            startActivity(intent)
            
            // 注意：实际执行是异步的，需要通过 BroadcastReceiver 接收结果
            result.success(mapOf("status" to "executing"))
        } catch (e: Exception) {
            result.error("EXECUTION_ERROR", e.message, null)
        }
    }
}
```

## Flutter 端调用

```dart
import 'package:flutter/services.dart';

class TermuxApi {
  static const platform = MethodChannel('com.openclaw.mobile/termux');

  static Future<bool> isTermuxInstalled() async {
    try {
      final result = await platform.invokeMethod('isTermuxInstalled');
      return result as bool;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> openTermux() async {
    await platform.invokeMethod('openTermux');
  }

  static Future<void> installTermux() async {
    await platform.invokeMethod('installTermux');
  }

  static Future<Map<String, dynamic>> executeScript(String script) async {
    final result = await platform.invokeMethod('executeInTermux', {'script': script});
    return Map<String, dynamic>.from(result);
  }
}
```

## 后台服务保活

### 创建前台服务

```kotlin
class GatewayService : Service() {
    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = NotificationCompat.Builder(this, "gateway_channel")
            .setContentTitle("OpenClaw Gateway")
            .setContentText("正在运行")
            .setSmallIcon(R.drawable.ic_notification)
            .setOngoing(true)
            .build()

        startForeground(1, notification)
        
        // 启动或监控 Gateway 进程
        startGateway()
        
        return START_STICKY
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            "gateway_channel",
            "Gateway 服务",
            NotificationManager.IMPORTANCE_LOW
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    private fun startGateway() {
        // 执行 Termux 命令启动 Gateway
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
```

## 电池优化白名单

请求用户忽略电池优化：

```kotlin
fun requestBatteryOptimizationExemption(context: Context) {
    val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
    if (!powerManager.isIgnoringBatteryOptimizations(context.packageName)) {
        val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
        intent.data = Uri.parse("package:${context.packageName}")
        context.startActivity(intent)
    }
}
```

## 构建配置

### build.gradle (app)

```gradle
android {
    defaultConfig {
        applicationId "com.openclaw.mobile"
        minSdkVersion 26
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.0"
    implementation 'androidx.core:core-ktx:1.12.0'
    // ... 其他依赖
}
```

## 打包发布

```bash
# 构建 Release APK
flutter build apk --release

# 构建 App Bundle (Google Play)
flutter build appbundle --release

# APK 输出位置
# build/app/outputs/flutter-apk/app-release.apk
```
