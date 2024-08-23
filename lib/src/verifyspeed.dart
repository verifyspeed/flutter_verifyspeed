import 'package:flutter_verifyspeed/flutter_verifyspeed.dart';
import 'package:flutter_verifyspeed_plugin/flutter_verifyspeed_plugin.dart';

final class VerifySpeed {
  VerifySpeed._();

  static final VerifySpeed instance = VerifySpeed._();

  DefaultUIProcessor initializeDefaultUIProcessor(
    String clientKey,
  ) {
    VerifySpeedPlugin.instance.setClientKey(clientKey);
    return const DefaultUIProcessor._();
  }

  CustomUIProcessor initializeCustomUIProcessor({
    required String clientKey,
    bool redirectToStore = true,
  }) {
    VerifySpeedPlugin.instance.setClientKey(clientKey);

    return CustomUIProcessor._(
      redirectToStore: redirectToStore,
    );
  }

  DeepLinkProcessor consumeDeepLink({
    bool redirectToStore = true,
  }) {
    return DeepLinkProcessor._(
      redirectToStore: redirectToStore,
    );
  }

  Future<void> checkInterruptedSession({
    required void Function(String token) onSuccess,
    required void Function(VerifySpeedError error) onFailure,
  }) =>
      VerifySpeedPlugin.instance.checkInterruptedSession(
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
}

final class DefaultUIProcessor {
  const DefaultUIProcessor._();

  VerifySpeedPage start({
    required void Function(String token) onSuccess,
    required void Function(VerifySpeedError error) onFailure,
  }) =>
      VerifySpeedPage(
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
}

final class CustomUIProcessor extends _OnResumed {
  const CustomUIProcessor._({
    this.redirectToStore = true,
  });

  final bool redirectToStore;

  Future<void> start({
    required void Function(String token) onSuccess,
    required void Function(VerifySpeedError error) onFailure,
    required VerifySpeedMethodType type,
  }) {
    return VerifySpeedPlugin.instance.startVerification(
      onFailure: onFailure,
      onSuccess: onSuccess,
      type: type,
      redirectToStore: redirectToStore,
    );
  }
}

final class DeepLinkProcessor extends _OnResumed {
  const DeepLinkProcessor._({
    this.redirectToStore = true,
  });

  final bool redirectToStore;

  Future<void> start({
    required String deepLink,
    required String verificationKey,
    required String methodName,
    required void Function(String token) onSuccess,
    required void Function(VerifySpeedError error) onFailure,
  }) =>
      VerifySpeedPlugin.instance.startVerificationWithDeepLink(
        onFailure: onFailure,
        onSuccess: onSuccess,
        deepLink: deepLink,
        verificationKey: verificationKey,
        verificationName: methodName,
        redirectToStore: redirectToStore,
      );
}

final class _OnResumed {
  const _OnResumed();

  Future<void> notifyOnResumed() =>
      VerifySpeedPlugin.instance.notifyOnResumed();
}
