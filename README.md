# flutter_smartcar_auth

A Flutter plugin for [Smartcar Connect](https://smartcar.com/docs/).

This plugin integrates the native SDKs:

- [Smartcar Auth iOS SDK](https://smartcar.com/docs/tutorials/ios/introduction/)
- [Smartcar Auth Android SDK](https://smartcar.com/docs/tutorials/android/introduction/)

## Installation

```
dart pub add flutter_smartcar_auth
```

## Requirements

### 1. Sign up for a Smartcar account

Go to the [developer dashboard](https://dashboard.smartcar.com/signup) to sign up with Smartcar.

### 2. Retrieve your API keys

Once you have made your account, you will notice you already have an application with API keys.

### 3. Configure your Redirect URI

Navigate to the **Configuration** section within the dashboard and add a **redirect URI** with the following format: `“sc” + clientId + “://” + hostname`.

### Android

Set the following constants in your `app/src/main/res/values/strings.xml`:

```xml
<resources>
    <string name="smartcar_auth_scheme">sc{YOUR_CLIENT_ID}</string>
    <string name="client_id">{YOUR_CLIENT_ID}</string>
    <string name="app_server">{YOUR_HOST}</string>
</resources>
```

Android applications use custom URI schemes to intercept calls and launch the relevant application. Add the following code snippet to your `android/app/src/main/AndroidManifest.xml`:

```xml
<activity android:name="com.smartcar.sdk.SmartcarCodeReceiver"
            android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
            android:scheme="@string/smartcar_auth_scheme"
            android:host="@string/app_server"/>
    </intent-filter>
</activity>
```

### iOS

The minimum iOS target version required is 11.

## Usage

Import `package:flutter_smartcar_auth/flutter_smartcar_auth.dart` and use the methods in Smartcar class.

Example:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Smartcar Auth',
      home: _SmartcarAuthMenu(),
    );
  }
}

class _SmartcarAuthMenu extends StatefulWidget {
  const _SmartcarAuthMenu();

  @override
  State<_SmartcarAuthMenu> createState() => _SmartcarAuthMenuState();
}

class _SmartcarAuthMenuState extends State<_SmartcarAuthMenu> {
  @override
  void initState() {
    super.initState();

    Smartcar.onSmartcarResponse.listen(_handleSmartcarResponse);
  }

  void _handleSmartcarResponse(SmartcarAuthResponse response) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    switch (response) {
      case SmartcarAuthSuccess success:
        scaffoldMessenger.showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.green,
            content: Text(
              'code: ${success.code}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            actions: const [SizedBox.shrink()],
          ),
        );
        break;
      case SmartcarAuthFailure failure:
        scaffoldMessenger.showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.redAccent,
            content: Text(
              'error: ${failure.description}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            actions: const [SizedBox.shrink()],
          ),
        );
        break;
    }

    Future.delayed(
      const Duration(
        seconds: 3,
      ),
    ).then((_) => scaffoldMessenger.hideCurrentMaterialBanner());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Smartcar Auth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async {
                await Smartcar.setup(
                  configuration: const SmartcarConfig(
                    clientId: "{YOUR_CLIENT_ID}",
                    redirectUri: "sc{YOUR_CLIENT_ID}://{YOUR_HOST}",
                    scopes: [SmartcarPermission.readOdometer],
                    mode: SmartcarMode.test,
                  ),
                );
              },
              child: const Text("Setup"),
            ),
            MaterialButton(
              onPressed: () async {
                await Smartcar.launchAuthFlow();
              },
              child: const Text("Launch Auth Flow"),
            ),
            MaterialButton(
              onPressed: () async {
                await Smartcar.launchAuthFlow(
                  authUrlBuilder: const AuthUrlBuilder(
                    flags: [
                      'tesla_auth:true',
                    ],
                    singleSelect: true,
                  ),
                );
              },
              child: const Text("Launch Auth Flow with Tesla Flag"),
            ),
          ],
        ),
      ),
    );
  }
}


```