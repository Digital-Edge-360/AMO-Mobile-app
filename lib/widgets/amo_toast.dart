import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class AmoToast {



  static ToastFuture showAmoToast(String message, BuildContext context) {
    return showToast(message,
      borderRadius: BorderRadius.circular(20),
      backgroundColor: Colors.lightGreenAccent.withOpacity(0.4),
      textStyle: const TextStyle(
          color: Colors.black
      ),
      context: context,
      alignment: Alignment.topCenter,
      animation: StyledToastAnimation.slideFromBottom,
      isHideKeyboard: true,
    );
  }
}
