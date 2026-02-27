package com.openclaw.mobile

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.ResultReceiver
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileWriter

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.openclaw.mobile/termux"
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "isTermuxInstalled" -> {
                    val isInstalled = isPackageInstalled("com.termux")
                    result.success(isInstalled)
                }
                "isTermuxApiInstalled" -> {
                    val isInstalled = isPackageInstalled("com.termux.api")
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
                "installTermuxApi" -> {
                    openPlayStore("com.termux.api")
                    result.success(true)
                }
                "executeInTermux" -> {
                    val script = call.argument<String>("script") ?: ""
                    val sessionId = call.argument<String>("sessionId") ?: System.currentTimeMillis().toString()
                    executeScript(script, sessionId, result)
                }
                "requestBatteryOptimizationExemption" -> {
                    requestBatteryOptimizationExemption()
                    result.success(true)
                }
                "isIgnoringBatteryOptimizations" -> {
                    val isIgnoring = isIgnoringBatteryOptimizations()
                    result.success(isIgnoring)
                }
                "startForegroundService" -> {
                    startGatewayService()
                    result.success(true)
                }
                "stopForegroundService" -> {
                    stopGatewayService()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * 检查包是否已安装
     */
    private fun isPackageInstalled(packageName: String): Boolean {
        return try {
            packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    /**
     * 打开 Termux
     */
    private fun openTermux() {
        val intent = packageManager.getLaunchIntentForPackage("com.termux")
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
    }

    /**
     * 打开应用商店安装应用
     */
    private fun openPlayStore(packageName: String) {
        try {
            // 尝试打开 Google Play
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$packageName")))
        } catch (e: Exception) {
            // 降级到浏览器
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=$packageName")))
        }
    }

    /**
     * 在 Termux 中执行脚本
     */
    private fun executeScript(script: String, sessionId: String, result: MethodChannel.Result) {
        try {
            // 方式 1: 使用 Termux:API 的 termux-exec
            // 需要先安装 Termux:API 插件
            
            val intent = Intent("com.termux.api.execute")
            intent.setPackage("com.termux")
            intent.putExtra("script", script)
            intent.putExtra("receiver_class", "com.openclaw.mobile.TermuxResultReceiver")
            intent.putExtra("session_id", sessionId)
            
            // 检查 Termux 是否已安装
            if (!isPackageInstalled("com.termux")) {
                result.error("TERMUX_NOT_INSTALLED", "Termux 未安装", null)
                return
            }
            
            startActivity(intent)
            
            // 返回执行状态（实际结果通过 BroadcastReceiver 接收）
            result.success(mapOf(
                "status" to "executing",
                "session_id" to sessionId
            ))
        } catch (e: Exception) {
            result.error("EXECUTION_ERROR", e.message, null)
        }
    }

    /**
     * 请求电池优化白名单
     */
    private fun requestBatteryOptimizationExemption() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
            intent.data = Uri.parse("package:$packageName")
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
    }

    /**
     * 检查是否已忽略电池优化
     */
    private fun isIgnoringBatteryOptimizations(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val powerManager = getSystemService(POWER_SERVICE) as android.os.PowerManager
            return powerManager.isIgnoringBatteryOptimizations(packageName)
        }
        return false
    }

    /**
     * 启动前台服务
     */
    private fun startGatewayService() {
        val intent = Intent(this, GatewayService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    /**
     * 停止前台服务
     */
    private fun stopGatewayService() {
        val intent = Intent(this, GatewayService::class.java)
        stopService(intent)
    }
}

/**
 * Termux 执行结果接收器
 */
class TermuxResultReceiver : ResultReceiver(Handler(Looper.getMainLooper())) {
    companion object {
        var onResultReceived: ((Bundle?) -> Unit)? = null
    }

    override fun onReceiveResult(resultCode: Int, resultData: Bundle?) {
        onResultReceived?.invoke(resultData)
    }
}
