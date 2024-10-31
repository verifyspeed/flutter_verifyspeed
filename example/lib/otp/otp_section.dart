import 'package:example/buttons/sms_otp_button.dart';
import 'package:example/otp/phone_number_page.dart';
import 'package:flutter/material.dart';

class OtpSection extends StatelessWidget {
  const OtpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SmsOtpButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PhoneNumberPage(),
        ),
      ),
    );
  }
}
