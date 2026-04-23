# <p align="center"> Android / iOS / Web / Desktop App Lifecycle </p>

> **App lifecycle means:** The different states an app goes through from launch to close, and the transitions between those states while the user interacts with the operating system.

An app is not just `open` or `closed`.

**It keeps moving through states like:**
- app starts
- app becomes visible
- app becomes active
- app goes to background
- app comes back to foreground
- app may pause, detach, suspend, or terminate
Firebase-related code behaves differently depending on these states.
---
## <p align="Center"> Flutter sits on top of real platforms </p>

Your Flutter app is one codebase, but it runs inside real operating systems.

**That means Flutter does not invent lifecycle from nothing.**

**Flutter maps lifecycle behavior from:**
- Android lifecycle
- iOS lifecycle
- Web page lifecycle
- Desktop window/application lifecycle

So your Flutter app is cross-platform, but the runtime behavior is still influenced by each platform.

---

## <p align="center"> Platform-By-Platform Lifecycle </p>

### Android lifecycle (activity-based lifecycle)
Android app lifecycle is strongly activity-driven.<br>
An Android screen usually lives inside an `Activity`.<br>
**Common lifecycle movement:**
- app launched
- activity created
- activity started
- activity resumed
- app is active
- user presses home
- activity paused
- activity stopped
- app in background
- app may later resume or be destroyed

> In Flutter, you do not directly manage Android lifecycle most of the time, but Flutter receives lifecycle changes from Android and exposes them in Dart.
---
### iOS lifecycle (app/scene lifecycle)
iOS lifecycle is app-scene based and tightly controlled by the OS.<br>
**Typical behavior:**
- app launches
- app becomes inactive briefly
- app becomes active
- user switches apps
- app enters background
- app may later return to foreground
- app may be suspended or terminated by system

> Flutter abstracts most of this, but iOS is stricter than Android in some background behaviors.

---
### Web lifecycle (page lifecycle)
Flutter web behaves like a web page.<br>
**Typical lifecycle behavior:**
- page loads
- app bootstraps (self-starting process)
- JS runtime starts
- Flutter app initializes
- user refreshes browser
- whole app can rebuild from zero
- tab can become hidden or visible
- browser can suspend work when tab is inactive

**On web:**
- refresh often means fresh app startup
- local persistence behaves differently depending on service
- auth restoration can happen after page reload
- memory-only state disappears on refresh

So Riverpod provider state alone does not survive browser refresh unless backed by persistence.

---
### Desktop lifecycle (window/application lifecycle)
Desktop apps usually behave more like long-running window-based apps.<br>
**Typical behavior:**
- app launches
- main window opens
- user minimizes app
- app may remain running
- user restores app
- user closes window
- process may terminate

> Desktop apps often feel more persistent, but lifecycle events still exist. Window visibility, focus, and close behavior can affect streams, listeners, and app cleanup.

---
## Flutter’s app lifecycle view
Flutter provides a simplified lifecycle abstraction.<br>
**The main lifecycle states you should know are:**
- `resumed` (The app is visible and active, User can interact with it.)
- `inactive` (The app is visible, but not fully interactive for a moment, This often happens during transitions.)
- `hidden` (The app is conceptually hidden from view, This helps unify behavior across platforms)
- `paused` (The app is not visible and is running in background state.)
- `detached` (The Flutter engine is running without being attached to a visible host view.)

---  
