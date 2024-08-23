import 'dart:convert';

import 'package:flutter_verifyspeed_plugin/flutter_verifyspeed_plugin.dart';

class MethodModel {
  const MethodModel({
    this.methodName,
    this.displayName,
  });

  final VerifySpeedMethodType? methodName;
  final String? displayName;

  factory MethodModel.fromMap(Map<String, dynamic> map) {
    return MethodModel(
      methodName: map['methodName'] != null
          ? VerifySpeedMethodType.fromMap(map['methodName'] as String)
          : null,
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
    );
  }

  factory MethodModel.fromJson(String source) =>
      MethodModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MethodModel(methodName: $methodName, displayName: $displayName)';

  @override
  bool operator ==(covariant MethodModel other) {
    if (identical(this, other)) return true;

    return other.methodName == methodName && other.displayName == displayName;
  }

  @override
  int get hashCode => methodName.hashCode ^ displayName.hashCode;
}
