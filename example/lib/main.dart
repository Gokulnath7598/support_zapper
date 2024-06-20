import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:support_zapper/support_zapper.dart';
import 'error_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ExceptionHandler.initialize(
      organization: 'your_organization',
      project: 'your_project',
      accessToken: 'your_token',
      userDetails: {'name': 'test'});

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
                Navigator.push(context, MaterialPageRoute<dynamic>(
                  builder: (_) => const CustomError(),
                ));
              },
              child: const Text(
                'Create Custom Ticket',
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute<dynamic>(
                  builder: (_) => const RenderError(),
                ));
              },
              child: const Text(
                'Render Issue',
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute<dynamic>(
                  builder: (_) => const NullError(),
                ));
              },
              child: const Text(
                'Null Issue',
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                throw DioException(
                  requestOptions: RequestOptions(
                    path:
                    'https://unauthorized-exception-simulation-endpoint.com',
                  ),
                  response: Response(
                    requestOptions: RequestOptions(),
                    statusCode: 401,
                    statusMessage: 'Unauthorized',
                    data: {
                      'message': 'Unauthorized',
                    },
                  ),
                );
              },
              child: const Text(
                '404',
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                throw DioException(
                  requestOptions: RequestOptions(
                    path:
                    'https://unauthorized-exception-simulation-endpoint.com',
                  ),
                  response: Response(
                    requestOptions: RequestOptions(),
                    statusCode: 500,
                    statusMessage: 'Unauthorized',
                    data: {
                      'message': 'Unauthorized',
                    },
                  ),
                );
              },
              child: const Text(
                '500',
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute<dynamic>(
                  builder: (_) => const ImageURlError(),
                ));
              },
              child: const Text(
                'Image URL Error',
              ),
            ),
          ),
        ],
      ),
    );
  }
}