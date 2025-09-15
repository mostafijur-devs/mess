import 'package:flutter/material.dart';
import 'package:mass/provider/expanse_provider.dart';
import 'package:mass/provider/member_provider.dart';
import 'package:mass/screen/expanse/expanse_add.dart';
import 'package:mass/screen/expanse/expanse_report.dart';
import 'package:mass/utils/common_helper_function.dart';
import 'package:provider/provider.dart';

class ExpansePage extends StatefulWidget {
  const ExpansePage({super.key});

  @override
  State<ExpansePage> createState() => _ExpansePageState();
}

class _ExpansePageState extends State<ExpansePage> {
  DateTime? _selectedDate;
  int? _selectedYear;
  int? _selectedMonth;

  String formattedDate =
      "${DateTime.now().year.toString().padLeft(4, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";


  @override
  void initState() {
    super.initState();
    // শুরুতে সব ডেটা লোড
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemberProvider>().fetchMember();
      context.read<ExpanseProvider>().fetchExpanseByDate(formattedDate);

      // Provider.of<ExpanseProvider>(context, listen: false).fetchExpanseByDate(DateTime.now().toIso8601String());
    });
  }

  @override
  Widget build(BuildContext context) {
    final expanseProvider = Provider.of<ExpanseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expanse Filter'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Report',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExpanseReportPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'সব ডেটা দেখাও',
            onPressed: () {
              setState(() {
                _selectedDate = null;
                _selectedYear = null;
                _selectedMonth = null;
              });
              context.read<ExpanseProvider>().fetchExpanseByDate(formattedDate);

            },
          ),
        ],
      ),
      body: Column(
        children: [
          // তারিখ ও মাস ফিল্টার বাটন
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: const Text('তারিখ'),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                        _selectedYear = null;
                        _selectedMonth = null;
                      });
                      String formattedDate =
                          "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      await expanseProvider.fetchExpanseByDate(formattedDate);
                    }
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('মাস'),
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    // শুধু মাস ও বছর সিলেক্ট করার জন্য showDatePicker ব্যবহার
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(
                        _selectedYear ?? now.year,
                        _selectedMonth ?? now.month,
                      ),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      selectableDayPredicate: (date) => date.day == 1,
                      helpText: 'শুধু মাস ও বছর সিলেক্ট করুন',
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedYear = picked.year;
                        _selectedMonth = picked.month;
                        _selectedDate = null;
                      });
                      await expanseProvider.fetchExpanseByMonth(
                        picked.year,
                        picked.month,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'সিলেক্টেড তারিখ: ${_selectedDate!.toLocal()}'.split(' ')[0],
              ),
            ),
          if (_selectedYear != null && _selectedMonth != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('সিলেক্টেড মাস: $_selectedYear-$_selectedMonth'),
            ),

          Text('This is your current Day Expanse ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          Expanded(
            child: expanseProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: expanseProvider.expanseList.length,
                    itemBuilder: (context, index) {
                      final expanse = expanseProvider.expanseList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: ListTile(
                          title: Text(expanse.category ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(expanse.description ?? ''),
                              Text('Amount: ${expanse.amount ?? 0}'),
                              Text('Date: ${dateFormat(date: expanse.dateTime ?? DateTime.now()  )}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ধরো, MemberProvider দিয়ে চেক করবে
          final memberList = Provider.of<MemberProvider>(
            context,
            listen: false,
          ).members;
          if (memberList.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('প্রথমে একজন মেম্বার যোগ করুন!')),
            );
            return;
          }
          // Navigator.pushNamed(context, '/expanse_add');
          // অথবা:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ExpanseAdd(isEdit: false)),
          );
        },
        tooltip: 'Add Expanse',
        child: const Icon(Icons.add),

      ),
    );
  }
}
