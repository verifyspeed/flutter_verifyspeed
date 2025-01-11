import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:example/deeplink/deep_link_section.dart';
import 'package:example/otp/otp_section.dart';
import 'package:example/phone_number_dialog.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verifyspeed/flutter_verifyspeed.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? defaultCountryCode;
  static Iterable<MethodModel>? _cachedMethods;

  @override
  void initState() {
    super.initState();
    _fetchDefaultCountry();

    //* TIP: Check for interrupted session
    Future.delayed(const Duration(seconds: 1), () {
      VerifySpeed.instance.checkInterruptedSession(
        onSuccess: (token) {
          showPhoneNumberDialog(context, token, isInterruptedSession: true);
        },
      );
    });
  }

  Future<Iterable<MethodModel>> getLoginMethods({
    bool forceRefresh = false,
  }) async {
    if (_cachedMethods != null && !forceRefresh) {
      return _cachedMethods!;
    }

    try {
      //* TIP: Set your client key here
      VerifySpeed.instance.setClientKey('YOUR_CLIENT_KEY');

      //* TIP: Initialize to get available methods
      final methods = await VerifySpeed.instance.initialize();

      if (methods?.availableMethods?.isEmpty ?? true) {
        throw Exception('No available methods');
      }

      _cachedMethods = methods?.availableMethods ?? [];

      return _cachedMethods!;
    } catch (error) {
      log(
        'Error fetching login methods and initialize, please check your client key: $error',
      );

      throw Exception(
        'Failed to fetch login methods and initialize, please check your client key',
      );
    }
  }

  Future<void> _fetchDefaultCountry() async {
    try {
      final response = await http.get(Uri.parse('https://api.country.is/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final countryCode = data['country'] as String;

        const picker = FlCountryCodePicker();
        final country = picker.countryCodes.firstWhereOrNull(
          (c) => c.code == countryCode,
        );

        setState(() {
          defaultCountryCode = country?.dialCode;
        });
      }
    } catch (e) {
      log('Error fetching country: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: const Color(0xFFFF5B36),
        onRefresh: () async => getLoginMethods(forceRefresh: true),
        child: SafeArea(
          child: ListView(
            children: [
              const SizedBox(height: 40),
              SizedBox(height: MediaQuery.of(context).size.height / 3.5),
              _buildHeader(),
              const SizedBox(height: 30),
              _buildMethodsList(),
            ],
          ),
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
    return FutureBuilder<Iterable<MethodModel>>(
      future: getLoginMethods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
              strokeWidth: 5,
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorButton();
        }

        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final availableMethods = snapshot.data!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: availableMethods.map((method) {
            if (method.methodName?.contains('message') ?? false) {
              return DeepLinkSection(method: method);
            }

            if (method.methodName?.contains('otp') ?? false) {
              return OtpSection(
                method: method,
                defaultCountryCode: defaultCountryCode,
              );
            }

            return const SizedBox();
          }).toList(),
        );
      },
    );
  }

  Widget _buildErrorButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: FilledButton(
        style: FilledButton.styleFrom(
          minimumSize: const Size(200, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            _cachedMethods = null;
            getLoginMethods(forceRefresh: true);
          });
        },
        child: const Text(
          'Try Again',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
