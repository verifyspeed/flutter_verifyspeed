import 'package:example/buttons/sms_otp_button.dart';
import 'package:example/deeplink/deep_link_page.dart';
import 'package:example/otp/phone_number_page.dart';
import 'package:example/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  bool isDisplayDeepLinkButton = false;

  static const _buttonSize = Size(300, 60);
  static const _buttonTextStyle = TextStyle(fontSize: 20);

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

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildMethodButtons(snapshot.data!),
        );
      },
    );
  }

  List<Widget> _buildMethodButtons(List<String> methods) {
    final widgets = <Widget>[];

    // Handle Deep Link button
    if (methods
            .any((m) => m == 'telegram-message' || m == 'whatsapp-message') &&
        !isDisplayDeepLinkButton) {
      widgets.add(_buildDeepLinkButton(methods));
    }

    // Handle SMS OTP button
    if (methods.contains('sms-otp')) {
      widgets.add(_buildSmsOtpButton());
    }

    return widgets;
  }

  Widget _buildDeepLinkButton(List<String> methods) {
    return FilledButton(
      onPressed: () {
        setState(() => isDisplayDeepLinkButton = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeepLinkPage(methods: methods),
          ),
        );
      },
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: _buttonSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: const Text('Deep Link', style: _buttonTextStyle),
    );
  }

  Widget _buildSmsOtpButton() {
    return SmsOtpButton(
      onPressed: () {
        setState(() => isDisplayDeepLinkButton = false);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PhoneNumberPage(),
          ),
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
