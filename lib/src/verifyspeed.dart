import 'package:flutter_verifyspeed/src/models/models.dart';
import 'package:flutter_verifyspeed_plugin/flutter_verifyspeed_plugin.dart';

final class VerifySpeed {
  const VerifySpeed._();

  static final VerifySpeed instance = VerifySpeed._();

  void setClientKey(String clientKey) =>
      VerifySpeedPlugin.instance.setClientKey(clientKey);

  Future<VerifySpeedModel?> initialize() async {
    final result = await VerifySpeedPlugin.instance.initialize();

    if (result == null) return null;

    final verifySpeedModel = VerifySpeedModel.fromJson(result);

    return verifySpeedModel;
  }

  DeepLinkProcessor initializeDeepLinkProcessor({
    bool redirectToStore = true,
  }) =>
      DeepLinkProcessor._(redirectToStore: redirectToStore);

  OtpProcessor initializeOtpProcessor() => const OtpProcessor._();

  Future<void> checkInterruptedSession({
    required void Function(String token) onSuccess,
  }) =>
      VerifySpeedPlugin.instance.checkInterruptedSession(
        onSuccess: onSuccess,
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
