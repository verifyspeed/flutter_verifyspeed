import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_verifyspeed/src/models/method_model.dart';

final class VerifySpeedModel {
  const VerifySpeedModel({this.availableMethods});

  final Iterable<MethodModel>? availableMethods;

  factory VerifySpeedModel.fromMap(Map<String, dynamic> map) =>
      VerifySpeedModel(
        availableMethods: (map['availableMethods'] as List?)?.map(
          (x) => MethodModel.fromMap(x as Map<String, dynamic>),
        ),
      );

  factory VerifySpeedModel.fromJson(String source) =>
      VerifySpeedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VerifySpeedModel(methods: $availableMethods)';

  @override
  bool operator ==(covariant VerifySpeedModel other) {
    if (identical(this, other)) return true;

    return listEquals(
      other.availableMethods?.toList(),
      availableMethods?.toList(),
    );
  }

  @override
  int get hashCode => availableMethods.hashCode;
}
