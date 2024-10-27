import 'package:flutter_verifyspeed_plugin/flutter_verifyspeed_plugin.dart';

final class VerifySpeed {
  VerifySpeed._();

  static final VerifySpeed instance = VerifySpeed._();

  DeepLinkProcessor initializeDeepLinkProcessor({
    bool redirectToStore = true,
  }) =>
      DeepLinkProcessor._(redirectToStore: redirectToStore);

  OtpProcessor initializeOtpProcessor() => const OtpProcessor._();

  Future<void> checkInterruptedSession({
    required void Function(String token) onSuccess,
    required void Function(VerifySpeedError error) onFailure,
  }) =>
      VerifySpeedPlugin.instance.checkInterruptedSession(
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
}

final class DeepLinkProcessor {
  const DeepLinkProcessor._({required this.redirectToStore});

  final bool redirectToStore;

  Future<void> verifyPhoneNumberWithDeepLink({
    required String deepLink,
    required String verificationKey,
    required void Function(String token) onSuccess,
    required void Function(VerifySpeedError error) onFailure,
  }) =>
      VerifySpeedPlugin.instance.verifyPhoneNumberWithDeepLink(
        deepLink: deepLink,
        verificationKey: verificationKey,
        redirectToStore: redirectToStore,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );

  Future<void> notifyOnResumed() =>
      VerifySpeedPlugin.instance.notifyOnResumed();
}

final class OtpProcessor {
  const OtpProcessor._();

  Future<void> verifyPhoneNumberWithOtp({
    required String phoneNumber,
    required String verificationKey,
  }) =>
      VerifySpeedPlugin.instance.verifyPhoneNumberWithOtp(
        phoneNumber: phoneNumber,
        verificationKey: verificationKey,
      );

  Future<void> validateOtp({
    required String otpCode,
    required String verificationKey,
    required void Function(String token) onSuccess,
    required void Function(VerifySpeedError error) onFailure,
  }) =>
      VerifySpeedPlugin.instance.validateOtp(
        otpCode: otpCode,
        verificationKey: verificationKey,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
}
