import 'dart:convert';
import 'dart:developer';

import 'package:example/otp/otp_page.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_verifyspeed/flutter_verifyspeed.dart';
import 'package:http/http.dart' as http;

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({
    super.key,
  });

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  late TextEditingController countryCodeController;
  late TextEditingController phoneNumberController;
  late FocusNode countryCodeFocusNode;
  late FocusNode phoneNumberFocusNode;
  CountryCode? selectedCountry;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    countryCodeController = TextEditingController(text: '+');
    phoneNumberController = TextEditingController();
    countryCodeFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();
  }

  @override
  void dispose() {
    countryCodeController.dispose();
    phoneNumberController.dispose();
    countryCodeFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _unfocusFields() {
    countryCodeFocusNode.unfocus();
    phoneNumberFocusNode.unfocus();
  }

  Future<void> _pickCountry() async {
    final height = MediaQuery.of(context).size.height;

    const countryPicker = FlCountryCodePicker();
    final pickedCountry = await countryPicker.showPicker(
      context: context,
      pickerMaxHeight: height / 1.3,
      pickerMinHeight: height / 1.3,
    );

    if (pickedCountry != null) {
      phoneNumberController.clear();
      selectedCountry = pickedCountry;

      setState(() {});

      countryCodeController.text = pickedCountry.dialCode;

      phoneNumberFocusNode.requestFocus();
    }
  }

  void _onCountryCodeChanged(String value) {
    final countries = CountryManager().countries;
    final countryDataList = countries.where(
      (element) => element.phoneCode.startsWith(value.replaceFirst('+', '')),
    );

    selectedCountry = null;
    if (value.isEmpty) {
      countryCodeController.text = '+';
    } else if (countryDataList.length == 1) {
      phoneNumberFocusNode.requestFocus();

      const countryCodePicker = FlCountryCodePicker();

      final selectedCountry = countryCodePicker.countryCodes.firstWhere(
        (element) => element.code == countryDataList.first.countryCode,
      );

      this.selectedCountry = selectedCountry;
    } else if (countryDataList.length > 1) {
      const countryCodePicker = FlCountryCodePicker();

      final selectedCountry = countryCodePicker.countryCodes.firstWhere(
        (element) => element.code == countryDataList.first.countryCode,
      );

      this.selectedCountry = selectedCountry;
    }

    setState(() {});
  }

  Future<void> _submit() async {
    try {
      if (selectedCountry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a country')),
        );
        return;
      } else if (phoneNumberController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a phone number')),
        );
        return;
      }

      final phoneNumber =
          phoneNumberController.text.replaceAll(' ', '').replaceAll('-', '');

      setState(() => isLoading = true);

      const url = 'YOUR_BASE_URL/YOUR_START_END_POINT';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'methodName': 'sms-otp',
            'isWeb': false,
          },
        ),
      );

      if (response.statusCode != 200) {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to get response');
      }

      final body = (jsonDecode(response.body) as Map);

      final verificationKey = body['verificationKey'] as String;

      final otpProcessor = VerifySpeed.instance.initializeOtpProcessor();

      await otpProcessor.verifyPhoneNumberWithOtp(
        phoneNumber: '${selectedCountry!.dialCode}$phoneNumber',
        verificationKey: verificationKey,
      );

      final ctx = context;
      if (ctx.mounted) {
        Navigator.of(ctx).push(
          MaterialPageRoute(
            builder: (context) => OtpPage(
              phoneNumber: '${selectedCountry!.dialCode}$phoneNumber',
              verificationKey: verificationKey,
              otpProcessor: otpProcessor,
            ),
          ),
        );
      }
    } catch (error) {
      log('Error: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTap: _unfocusFields,
        child: ColoredBox(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height / 4.5),
                  const Text(
                    'Please confirm your country code and enter your phone number',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 50),
                  CountryPickerTile(
                    selectedCountry: selectedCountry,
                    onTap: _pickCountry,
                  ),
                  const SizedBox(height: 30),
                  PhoneNumberInput(
                    countryCodeController: countryCodeController,
                    phoneNumberController: phoneNumberController,
                    countryCodeFocusNode: countryCodeFocusNode,
                    phoneNumberFocusNode: phoneNumberFocusNode,
                    onCountryCodeChanged: _onCountryCodeChanged,
                  ),
                  const SizedBox(height: 30),
                  SubmitButton(onPressed: _submit, isLoading: isLoading),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CountryPickerTile extends StatelessWidget {
  final CountryCode? selectedCountry;
  final VoidCallback onTap;

  const CountryPickerTile({
    super.key,
    required this.selectedCountry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Text(
        selectedCountry == null ? 'Country' : selectedCountry?.name ?? '',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        side: BorderSide(),
      ),
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController countryCodeController;
  final TextEditingController phoneNumberController;
  final FocusNode countryCodeFocusNode;
  final FocusNode phoneNumberFocusNode;
  final ValueChanged<String> onCountryCodeChanged;

  const PhoneNumberInput({
    super.key,
    required this.countryCodeController,
    required this.phoneNumberController,
    required this.countryCodeFocusNode,
    required this.phoneNumberFocusNode,
    required this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: TextField(
                onChanged: onCountryCodeChanged,
                cursorColor: Colors.black,
                autofocus: true,
                controller: countryCodeController,
                focusNode: countryCodeFocusNode,
                keyboardType: TextInputType.phone,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 5,
                decoration: const InputDecoration(
                  counter: SizedBox(),
                  border: InputBorder.none,
                  suffixIcon: SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 5,
                      endIndent: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                cursorColor: Colors.black,
                inputFormatters: [
                  () {
                    final country = CountryWithPhoneCode.getCountryDataByPhone(
                      countryCodeController.text,
                    );
                    if (country == null) {
                      return FilteringTextInputFormatter.digitsOnly;
                    }
                    return LibPhonenumberTextFormatter(country: country);
                  }()
                ],
                controller: phoneNumberController,
                focusNode: phoneNumberFocusNode,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : const Text('Submit'),
    );
  }
}
