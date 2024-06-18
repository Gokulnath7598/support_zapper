import 'package:flutter/material.dart';
import 'package:support_zapper/support_zapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ExceptionHandler.initialize(
      organization: 'veera4701',
      project: 'SupportZapper',
      accessToken: 'fcob4kn66ggtwm4rviplflj2gfu7nfq4czexb54ckfehgcqsh3vq',
      userDetails: {'name': 'Gokulnath'});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Support Zapper Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support Zapper Demo',
        ),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                ExceptionHandler.createTicket(message: 'Test Custom Ticket');
              },
              child: const Text(
                'Create Custom Ticket',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
