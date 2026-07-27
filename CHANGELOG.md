## 3.0.0 [Breaking Changes]
* Upgraded SmartcarAuth iOS SDK to `6.5.0`.
* Upgraded SmartcarAuth Android SDK to `4.3.1`.
* Android compile SDK version upgraded to `35` (required by the transitive AndroidX dependencies of smartcar-auth `4.3.1`).
* Android: `SmartcarCallback` is now a Kotlin `fun interface` with a nullable `SmartcarResponse?`; the plugin's response handler accepts the nullable type and no-ops on null.
* Added `configurationError`, `noVehicles`, and `serverError` to `SmartcarErrorType` (new iOS SDK error types).
* Android error types now resolve to a `SmartcarErrorType` instead of collapsing to `unknownError`. The Android SDK reports Smartcar Connect's raw `error` code (`access_denied`, `vehicle_incompatible`, `invalid_subscription`, `no_vehicles`, `configuration_error`, `server_error`), where iOS reports a typed error; `SmartcarErrorType.fromRawValue` now accepts both forms.
* Android now reports a `userExitedFlow` failure when the user dismisses Connect (added in smartcar-auth `4.3.1`), matching iOS.
* **BREAKING CHANGE**: `SmartcarConfig.redirectUri` is now optional (`String?` instead of a required `String`). Code that reads `redirectUri` expecting a non-nullable `String` will need to handle `null`.
* **FEAT**: added `SmartcarResponseType` enum (`code` or `none`) and a corresponding `responseType` property on `SmartcarConfig`, defaulting to `code`. When set to `none`, Smartcar Connect completes the flow without a redirect, and `redirectUri` can be omitted.
* **FEAT**: added `externalId` property to `AuthUrlBuilder`, replacing the now-deprecated `user` property.
* **FEAT**: added `userId` and `externalId` properties to `SmartcarAuthSuccess`.
* **FIX**: `SmartcarAuthResponse.fromMap` now determines success/failure by checking for an error `type` instead of a non-null `code`, since `code` is legitimately absent on a successful `responseType: none` flow.

## 2.0.1
* Fixes on iOS .podspec Added missing 'Extensions' folder. **Thanks to sthefannygonzaga@gmail.com**.

## 2.0.0 [Breaking Changes]
* **BREAKING CHANGE**: Android compile SDK version has been upgraded to `34`.
* **BREAKING CHANGE**: iOS minimum version has been upgraded to `13`.
* **BREAKING CHANGE**: Dart minimum SDK version has been upgraded to `>=3.2.0 <4.0.0`.
* **BREAKING CHANGE**: upgraded SmartcarAuth iOS SDK to `6.0.2`.
* **BREAKING CHANGE**: upgraded SmartcarAuth Android SDK to `4.0.1`.
* **BREAKING REFACTOR**: removed `testMode` property from `SmartcarConfig` class.
* **BREAKING REFACTOR**: `SmartcarAuthResponse` is now a **sealed class**.<br>
* **FEAT**: added two new child classes of `SmartcarAuthResponse`
  1. `SmartcarAuthSuccess`: created after a success response from Smartcar Connect.
  2. `SmartcarAuthFailure`: created after a failed response from Smartcar Connect.
* **FEAT**: added `mode` property to `SmartcarConfig` class.
* **FEAT**: added `user` property to `AuthUrlBuilder` class.

## 1.0.6
*  Updated spelling for `controlSecurity` enum. **Thanks to @nick.maiello**.
*  Added new missing permissions in `SmartcarPermission` enum. **Thanks to @nick.maiello**.
*  Updated repository location.

## 1.0.5
*  Updated repository location

## 1.0.4

* Upgraded Android **Smartcar-Auth SDK** to `3.2.0`.
* Upgraded iOS **SmartcarAuth SDK** to `5.3.1`.
* New property `flags` can be set on **AuthUrlBuilder** class.
* New property `virtualKeyUrl` on **SmartcarAuthResponse** class.

## 1.0.3

* Infinite loop fix
* Documentation improvements

## 1.0.2

* Repository information updated

## 1.0.1

* Android fixes & README improvements

## 1.0.0

* Initial release 🚀
