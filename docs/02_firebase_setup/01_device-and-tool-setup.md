# <p align="center"> Device And Tool Setup </p>

## PART A — Required tools (Device Setup)
1. **Flutter**
    - Check: `flutter doctor`
2. **Node.js + npm**
    - Check:
        ```bash
        # Firebase CLI depends on Node.
        node --version
        npm --version
        ```
3. **Firebase CLI**
    - Install: `npm install -g firebase-tools`
    - Login:
        ```bash
        # This connects your local machine to your Firebase account.
        firebase login
        # firebase logout
        ```
4. **FlutterFire CLI**
    - Install:
        ```bash
        dart pub global activate flutterfire_cli
        ```
    - Check: `flutterfire --version`
    - If not working:
        - Add this to PATH: `C:\Users\YOUR_USER\AppData\Local\Pub\Cache\bin`
            1. Copy this exactly: `C:\Users\HP 840 G3\AppData\Local\Pub\Cache\bin`
            2. Open Environment Variables
            3. Open Environment Variables panel
            4. Find PATH - In User variables (top section): Select it
            5. Click: Edit
            6. Add new path - Click: New
            7. Paste your path: `C:\Users\HP 840 G3\AppData\Local\Pub\Cache\bin`
            8. OK. (Restart terminal)
--- 