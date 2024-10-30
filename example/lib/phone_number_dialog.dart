import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String>? getPhoneNumber(String token) async {
  const url = 'YOUR_BASE_URL/YOUR_LOGIN_END_POINT';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'verifySpeedToken': token}),
  );

  final phoneNumber = jsonDecode(response.body)['phoneNumber'];

  return phoneNumber;
}

void showPhoneNumberDialog(
  BuildContext context,
  String token,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
            future: getPhoneNumber(token),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Verified phone number',
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      snapshot.data ?? 'Something went wrong',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(200, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}
