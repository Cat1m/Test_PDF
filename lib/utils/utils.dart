import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:test_pdf_viewer/pdf/pdf_page.dart';
import 'package:test_pdf_viewer/utils/my_category.dart';
import 'package:test_pdf_viewer/utils/url_text.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Uint8List> generatePdf(
    final PdfPageFormat format, List<MyData> dataList) async {
  final doc = pw.Document(
    title: 'Toa thuốc',
  );

  final logoImage = pw.MemoryImage(
    (await rootBundle.load('assets/logo_honghung.png')).buffer.asUint8List(),
  );

  final font = await rootBundle.load('assets/OpenSans-Regular.ttf');
  final ttf = pw.Font.ttf(font);

  final pageTheme = await _myPageTheme(format);

  for (int i = 0; i < dataList.length; i++) {
    final data = dataList[i];

    doc.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(data.title,
                    style: pw.TextStyle(font: ttf, fontSize: 20)),
                pw.SizedBox(height: 20),
                pw.Text(data.content,
                    style: pw.TextStyle(font: ttf, fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }

  // doc.addPage(
  //   pw.MultiPage(
  //     pageTheme: pageTheme,
  //     header: (final context) => pw.Image(
  //       alignment: pw.Alignment.topLeft,
  //       logoImage,
  //       fit: pw.BoxFit.contain,
  //       width: 100,
  //     ),
  //     footer: (final context) =>
  //         pw.Text('BV Hồng Hưng xin cám ơn', style: pw.TextStyle(font: ttf)),
  //     build: (final context) => [
  //       pw.Container(
  //         padding: const pw.EdgeInsets.only(
  //           left: 30,
  //           bottom: 20,
  //         ),
  //         child: pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.center,
  //           mainAxisAlignment: pw.MainAxisAlignment.start,
  //           children: [
  //             pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
  //             pw.Row(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                   children: [
  //                     pw.Text('Phone: ${dataList[0].content}',
  //                         style: pw.TextStyle(font: ttf)),
  //                     pw.Text('Email: ${dataList[0].title}',
  //                         style: pw.TextStyle(font: ttf)),
  //                     pw.Text('Tên Bệnh Nhân:', style: pw.TextStyle(font: ttf)),
  //                   ],
  //                 ),
  //                 pw.SizedBox(width: 70),
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                   children: [
  //                     pw.Text('0359509252'),
  //                     UrlText(
  //                       text: 'CaT1m',
  //                       url: 'ArcaRyze@gmail.com',
  //                     ),
  //                   ],
  //                 ),
  //                 pw.SizedBox(width: 70),
  //                 pw.BarcodeWidget(
  //                   data: ' lê Minh Chiến',
  //                   width: 40,
  //                   height: 40,
  //                   barcode: pw.Barcode.qrCode(),
  //                   drawText: false,
  //                 ),
  //                 pw.Padding(padding: pw.EdgeInsets.zero)
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       pw.Center(
  //         child: pw.Text(
  //           'Toa Thuốc',
  //           textAlign: pw.TextAlign.center,
  //           style: pw.TextStyle(
  //             font: ttf,
  //             fontSize: 30,
  //             fontWeight: pw.FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //       pw.Align(
  //         alignment: pw.Alignment.centerLeft,
  //         child: MyCategory(
  //           title: 'Thông tin toa thuốc:',
  //           font: ttf,
  //         ),
  //       ),
  //       pw.Paragraph(
  //           margin: const pw.EdgeInsets.only(top: 10),
  //           text:
  //               "Ryze chỉ là một pháp sư tập sự khi lần đầu biết tới thứ quyền năng bí ẩn đã định hình thế giới này.Sư phụ ông, một pháp sư tên Tyrus Xứ Helia, là thành viên một hội kín cổ xưa có nhiệm vụ thu thập và bảo vệ những cổ vật nguy hiểm nhất Runeterra. Ryze nghe lỏm được Tyrus thì thầm nói chuyện với một pháp sư khác về thứ gì đó gọi là “Cổ Ngữ Thế Giới”. Khi Tyrus nhận thấy sự có mặt của người học trò, ông cắt ngang cuộc đối thoại và nắm chặt lấy cuộn giấy chưa bao giờ rời khỏi ông nửa bước.Mặc cho mọi nỗ lực của hội, tin tức về Cổ Ngữ bắt đầu lan truyền—thậm chí một số người còn bắt đầu hiểu được tầm quan trọng của chúng, hay nguồn năng lượng to lớn ẩn giấu bên trong, nhưng họ đều coi chúng là thứ vũ khí dùng để chống lại kẻ địch. Ryze và Tyrus đi khắp Valoran, cố gắng xua đi những ảo tưởng và khuyến khích mọi người kiềm chế lại. Nhưng dần dần, những nhiệm vụ của họ ngày một bấp bênh hơn, và Ryze cảm nhận được nỗi tuyệt vọng lớn lên trong lòng sư phụ. Cuối cùng, trên vùng đất Noxii nơi Ryze sinh ra, cơn đại chấn đầu tiên đã thổi bùng ngọn lửa Chiến Tranh Cổ Ngữ.Hai quốc gia đối đầu nhau, căng thẳng lên đến cực độ. Tyrus khẩn cầu hai vị thủ lĩnh đàm phán ở làng Khom, nhưng ông thấy xung đột đã leo thang ngoài tầm hòa giải. Chạy thục mạng lên đồi, ông và Ryze bàng hoàng chứng kiến sức mạnh hủy diệt của Cổ Ngữ Thế Giới.Mặt đất xung quanh họ sụp đổ, cả đại địa như đang oằn mình kêu rên, bầu trời co rúm lại như thể trúng vết thương chí mạng. Họ nhìn lại thung lũng nơi hai đội quân từng đứng, và cảm thấy điên cuồng—quy mô của sự hủy diệt đã thách thức mọi lẽ thường. Con người, nhà cửa, tất cả đều biến mất, và đại dương phía Đông vốn cách đó một ngày đường đang ập đến chỗ họ.Ryze quỳ sụp xuống, nhìn chăm chăm vào cái hố lớn vừa bị xé toạc ra trên bề mặt thế giới. Không còn lại gì. Kể cả ngôi làng quê hương ông.",
  //           style: pw.TextStyle(
  //             font: ttf,
  //             lineSpacing: 8,
  //             fontSize: 16,
  //           ))
  //     ],
  //   ),
  // );
  return doc.save();
}

// Tạo một theme với font từ Google Fonts

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  //final font = await rootBundle.load('assets/OpenSans-Regular.ttf');
  //final ttf = pw.Font.ttf(font);

  return pw.PageTheme(
    margin: const pw.EdgeInsets.symmetric(
        horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
    buildBackground: (final context) => pw.FullPage(
      ignoreMargins: false,
      // child: pw.Watermark(
      //   angle: 20,
      //   child: pw.Opacity(
      //       opacity: 0.5,
      //       child: pw.Text('Bệnh Viện Hồng Hưng',
      //           style: pw.TextStyle(font: ttf, fontSize: 50))),
      // ),
    ),
  );
}

Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

Future<void> savePdfFileToDownload(final Uint8List pdfBytes) async {
  // Request storage permission if not already granted
  final storageStatus = await Permission.storage.request();
  if (!storageStatus.isGranted) {
    throw Exception('Storage permission is required to save files.');
  }

  // Get the download directory path
  final downloadDirectory = await getDownloadsDirectory();
  if (downloadDirectory == null) {
    throw Exception('Failed to get the download directory path.');
  }

  // Create a unique file name with timestamp
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = 'document_$timestamp.pdf';
  final file = File('${downloadDirectory.path}/$fileName');

  print('Saving PDF to download folder: ${file.path}');
  await file.writeAsBytes(pdfBytes);

  // Open the saved PDF file
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('In thành công')));
}

void showsharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Chia sẻ thành công')));
}
