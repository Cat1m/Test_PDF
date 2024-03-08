import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

class PdfApi {
  static Future<File> generateCenteredText() async {
    final pdf = Document();

    final font = await rootBundle.load('assets/OpenSans-Regular.ttf');
    final ttf = Font.ttf(font);

    pdf.addPage(Page(
      build: (context) => Center(
          child:
              Text('hello world', style: TextStyle(fontSize: 30, font: ttf))),
    ));

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    final uri = Uri.file(url).toString();

    try {
      print(2);
      await OpenFile.open(uri);
    } catch (e) {
      print('Lỗi khi mở tệp: $e');
    }
  }
}
