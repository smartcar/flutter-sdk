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
