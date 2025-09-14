import 'dart:io';
import 'dart:typed_data';
import 'package:mass/models/expanse.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateExpansePdf(List<Expanse> expanseList) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Expanse Report', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Category', 'Description', 'Amount', 'Date'],
            data: expanseList.map((e) => [
              e.category ?? '',
              e.description ?? '',
              e.amount?.toString() ?? '',
              e.dateTime ?? '',
            ]).toList(),
          ),
        ],
      ),
    ),
  );

  return pdf.save();
}

Future<String?> saveExpansePdfToFile(List<Expanse> expanseList) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Expanse Report', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Category', 'Description', 'Amount', 'Date'],
            data: expanseList.map((e) => [
              e.category ?? '',
              e.description ?? '',
              e.amount?.toString() ?? '',
              e.dateTime ?? '',
            ]).toList(),
          ),
        ],
      ),
    ),
  );

  // ডাউনলোড ফোল্ডার বের করো
  Directory? directory;
  if (Platform.isAndroid) {
    directory = Directory('/storage/emulated/0/Download');
  } else {
    directory = await getApplicationDocumentsDirectory();
  }

  String filePath = '${directory.path}/expanse_report.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return filePath;
}