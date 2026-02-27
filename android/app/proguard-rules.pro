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
