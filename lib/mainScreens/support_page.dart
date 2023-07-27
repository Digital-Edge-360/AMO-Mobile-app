import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              InkWell(
                  onTap: () {
                    makePhoneCall();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "78-11-822-499",
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.call)
                    ],
                  )),
              const Text(
                'Support Phone Number:',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> makePhoneCall() async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: "7811822499",
  );
  await launchUrl(launchUri);
}
