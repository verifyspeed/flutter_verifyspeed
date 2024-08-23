import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_verifyspeed/src/models/method_model.dart';

final class VerifySpeedModel {
  VerifySpeedModel({
    this.availableMethods,
  });

  final List<MethodModel>? availableMethods;

  factory VerifySpeedModel.fromMap(Map<String, dynamic> map) {
    return VerifySpeedModel(
      availableMethods: map['availableMethods'] != null
          ? List<MethodModel>.from(
              (map['availableMethods'] as List).map<MethodModel?>(
                (x) => MethodModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory VerifySpeedModel.fromJson(String source) =>
      VerifySpeedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VerifySpeedModel(methods: $availableMethods)';

  @override
  bool operator ==(covariant VerifySpeedModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.availableMethods, availableMethods);
  }

  @override
  int get hashCode => availableMethods.hashCode;
}
