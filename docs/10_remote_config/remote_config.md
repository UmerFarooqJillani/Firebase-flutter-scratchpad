# <p align="center"> Firebase Remote Config for Flutter </p>

## What is Firebase Remote Config?
Remote Config allows you to change the behavior and appearance of your app **without publishing a new version**. You define parameters in Firebase, fetch them in the app, and use them to control features, text, colors, etc.

**Example:**
- You want to show a promotional banner only during a sale.
- Instead of releasing a new app update, you can toggle a show_banner parameter from Firebase Remote Config.

> Dynamic updates without requiring user to install a new app.

## Why it's important
- Dynamic UI/feature updates
- Feature toggles
- A/B testing

**Example**
- show_banner = true/false
- app_color_theme = "red"/"blue"

## Implement step by step
1. **Add dependency**
    ```bash
    # Also make sure firebase_core is added and initialized.
    flutter pub add firebase_remote_config
    ```
2. **Create Remote Config service**
    ```dart
    // lib\services\firebase\remote_config_service.dart

    ```
3. Riverpod Provider
    ```dart
    // lib\features\remote_config\application\provider.dart

    ```
4. UI Screen
    ```dart
    // lib\features\remote_config\presentation\remote_config_demo_screen.dart

    ```
--- 