import 'package:flutter/material.dart';
import 'package:support_zapper/support_zapper.dart';



class RenderError extends StatelessWidget {
  const RenderError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(height: 1000,)
        ],
      ),
    );
  }
}

String? text;

class NullError extends StatelessWidget {
  const NullError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(text!)
        ],
      ),
    );
  }
}

class CustomError extends StatefulWidget {
  const CustomError({super.key});

  @override
  State<CustomError> createState() => _CustomErrorState();
}

class _CustomErrorState extends State<CustomError> {

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: textController
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    int? id = await ExceptionHandler.createTicket(message: textController.text);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                      content: Text(
                        'Support Ticket created ref ID: $id',
                      ),
                    ));
                  },
                  child: const Text(
                    'Create Custom Ticket',
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

class ImageURlError extends StatelessWidget {
  const ImageURlError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.network('https://testimage.com')
        ],
      ),
    );
  }
}
