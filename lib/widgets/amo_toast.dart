import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class AmoToast {
  static ToastFuture showAmoToast(String message, BuildContext context) {
    return showToast(
      message,
      borderRadius: BorderRadius.circular(20),
      backgroundColor: Colors.black,
      textStyle: const TextStyle(color: Colors.white),
      context: context,
      alignment: Alignment.topCenter,
      animation: StyledToastAnimation.slideFromBottom,
      isHideKeyboard: true,
    );
  }
}
