import 'package:flutter/material.dart';
import 'package:mass/provider/expanse_provider.dart';
import 'package:mass/utils/pdf_helper.dart';
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../utils/common_helper_function.dart';



class ExpanseReportPage extends StatelessWidget {
  const ExpanseReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final expanseList = Provider.of<ExpanseProvider>(context).expanseList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expanse Report'),
        actions: [
          IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Export PDF',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ExpanseReport(),));

          },)
        ],
      ),
      body: expanseList.isEmpty
          ? const Center(child: Text('No data'))
          : ListView.builder(
        itemCount: expanseList.length,
        itemBuilder: (context, index) {
          final exp = expanseList[index];
          return ListTile(
            title: Text(exp.category ?? ''),
            subtitle: Text(exp.description ?? ''),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Amount: ${exp.amount ?? 0}'),
                Text('Date: ${dateFormat(date: exp.dateTime ?? DateTime.now()  )}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}


class ExpanseReport extends StatelessWidget {
  const ExpanseReport({super.key});

  @override
  Widget build(BuildContext context) {
    final expanseList = Provider.of<ExpanseProvider>(context).expanseList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expanse Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () async {
              final filePath = await saveExpansePdfToFile(expanseList);
              if (filePath != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PDF Saved: $filePath')),
                );
                // ফোনে PDF ওপেন করো
                await OpenFile.open(filePath);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Permission denied or error!')),
                );
              }
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => generateExpansePdf(expanseList),
      ),
    );
  }
}
