plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

// --- Apply Google Services plugin theo Kotlin DSL ---
apply(plugin = "com.google.gms.google-services")

android {
    // Namespace quan trọng để fix lỗi AGP 8.x
    namespace = "com.example.iot_thi"

    compileSdk = 33

    defaultConfig {
        applicationId = "com.example.iot_thi"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    // Kotlin & AndroidX
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.8.22")
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.10.0")
    implementation("androidx.constraintlayout:constraintlayout:2.2.0")

    // Flutter embedding
    implementation("io.flutter:flutter_embedding_debug:1.0.0")

    // Desugaring Java 8 cho flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
