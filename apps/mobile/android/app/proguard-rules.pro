# NutriAI Proguard Rules for Release Builds

# Keep data models used with json_serializable / reflection
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Sentry
-keepattributes LineNumberTable,SourceFile
-dontwarn io.sentry.**
