plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.my_webview_app"
    compileSdk = flutter.compileSdkVersion
    
    // NDK ভার্সন আপডেট করা হয়েছে
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.my_webview_app"
        minSdk = 23 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ফ্র্যাগমেন্ট ডিপেন্ডেন্সি যোগ করা হয়েছে বায়োমেট্রিকের জন্য
dependencies {
    implementation("androidx.fragment:fragment:1.5.0")
}