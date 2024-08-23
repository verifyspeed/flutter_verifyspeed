import 'package:flutter/material.dart';
import 'package:flutter_verifyspeed_plugin/flutter_verifyspeed_plugin.dart';

extension GetIcon on VerifySpeedMethodType {
  String get icon {
    switch (this) {
      case VerifySpeedMethodType.telegram:
        return 'assets/icons/telegram_icon.png';
      case VerifySpeedMethodType.whatsapp:
        return 'assets/icons/whatsapp_icon.png';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case VerifySpeedMethodType.telegram:
        return const Color(0xFF0088CC);
      case VerifySpeedMethodType.whatsapp:
        return const Color(0xFF25D366);
    }
  }

  String get name {
    switch (this) {
      case VerifySpeedMethodType.telegram:
        return 'Telegram';
      case VerifySpeedMethodType.whatsapp:
        return 'WhatsApp';
    }
  }
}
