# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# just_audio
-keep class com.google.android.exoplayer2.** { *; }
-keep class com.just_audio.** { *; }

# record (mikrofon)
-keep class com.llfbandit.record.** { *; }

# Google Fonts
-keep class com.google.android.gms.** { *; }

# SharedPreferences
-keep class androidx.datastore.** { *; }

# Genel Android kurallar
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# R8 full mode uyumlulugu
-dontwarn java.lang.invoke.StringConcatFactory
