import 'dart:convert';

class MethodModel {
  const MethodModel({
    this.methodName,
    this.displayName,
  });

  final String? methodName;
  final String? displayName;

  factory MethodModel.fromMap(Map<String, dynamic> map) => MethodModel(
        methodName: map['methodName'] as String?,
        displayName: map['displayName'] as String?,
      );

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
