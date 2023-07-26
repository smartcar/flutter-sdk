# flutter_smartcar_auth

A Flutter plugin for [Smartcar Connect](https://smartcar.com/docs/).

This plugin integrates the native SDKs:

- [Smartcar Auth iOS SDK](https://smartcar.com/docs/tutorials/ios/introduction/)
- [Smartcar Auth Android SDK](https://smartcar.com/docs/tutorials/android/introduction/)

<h1>Installation</h1>

```
dart pub add flutter_smartcar_auth
```

<h1>Requirements</h1>

<h3>1. Sign up for a Smartcar account</h3>

Go to the [developer dashboard](https://dashboard.smartcar.com/signup) to sign up with Smartcar.

<h3>2. Retrieve your API keys</h3>

Once you have made your account, you will notice you already have an application with API keys.

<h3>3. Configure your Redirect URI</h3>

Navigate to the **Configuration** section within the dashboard and add a **redirect URI** with the following format: `“sc” + clientId + “://” + hostname`.

<h3>Android</h3>

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
            android:scheme="sc{YOUR_CLIENT_ID}"
            android:host="{YOUR_HOST}"/>
    </intent-filter>
</activity>
```

<h3>iOS</h3>

The minimum iOS target version required is 11.

<h2>Usage</h2>

Import `package:flutter_smartcar_auth/flutter_smartcar_auth.dart` and use the methods in Smartcar class.

Example:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Smartcar.onSmartcarResponse.listen((event) {
      debugPrint(event.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Smartcar Auth',
      home: Scaffold(
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
                      testMode: true,
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
            ],
          ),
        ),
      ),
    );
  }
}

```