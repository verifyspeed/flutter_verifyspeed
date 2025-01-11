import 'dart:convert';
import 'dart:developer';

import 'package:example/buttons/telegram_button.dart';
import 'package:example/buttons/whatsapp_button.dart';
import 'package:example/phone_number_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verifyspeed/flutter_verifyspeed.dart';
import 'package:http/http.dart' as http;

class DeepLinkSection extends StatefulWidget {
  const DeepLinkSection({
    super.key,
    required this.method,
  });

  final MethodModel method;

  @override
  State<DeepLinkSection> createState() => _DeepLinkSectionState();
}

class _DeepLinkSectionState extends State<DeepLinkSection>
    with WidgetsBindingObserver {
  //* TIP: Initialize the deep link processor
  late DeepLinkProcessor deepLinkProcessor;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    //* TIP: Get the deep link processor
    deepLinkProcessor = VerifySpeed.instance.initializeDeepLinkProcessor();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      //* TIP: This is required to notify the SDK that the app has been resumed
      await deepLinkProcessor.notifyOnResumed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Future<void> onStartVerification(String? methodName) async {
    setState(() => isLoading = true);

    const url = 'YOUR_API_ENDPOINT';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'methodName': methodName,
        'isWeb': false,
      }),
    );

    if (response.statusCode != 200) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to get response');
    }

    final body = (jsonDecode(response.body) as Map);

    //* TIP: Verify phone number with deep link
    await deepLinkProcessor.verifyPhoneNumberWithDeepLink(
      deepLink: body['deepLink'] as String,
      verificationKey: body['verificationKey'] as String,
      onSuccess: (token) async {
        setState(() {
          isLoading = false;
        });
        log('token: $token');

        showPhoneNumberDialog(context, token);
      },
      onFailure: (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message ?? 'Error occurred',
            ),
          ),
        );
        log('error: ${error.message} type: ${error.type}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.method.methodName) {
      'telegram-message' => TelegramButton(
          onPressed: () => onStartVerification(widget.method.methodName),
          text: widget.method.displayName,
        ),
      'whatsapp-message' => WhatsappButton(
          onPressed: () => onStartVerification(widget.method.methodName),
          text: widget.method.displayName,
        ),
      _ => const SizedBox(),
    };
  }
}
