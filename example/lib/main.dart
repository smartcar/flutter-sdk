import 'dart:convert';

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
  final _clientIdController = TextEditingController();
  final _redirectUriController = TextEditingController();
  final _externalIdController = TextEditingController();

  SmartcarResponseType _responseType = SmartcarResponseType.code;
  SmartcarMode _mode = SmartcarMode.live;

  String? _lastResponseJson;

  @override
  void initState() {
    super.initState();

    Smartcar.onSmartcarResponse.listen(_handleSmartcarResponse);
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _redirectUriController.dispose();
    _externalIdController.dispose();
    super.dispose();
  }

  void _handleSmartcarResponse(SmartcarAuthResponse response) {
    final Map<String, dynamic> json = switch (response) {
      SmartcarAuthSuccess success => {
          'type': 'success',
          'code': success.code,
          'state': success.state,
          'virtualKeyUrl': success.virtualKeyUrl,
          'userId': success.userId,
          'externalId': success.externalId,
        },
      SmartcarAuthFailure failure => {
          'type': 'failure',
          'errorType': failure.type?.name,
          'description': failure.description,
        },
    };

    setState(() {
      _lastResponseJson = const JsonEncoder.withIndent('  ').convert(json);
    });
  }

  String? _valueOrNull(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _setup() {
    return Smartcar.setup(
      configuration: SmartcarConfig(
        clientId: _clientIdController.text.trim(),
        redirectUri: _valueOrNull(_redirectUriController),
        scopes: [SmartcarPermission.readOdometer],
        mode: _mode,
        responseType: _responseType,
      ),
    );
  }

  Future<void> _runAuthFlow(Future<void> Function() action) async {
    try {
      await _setup();
      await action();
    } catch (error) {
      if (!mounted) return;

      final scaffoldMessenger = ScaffoldMessenger.of(context);

      scaffoldMessenger.showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.redAccent,
          content: Text(
            '$error',
            style: const TextStyle(color: Colors.white),
          ),
          actions: const [SizedBox.shrink()],
        ),
      );

      Future.delayed(
        const Duration(seconds: 3),
      ).then((_) => scaffoldMessenger.hideCurrentMaterialBanner());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Smartcar Auth'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _clientIdController,
                decoration: const InputDecoration(
                  labelText: 'Application ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _redirectUriController,
                decoration: const InputDecoration(
                  labelText: 'Redirect URI (optional when Response Type is "none")',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _externalIdController,
                decoration: const InputDecoration(
                  labelText: 'External ID (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<SmartcarResponseType>(
                initialValue: _responseType,
                decoration: const InputDecoration(
                  labelText: 'Response Type',
                  border: OutlineInputBorder(),
                ),
                items: SmartcarResponseType.values
                    .map((type) => DropdownMenuItem(value: type, child: Text(type.value)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _responseType = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<SmartcarMode>(
                initialValue: _mode,
                decoration: const InputDecoration(
                  labelText: 'Mode',
                  border: OutlineInputBorder(),
                ),
                items: const [SmartcarMode.live, SmartcarMode.simulated]
                    .map((mode) => DropdownMenuItem(value: mode, child: Text(mode.name)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _mode = value);
                },
              ),
              const SizedBox(height: 24),
              MaterialButton(
                color: Theme.of(context).colorScheme.primaryContainer,
                onPressed: () => _runAuthFlow(
                  () => Smartcar.launchAuthFlow(
                    authUrlBuilder: AuthUrlBuilder(
                      externalId: _valueOrNull(_externalIdController),
                    ),
                  ),
                ),
                child: const Text("Launch Auth Flow"),
              ),
              MaterialButton(
                onPressed: () => _runAuthFlow(
                  () => Smartcar.launchAuthFlow(
                    authUrlBuilder: AuthUrlBuilder(
                      flags: const [
                        'tesla_auth:true',
                      ],
                      singleSelect: true,
                      externalId: _valueOrNull(_externalIdController),
                    ),
                  ),
                ),
                child: const Text("Launch Auth Flow with Tesla Flag"),
              ),
              if (_lastResponseJson != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),
                const Text('Last Smartcar Response', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    _lastResponseJson!,
                    style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
