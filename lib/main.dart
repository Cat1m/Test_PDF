import 'package:flutter/material.dart';
import 'package:test_pdf_viewer/pdf/pdf_api.dart';
import 'package:test_pdf_viewer/pdf/pdf_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/pdfPage': (context) => const PdfPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                print(1);
                final pdfFile = await PdfApi.generateCenteredText();
                print(pdfFile);
                await PdfApi.openFile(pdfFile);
              },
              child: const Text('my_example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pdfPage');
              },
              child: const Text('Go to PDF Page'),
            ),
          ],
        ),
      ),
    );
  }
}
