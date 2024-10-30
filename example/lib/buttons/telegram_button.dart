import 'package:flutter/material.dart';

class TelegramButton extends StatelessWidget {
  const TelegramButton({
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
          backgroundColor: Colors.blue,
          minimumSize: const Size(300, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          'Telegram',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
