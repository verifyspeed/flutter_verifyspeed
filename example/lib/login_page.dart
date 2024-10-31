import 'package:example/deeplink/deep_link_section.dart';
import 'package:example/otp/otp_section.dart';
import 'package:example/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            SizedBox(height: MediaQuery.of(context).size.height / 3.5),
            _buildHeader(),
            const SizedBox(height: 30),
            _buildMethodsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text('Available Methods', style: TextStyle(fontSize: 24)),
        SizedBox(height: 10),
        Divider(
          indent: 120,
          endIndent: 120,
          color: Colors.black12,
          thickness: 2,
        ),
      ],
    );
  }

  Widget _buildMethodsList() {
    return FutureBuilder<List<String>>(
      future: _authService.getLoginMethods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.orange,
            strokeWidth: 5,
          );
        }

        if (snapshot.hasError) {
          return _buildErrorButton();
        }

        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final data = snapshot.data!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Handle Deep Link buttons
            if (data.contains('telegram-message') ||
                data.contains('whatsapp-message'))
              DeepLinkSection(methods: data),

            // Handle SMS OTP button
            if (data.contains('sms-otp')) const OtpSection()
          ],
        );
      },
    );
  }

  Widget _buildErrorButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size(200, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () => setState(() {}),
      child: const Text(
        'Try Again',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
