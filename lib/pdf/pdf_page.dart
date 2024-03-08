import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:test_pdf_viewer/utils/utils.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<MyData> dataList = [
      MyData('Title 1', 'Content 1'),
      MyData('Title 2', 'Content 2'),
      MyData('Title 3', 'Content 3'),
    ];
    //pw.RichText.debug = true;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text('PDF'),
        ),
        body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(dataList[index].title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfPreviewPage(data: dataList[index]),
                  ),
                );
              },
            );
          },
        )

        // PdfPreview(
        //   previewPageMargin: const EdgeInsets.only(bottom: 5),
        //   initialPageFormat: PdfPageFormat.a4,
        //   useActions: false,
        //   build: (format) => generatePdf(format, dataList),
        // ),
        );
  }
}

class MyData {
  final String title;
  final String content;

  MyData(this.title, this.content);
}

class PdfPreviewPage extends StatelessWidget {
  final MyData data;

  const PdfPreviewPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(data.title),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'save',
                child: ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text('Tải file'),
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Chia sẻ'),
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'save') {
                if (value == 'save') {
                  final bytes = await generatePdf(PdfPageFormat.a4, [data]);
                  await savePdfFileToDownload(bytes);
                }

                // Thêm mã để tải tài liệu PDF ở đây
              } else if (value == 'share') {
                final bytes = await generatePdf(PdfPageFormat.a4, [data]);
                Printing.sharePdf(bytes: bytes, filename: 'document.pdf');
                // Thêm mã để chia sẻ tài liệu PDF ở đây
              }
            },
          ),
        ],
      ),
      body: PdfPreview(
        pdfPreviewPageDecoration:
            BoxDecoration(color: Colors.white, shape: BoxShape.rectangle),
        previewPageMargin: EdgeInsets.fromLTRB(0, 20, 0, 0),
        initialPageFormat: PdfPageFormat.a4,
        useActions: false,
        build: (format) => generatePdf(format, [data]),
      ),
    );
  }
}
