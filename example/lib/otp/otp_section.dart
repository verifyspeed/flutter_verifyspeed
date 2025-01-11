import 'package:example/buttons/sms_otp_button.dart';
import 'package:example/otp/phone_number_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verifyspeed/flutter_verifyspeed.dart';

class OtpSection extends StatelessWidget {
  const OtpSection({
    super.key,
    required this.method,
    this.defaultCountryCode,
  });

  final MethodModel method;
  final String? defaultCountryCode;

  @override
  Widget build(BuildContext context) {
    return SmsOtpButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhoneNumberPage(
            methodName: method.methodName ?? '',
            defaultCountryCode: defaultCountryCode,
          ),
        ),
      ),
      text: method.displayName,
    );
  }
}
