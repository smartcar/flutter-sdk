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
