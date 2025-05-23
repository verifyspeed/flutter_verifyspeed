import 'package:flutter/material.dart';

class WhatsappButton extends StatelessWidget {
  const WhatsappButton({
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
          backgroundColor: Colors.green,
          minimumSize: const Size(300, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text ?? 'Whatsapp',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
