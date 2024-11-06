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
