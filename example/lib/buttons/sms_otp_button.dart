import 'package:flutter/material.dart';

class SmsOtpButton extends StatelessWidget {
  const SmsOtpButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(300, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          'SMS OTP',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
