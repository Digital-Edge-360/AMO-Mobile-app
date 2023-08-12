import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 6,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(
                width: 26,
              ),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    overflow: TextOverflow.visible,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
