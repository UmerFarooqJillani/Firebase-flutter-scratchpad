# <p align="center"> Phone-OTP Auth </p>

## What Phone Auth is
**Phone Authentication = user proves they own a phone number via OTP (SMS code).**
> User enters phone → Firebase sends OTP → user enters OTP → Firebase signs user in

## Platforms: how it behaves
### Android
- Can auto-verify (no OTP input) using Play Services
- Or manual OTP if auto fails
### iOS
- Usually manual OTP
- iOS may suggest OTP from SMS (auto-fill), - but still user taps
### Web
- Requires reCAPTCHA (bot protection)
- Always manual OTP

## Flow (under the hood)
```
App → FirebaseAuth.verifyPhoneNumber()
    → Firebase backend sends SMS
    → returns verificationId
User enters OTP
    → create PhoneAuthCredential
    → Firebase verifies code
    → user signed in
```

## Service layer (single source of truth)
```dart
// lib/core/auth/firebase_auth_service.dart
File contain these methods:
- Verify Phone Number
- SignIn With Otp
```

## Riverpod State
```dart
// lib\features\authentication\phone_otp_auth\application\phone_auth_state.dart
contain methods:
- Phone Auth State  // For web and Android Phone
```

## Controller (ViewModel)
```dart
// \lib\features\authentication\phone_otp_auth\application\phone_auth_controller.dart
contain methods:
- Phone Auth Controller Provider
- SEND OTP
- Verify OTP
```

## Application Layer (UI)
```dart
// lib\features\authentication\phone_otp_auth\presentation\
Two screens:
- Phone Login Screen
- OTP Verification Screen
```

<p align="center"> On Android, the OTP Note received via <b>SMS delivery/verification is failing or being delayed</b>. Please review this later and proceed to the next task now. </p>

--- 

## Web implementation (special case)
### Main difference: Android/iOS vs Web
- Android/iOS use: `verifyPhoneNumber(...)`
- Web use: Firebase’s Flutter docs specifically separate web phone authentication using `signInWithPhoneNumber(...)`

### Web phone auth flow
User enters phone number
- reCAPTCHA appears
- user passes reCAPTCHA
- Firebase sends OTP
- app stores ConfirmationResult
- user enters OTP
- confirmationResult.confirm(code)
- user logged in

### reCAPTCHA ?? 
reCAPTCHA is a protection system that checks whether the request is likely from a real human, not a bot.

**Why Firebase needs it on web:**
- web apps are easier to automate
- SMS OTP costs money
- attackers can abuse phone verification
- reCAPTCHA reduces fake OTP requests


### **Step 1:** Enable Phone Auth in Firebase Console
Go to:
```
Firebase Console
→ Authentication
→ Sign-in method
→ Phone
→ Enable
```
Also check:
```
Firebase Console
→ Authentication
→ Settings
→ Authorized domains
```
For local testing, usually this should include:
```
localhost
```
For production, add your real domain.

### **Step 2:** Create Web Specific service methods
```dart
// lib\core\auth\firebase_auth_service.dart
File contain methodes:
- Send OTP Web
- Confirm OTP Web
```

#### What this code does
##### `sendOtpWeb()`

This sends OTP on web.

Internally: `_auth.signInWithPhoneNumber(phoneNumber, verifier)`

**Does two things:**
1. Verifies reCAPTCHA
2. Sends SMS if reCAPTCHA passes

Firebase’s web phone-auth documentation confirms this order.

##### `ConfirmationResult`
This is very important.

On web, Firebase does not give you only a `verificationId` like mobile.

It gives you: `ConfirmationResult`

You must keep this object until the user enters OTP.

Then you call: `confirmationResult.confirm(code)`

### **Step 3:** Create the reCAPTCHA verifier
In Flutter Web, you can create:
```dart
final verifier = RecaptchaVerifier(
  auth: FirebaseAuth.instance,
  size: RecaptchaVerifierSize.normal,
);
```
Then pass it:
```dart
await FirebaseAuth.instance.signInWithPhoneNumber(
  phoneNumber,
  verifier,
);
```
#### Visible vs invisible reCAPTCHA
##### Option A (Visible reCAPTCHA)
User sees a box/challenge.
```dart
final verifier = RecaptchaVerifier(
  auth: FirebaseAuth.instance,
  size: RecaptchaVerifierSize.normal,
);
```
Beginner recommendation: **use visible reCAPTCHA first**.

**Why:**
- easier to debug
- clear what is happening
- less confusing when OTP does not send

##### Option B (Invisible reCAPTCHA)
User may not see a box unless suspicious activity is detected.
```dart
final verifier = RecaptchaVerifier(
  auth: FirebaseAuth.instance,
  size: RecaptchaVerifierSize.invisible,
);
```
Production apps often prefer invisible reCAPTCHA for better UX, but beginners should start visible.

## Key point
Because you added a **test phone number**, you should not receive a **real OTP SMS**.

That is expected behavior.

**Key point**

*Firebase test numbers work like this:*<br>
You enter test phone number
- Firebase does NOT send SMS
- You manually enter the fixed OTP code you saved in Firebase Console

Firebase test phone numbers are specifically for testing without sending real SMS or consuming quota. Firebase docs describe adding phone numbers and verification codes for development testing.

### Most likely reasons OTP was not received
1. SMS region policy not enabled (Firebase Console>Authentication>Settings>SMS region policy)
2. Phone number format is wrong (+923001234567)
3. You are testing too many times (Firebase can throttle OTP attempts.)
4. SMS quota or billing issue
5. Authorized domain issue

--- 

## Production-level checklist

Before real OTP in production:

- Phone provider enabled
- SMS region policy allows target country
- Authorized domain added for web
- Phone number in E.164 format
- App Check added later
- Test numbers used during development
- Error messages mapped properly
- Resend timer added
- Attempt limit added in UI

--- 

## iOS notes
- Must enable phone auth in Firebase console
- Add real device for testing
- OTP auto-fill suggestion works via iOS keyboard

## Android notes
- Add SHA-1 in Firebase Console
- Supports auto-verification
- Use real device for best testing

--- 