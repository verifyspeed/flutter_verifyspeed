import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_verifyspeed/flutter_verifyspeed.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final DeepLinkProcessor customUIProcessor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    customUIProcessor = VerifySpeed.instance.initializeDeepLinkProcessor(
      redirectToStore: true,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await customUIProcessor.notifyOnResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VerifySpeed Example'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => customUIProcessor.verifyPhoneNumberWithDeepLink(
                deepLink: 'deepLink',
                verificationKey: 'verificationKey',
                onSuccess: (token) {
                  log('onSucces: $token');
                },
                onFailure: (error) {
                  log('onFailure : ${error.message}');
                },
              ),
              child: const Text('startVerification'),
            ),
            ElevatedButton(
              onPressed: () => VerifySpeed.instance.checkInterruptedSession(
                onSuccess: (token) {
                  log('token: $token');
                },
                onFailure: (error) {
                  log('Error on init: ${error.message}');
                },
              ),
              child: const Text('check interrupted session'),
            ),
          ],
        ),
      ),
    );
  }
}
