# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }

# Flutter Play Store Split (可选功能，不需要时忽略警告)
-dontwarn io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager
-dontwarn io.flutter.app.FlutterPlayStoreSplitApplication
-dontwarn com.google.android.play.core.**

# Keep Termux related classes
-keep class com.termux.** { *; }

# Keep web socket
-keep class org.java_websocket.** { *; }

# Keep http client
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-keep class okio.** { *; }

# Keep provider
-keep class androidx.lifecycle.** { *; }

# Keep Kotlin
-keep class kotlin.** { *; }
-keep class org.jetbrains.** { *; }

# Keep models
-keep class com.openclaw.mobile.models.** { *; }
