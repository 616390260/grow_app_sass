import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 从环境变量或安全配置文件读取签名信息
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("android/keystore.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "com.example.dotask.do_task_project"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.dotask.do_task_project"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 若存在 android/app/key.jks 则用正式 release 签名；否则沿用 debug 签名（与之前「缺密钥也能打 release APK」一致）。
    val releaseKeystore = file("key.jks")
    signingConfigs {
        if (releaseKeystore.exists()) {
            create("release") {
                keyAlias = "key"
                keyPassword = "android123"
                storeFile = releaseKeystore
                storePassword = "android123"
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (releaseKeystore.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            // 启用代码压缩
            // isMinifyEnabled = true
            // 启用资源压缩
            // isShrinkResources = true
            // 移除未使用的资源
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
             ndk {
                 abiFilters.add("arm64-v8a")
             }
        }
    }
}

flutter {
    source = "../.."
}
