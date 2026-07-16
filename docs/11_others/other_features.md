## A/B Testing
- **What:** Experimenting with different app variations to see which performs better.
- **How:** Use Remote Config parameters and Firebase A/B Testing dashboard to define experiment groups.
- **Why:** Improves features, UI, and user engagement based on real data.
- **Example:** Test two different CTA button colors to see which one leads to more clicks.

## App Distribution
- **What:** Distribute pre-release builds to testers.
- **How:** Upload APK/IPA to Firebase App Distribution and invite testers via email.
- **Why:** Collect feedback and catch bugs before public release.
- **Example:** Send a beta Android build to 10 testers to validate a new login flow.

## Google Analytics
- **What:** Tracks user behavior and events in your app.
- **How:** Integrate `firebase_analytics` SDK and log events.
- **Why:** Understand user engagement, retention, and app usage.
- **Example:** Track a “purchase_completed” event when a user buys a product.

## In-App Messaging
- **What:** Send contextual messages to users while they use the app.
- **How:** Configure messages in Firebase console and target user segments.
- **Why:** Drive engagement or alert users without push notifications.
- **Example:** Show a “Complete your profile!” message when a user opens the app.

## Performance Monitoring
- **What:** Monitors app performance, startup time, network latency, and errors.
- **How:** Integrate `firebase_performance` SDK; view metrics in Firebase console.
- **Why:** Identify slow or buggy parts of the app to improve UX.
- **Example:** Detect that a Firestore query takes 3 seconds, optimize it to 0.5s.

## Test Lab
- **What:** Cloud-based device testing for Android/iOS apps.
- **How:** Run automated tests on virtual and real devices via Firebase console.
- **Why:** Ensures app works across multiple devices and OS versions.
- **Example:** Run integration tests on 20 different Android devices to check UI consistency.

## App Check
- **What:** Protects backend resources from unauthorized access.
- **How:** Integrate `firebase_app_check` SDK; uses device attestation to verify requests.
- **Why:** Prevents abuse and protects Firestore, Storage, and Functions.
- **Example:** Only allow requests from your legitimate mobile app to write to Firestore.

## App Hosting
- **What:** Host static web apps with SSL, CDN, and global distribution.
- **How:** Use `firebase hosting` CLI to deploy your web app.
- **Why:** Fast, secure, and globally distributed hosting for web projects.
- **Example:** Deploy a Flutter Web app and share `https://your-app.web.app`.

## Cloud Functions
- **What:** Run backend code in response to events or HTTP requests.
- **How:** Write JavaScript/TypeScript functions and deploy via Firebase Functions CLI.
- **Why:** Handle server logic without maintaining a server.
- **Example:** Send a welcome email automatically when a new user signs up.

## Data Connect
- **What:** Sync Firebase with external databases or APIs.
- **How:** Use Cloud Functions or Firebase Extensions to connect services.
- **Why:** Integrate Firebase apps with third-party systems.
- **Example:** Automatically push new Firestore documents to BigQuery.

## Extensions
- **What:** Pre-packaged solutions for common backend tasks.
- **How:** Install via Firebase console (e.g., resizing images, sending emails).
- **Why:** Saves development time and reduces custom code.
- **Example:** Use the “Resize Images” extension to automatically create thumbnails in Storage.

## Firebase ML
- **What:** Machine Learning features for mobile apps.
- **How:** Use Firebase ML SDKs or custom models via Firebase console.
- **Why:** Add image labeling, text recognition, or custom ML predictions.
- **Example:** Detect text in photos uploaded by users for OCR features.

## Genkit
- **What:** Firebase-generated tools/plugins for rapid feature integration.
- **How:** Integrated via Firebase client SDKs.
- **Why:** Helps scaffold or quickly generate Firebase-supported features.
- **Example:** Auto-generate boilerplate for Firestore CRUD operations.

## Hosting (Web)
- **What:** Serve static content (HTML, CSS, JS) with SSL and CDN.
- **How:** Deploy via `firebase hosting`.
- **Why:** Fast and secure delivery of web content.
- **Example:** Host a marketing page or Flutter Web app.

## Firebase AI Logic Client SDKs
- **What:** Client-side ML & logic SDKs for real-time inference or rules evaluation.
- **How:** Integrate Firebase SDKs in Flutter to run logic on the device.
- **Why:** Run lightweight predictions or logic without cloud round trips.
- **Example:** Auto-suggest product recommendations based on user behavior.

--- 