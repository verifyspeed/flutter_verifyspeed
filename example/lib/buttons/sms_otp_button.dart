import 'package:flutter/material.dart';

class SmsOtpButton extends StatelessWidget {
  const SmsOtpButton({
    super.key,
    required this.onPressed,
    this.text,
  });

  final void Function() onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: switch (text) {
            'Telegram OTP' => Colors.blue,
            'WhatsApp OTP' => Colors.green,
            _ => Colors.black,
          },
          minimumSize: const Size(300, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text ?? 'OTP Method',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
