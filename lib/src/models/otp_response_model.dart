class OtpResponseModel {
  const OtpResponseModel({
    required this.verificationKey,
    required this.sentByMethodName,
    required this.sentByMethodDisplay,
    this.nextSendAvailableAt,
  });

  final String verificationKey;
  final String sentByMethodName;
  final String sentByMethodDisplay;
  final DateTime? nextSendAvailableAt;

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      verificationKey: json['verificationKey'] as String,
      sentByMethodName: json['sentByMethodName'] as String,
      sentByMethodDisplay: json['sentByMethodDisplay'] as String,
      nextSendAvailableAt: json['nextSendAvailableAt'] != null
          ? DateTime.parse(json['nextSendAvailableAt'] as String).toLocal()
          : null,
    );
  }

  @override
  String toString() =>
      'OtpResponseModel(verificationKey: $verificationKey, sentByMethodName: $sentByMethodName, sentByMethodDisplay: $sentByMethodDisplay, nextSendAvailableAt: $nextSendAvailableAt)';

  @override
  bool operator ==(covariant OtpResponseModel other) {
    if (identical(this, other)) return true;

    return other.verificationKey == verificationKey &&
        other.sentByMethodName == sentByMethodName &&
        other.sentByMethodDisplay == sentByMethodDisplay &&
        other.nextSendAvailableAt == nextSendAvailableAt;
  }

  @override
  int get hashCode =>
      verificationKey.hashCode ^
      sentByMethodName.hashCode ^
      sentByMethodDisplay.hashCode ^
      nextSendAvailableAt.hashCode;
}
