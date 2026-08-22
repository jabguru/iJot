// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "cloud_firestore", path: "../.packages/cloud_firestore-6.1.2"),
        .package(name: "device_info_plus", path: "../.packages/device_info_plus-12.3.0"),
        .package(name: "file_picker", path: "../.packages/file_picker-10.3.10"),
        .package(name: "firebase_auth", path: "../.packages/firebase_auth-6.4.0"),
        .package(name: "firebase_core", path: "../.packages/firebase_core-4.7.0"),
        .package(name: "firebase_crashlytics", path: "../.packages/firebase_crashlytics-5.2.0"),
        .package(name: "firebase_storage", path: "../.packages/firebase_storage-13.3.0"),
        .package(name: "flutter_keyboard_visibility_temp_fork", path: "../.packages/flutter_keyboard_visibility_temp_fork-0.1.5"),
        .package(name: "google_sign_in_ios", path: "../.packages/google_sign_in_ios-6.2.5"),
        .package(name: "image_picker_ios", path: "../.packages/image_picker_ios-0.8.13+5"),
        .package(name: "integration_test", path: "../.packages/integration_test"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus-8.3.1"),
        .package(name: "path_provider_foundation", path: "../.packages/path_provider_foundation-2.5.1"),
        .package(name: "quill_native_bridge_ios", path: "../.packages/quill_native_bridge_ios-0.0.1"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "url_launcher_ios", path: "../.packages/url_launcher_ios-6.3.6"),
        .package(name: "video_player_avfoundation", path: "../.packages/video_player_avfoundation-2.9.0"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "cloud-firestore", package: "cloud_firestore"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "file-picker", package: "file_picker"),
                .product(name: "firebase-auth", package: "firebase_auth"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "firebase-crashlytics", package: "firebase_crashlytics"),
                .product(name: "firebase-storage", package: "firebase_storage"),
                .product(name: "flutter-keyboard-visibility-temp-fork", package: "flutter_keyboard_visibility_temp_fork"),
                .product(name: "google-sign-in-ios", package: "google_sign_in_ios"),
                .product(name: "image-picker-ios", package: "image_picker_ios"),
                .product(name: "integration-test", package: "integration_test"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "path-provider-foundation", package: "path_provider_foundation"),
                .product(name: "quill-native-bridge-ios", package: "quill_native_bridge_ios"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "video-player-avfoundation", package: "video_player_avfoundation"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
