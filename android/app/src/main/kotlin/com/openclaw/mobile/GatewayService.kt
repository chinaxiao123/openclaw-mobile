package com.openclaw.mobile

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class GatewayService : Service() {
    companion object {
        private const val NOTIFICATION_ID = 1
        private const val CHANNEL_ID = "gateway_service_channel"
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // 创建前台通知
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, notificationIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("OpenClaw Gateway")
            .setContentText("正在运行中")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()

        startForeground(NOTIFICATION_ID, notification)

        // 启动或监控 Gateway 进程
        startOrMonitorGateway()

        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Gateway 服务",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "保持 OpenClaw Gateway 后台运行"
                setShowBadge(false)
            }

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun startOrMonitorGateway() {
        // 检查 Gateway 是否在运行
        // 如果未运行，通过 Termux API 启动
        // 这里简化处理，实际需要通过 Runtime.exec 或 Termux API 执行命令
        
        Thread {
            try {
                // 检查进程是否存在
                val runtime = Runtime.getRuntime()
                val process = runtime.exec(arrayOf("pgrep", "-f", "openclaw"))
                val exitCode = process.waitFor()
                
                if (exitCode != 0) {
                    // Gateway 未运行，尝试启动
                    // 需要通过 Termux API 或直接执行命令
                    startGatewayInTermux()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }.start()
    }

    private fun startGatewayInTermux() {
        try {
            // 通过 Termux 执行启动命令
            val runtime = Runtime.getRuntime()
            val command = arrayOf(
                "am", "start", "-n", "com.termux/.run.RunScriptActivity",
                "--es", "script", "~/.openclaw/start_gateway.sh"
            )
            runtime.exec(command)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        // 清理资源
    }
}
