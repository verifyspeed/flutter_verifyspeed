import 'package:flutter_verifyspeed/src/models/models.dart';
import 'package:flutter_verifyspeed_plugin/flutter_verifyspeed_plugin.dart';

final class VerifySpeed {
  const VerifySpeed._();

  static final VerifySpeed instance = VerifySpeed._();

  /// This key determines which verification methods will be available
  /// when calling initialize().
  void setClientKey(String clientKey) =>
      VerifySpeedPlugin.instance.setClientKey(clientKey);

  /// Initializes the VerifySpeed service and returns available verification methods.
  /// Returns a VerifySpeedModel containing an Iterable<MethodModel> with:
  /// - methodName: Identifier used for verification
  /// - displayName: Human-readable name for the method
  Future<VerifySpeedModel?> initialize() async {
    final result = await VerifySpeedPlugin.instance.initialize();

    if (result == null) return null;

    final verifySpeedModel = VerifySpeedModel.fromJson(result);

    return verifySpeedModel;
  }

  /// Initializes a processor for handling deep link verification with external apps (e.g. Telegram, WhatsApp).
  ///
  /// [redirectToStore] - When true, redirects users to app store if
  /// Telegram or WhatsApp is not installed.
  DeepLinkProcessor initializeDeepLinkProcessor({
    bool redirectToStore = true,
  }) =>
      DeepLinkProcessor._(redirectToStore: redirectToStore);

  /// Initializes a processor for OTP verification.
  /// Use this to verify phone numbers using OTP codes.
  OtpProcessor initializeOtpProcessor() => const OtpProcessor._();

  /// Checks if the user has an interrupted verification session.
  /// This should be called when the app starts to recover any
  /// pending verification process.
  ///
  /// [onSuccess] - Callback triggered with token if an interrupted
  /// session is recovered successfully.
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

  /// Verifies phone number using deep link method with external apps (e.g. Telegram, WhatsApp).
  ///
  /// [deepLink] - URL that directs users to the external app for verification
  /// [verificationKey] - Unique key provided by your backend to ensure verification integrity
  /// [onSuccess] - Callback triggered on successful verification, returning a token
  /// [onFailure] - Callback triggered if verification fails, providing error details
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

  /// Notifies the system that the app has resumed after deep link verification.
  /// Must be called when the app resumes after the user completes verification
  /// in an external app to complete the verification process.
  Future<void> notifyOnResumed() =>
      VerifySpeedPlugin.instance.notifyOnResumed();
}

final class OtpProcessor {
  const OtpProcessor._();

  /// Initiates phone verification using OTP method.
  /// Sends an OTP code to the provided phone number.
  ///
  /// [phoneNumber] - User's phone number with country code
  /// [verificationKey] - Unique key provided by your backend
  ///
  /// Returns an OtpResponseModel with verification details or throws VerifySpeedError on failure.
  Future<OtpResponseModel> verifyPhoneNumberWithOtp({
    required String phoneNumber,
    required String verificationKey,
  }) async {
    final result = await VerifySpeedPlugin.instance.verifyPhoneNumberWithOtp(
      phoneNumber: phoneNumber,
      verificationKey: verificationKey,
    );

    try {
      final otpResponseModel = OtpResponseModel.fromJson(result);

      return otpResponseModel;
    } catch (e) {
      throw VerifySpeedError(
        "Failed to parse OTP response",
        VerifySpeedErrorType.unknown,
      );
    }
  }

  /// Sends another OTP code when the previous one has expired.
  ///
  /// [verificationKey] - Verification key from the initial verification request
  ///
  /// Returns an OtpResponseModel with new verification details or throws VerifySpeedError on failure.
  Future<OtpResponseModel> sendNextDynamicOtp({
    required String verificationKey,
  }) async {
    final result = await VerifySpeedPlugin.instance.sendNextDynamicOtp(
      verificationKey: verificationKey,
    );

    try {
      final otpResponseModel = OtpResponseModel.fromJson(result);

      return otpResponseModel;
    } catch (e) {
      throw VerifySpeedError(
        "Failed to parse OTP response",
        VerifySpeedErrorType.unknown,
      );
    }
  }

  /// Validates the OTP code entered by the user.
  ///
  /// [otpCode] - The OTP code received by the user
  /// [verificationKey] - Verification key from the initial request
  /// [onSuccess] - Callback triggered on successful validation, returning a token
  /// [onFailure] - Callback triggered if validation fails, providing error details
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
