import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class AuthService {
  static const _baseUrl = 'YOUR_BASE_URL';

  Future<List<String>> getLoginMethods() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/YOUR_START_END_POINT'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load methods: ${response.body}');
      }

      final methods =
          (jsonDecode(response.body) as Map)['loginMethodNames'] as List;

      return methods.map((e) => e.toString()).toList();
    } catch (error) {
      log('Error fetching login methods: $error');

      throw Exception('Failed to fetch login methods');
    }
  }
}
