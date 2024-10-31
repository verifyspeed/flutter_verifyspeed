import 'dart:developer';
import 'dart:io';

import 'package:example/phone_number_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verifyspeed/flutter_verifyspeed.dart';
import 'package:pinput/pinput.dart';

//! TIP: (ANDROID) We Recommend using this package to auto fill the otp code
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({
    super.key,
    required this.verificationKey,
    required this.phoneNumber,
    required this.otpProcessor,
  });

  final String verificationKey;
  final String phoneNumber;
  final OtpProcessor otpProcessor;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final codeController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getSignatureCode();
    _startListeningSms();
  }

  @override
  void dispose() {
    codeController.dispose();
    if (Platform.isAndroid) {
      SmsVerification.stopListening();
    }
    super.dispose();
  }

  void _getSignatureCode() async {
    String? signature = await SmsVerification.getAppSignature();

    //! TIP: (IOS) signature is not needed only need keyoword (code) in the message, like:
    //! Your otp code is: 123456

    //! TIP: (ANDROID) Add signature to the your message to auto fill work, like:
    //! Your otp code is: 123456
    //!
    //! YOUR_SIGNATURE
    log("signature $signature");
  }

  void _startListeningSms() {
    SmsVerification.startListeningSms().then(
      (message) {
        if (message == null || message.isEmpty) return;

        setState(
          () {
            final code = SmsVerification.getCode(
              message,
              RegExp(r'\d+', multiLine: true),
            );
            codeController.text = code;

            verifyCode();
          },
        );
      },
    );
  }

  Future<void> verifyCode() async {
    try {
      setState(() => isLoading = true);

      //* TIP: Validate OTP (VERIFY OTP CODE)
      await widget.otpProcessor.validateOtp(
        otpCode: codeController.text,
        verificationKey: widget.verificationKey,
        onSuccess: (token) {
          Navigator.of(context)
            ..pop()
            ..pop();

          showPhoneNumberDialog(context, token);
        },
        onFailure: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Error occurred')),
          );

          log('error: ${error.message} type: ${error.type}');
          setState(() => isLoading = false);
        },
      );
    } catch (e) {
      log('error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height / 5),
              PhoneNumberText(phoneNumber: widget.phoneNumber),
              const SizedBox(height: 50),
              OtpInput(
                codeController: codeController,
                onCodeChanged: (value) =>
                    setState(() => codeController.text = value!),
              ),
              const SizedBox(height: 50),
              VerifyButton(
                codeController: codeController,
                verificationKey: widget.verificationKey,
                onVerify: verifyCode,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberText extends StatelessWidget {
  const PhoneNumberText({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Text(
      'We sent an SMS with a code to your phone $phoneNumber',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.codeController,
    required this.onCodeChanged,
  });

  final TextEditingController codeController;
  final Function(String?) onCodeChanged;
  @override
  Widget build(BuildContext context) {
    return Pinput(
      autofocus: true,
      controller: codeController,
      onChanged: onCodeChanged,
      length: 6,
    );
  }
}

class VerifyButton extends StatefulWidget {
  const VerifyButton({
    super.key,
    required this.codeController,
    required this.verificationKey,
    required this.onVerify,
    required this.isLoading,
  });

  final TextEditingController codeController;
  final String verificationKey;
  final Function() onVerify;
  final bool isLoading;

  @override
  State<VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<VerifyButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: widget.onVerify,
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: widget.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : const Text('Verify'),
    );
  }
}
