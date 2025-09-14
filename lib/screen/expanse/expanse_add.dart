import 'package:flutter/material.dart';
import 'package:mass/models/expanse.dart';
import 'package:mass/provider/expanse_provider.dart';
import 'package:mass/utils/some_custom_List.dart';
import 'package:provider/provider.dart';

import '../../models/member.dart';
import '../../provider/member_provider.dart';
import '../../utils/common_helper_function.dart';

class ExpanseAdd extends StatefulWidget {
  const ExpanseAdd({super.key, required this.isEdit, this.expanse});

  final bool isEdit;
  final Expanse? expanse;

  @override
  State<ExpanseAdd> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<ExpanseAdd> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _category;
  DateTime? _expanseDate;
  int? _memberId;
  List<Member>? listMember;

  @override
  void initState() {
    super.initState();
    listMember = context.read<MemberProvider>().members;

    if (widget.isEdit) {
      setState(() {
        _category = widget.expanse!.category;
        _descriptionController.text = widget.expanse!.description ?? '';
        _amountController.text = widget.expanse!.amount.toString();
        _dateController.text = dateFormat(
          date: widget.expanse!.dateTime ?? DateTime.now(),
        );
        _memberId = widget.expanse!.memberId ?? 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit
            ? const Text('Edit Expense')
            : const Text('Add Expense'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          child: Builder(
            builder: (context) {
              return ListView(
                children: [
                  DropdownButtonFormField(
                    hint: Text('Please selected a member'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // hintText: 'Selected member',
                      labelText: 'Selected Member',
                    ),
                    value: _memberId,
                    items:
                        listMember
                            ?.map(
                              (member) => DropdownMenuItem(
                                value: member.id,
                                child: Text(member.name ?? ''),
                              ),
                            )
                            .toList() ??
                        [],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _memberId = value as int?;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select a member who paid";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Please selected a category',
                      labelText: 'Category',
                    ),
                    value: _category,
                    items: expenseCategoryList
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _category = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please selected a category';
                      }
                      return null;
                    },
                  ),
                  // SizedBox(height: 20),
                  //
                  // ExpansionTile(title: Text('more details'),
                  // children: [
                  //
                  // ],),
                  // ExpansionTile(
                  //   title: const Text("More Details"),
                  //   leading: const Icon(Icons.expand_more),
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: TextFormField(
                  //         decoration: const InputDecoration(
                  //           labelText: "Expense Amount",
                  //           border: OutlineInputBorder(),
                  //         ),
                  //         keyboardType: TextInputType.number,
                  //         validator: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return "Amount is required";
                  //           }
                  //           if (double.tryParse(value) == null) {
                  //             return "Enter a valid number";
                  //           }
                  //           return null;
                  //         },
                  //         onSaved: (value) => expenseAmount = double.tryParse(value!),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'description',
                      hintText: 'Enter your description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                      hintText: 'Enter your Amount ',
                    ),
                    validator: (value) {
                      if (int.tryParse(value!) == null) {
                        if (value.isEmpty) {
                          return 'Please enter your Amount';
                        }

                        return 'String value note allow';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    // initialValue: dateFormat(date: _expanseDate!),
                    readOnly: true,
                    // initialValue: ,
                    controller: _dateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                      hintText: 'Please select a date',
                    ),
                    onChanged: (newValue) {
                      // setState(() {
                      //   _expanseDate = DateTime.parse(newValue ?? '');
                      // });
                    },
                    onTap: () async {
                      datePickerFunction(context: context);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    // onPressed: _saveExpanse,
                    onPressed: () => _saveExpanse(context),
                    child: widget.isEdit
                        ? const Text('Edit Expense')
                        : const Text('Add Expense'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _category = '';
    _descriptionController.dispose();
    _amountController.dispose();
  }

  datePickerFunction({required BuildContext context}) async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dateTime != null) {
      setState(() {
        _expanseDate = dateTime;
        _dateController.text = dateFormat(date: dateTime);
      });
    }
  }

  void _saveExpanse(BuildContext context) {
    if (Form.of(context).validate()) {
      Expanse expanse = Expanse(
        memberId: _memberId,
        amount: int.parse(_amountController.text),
        description: _descriptionController.text,
        category: _category,
        dateTime: _expanseDate,
      );
      if (widget.isEdit) {
        expanse.id = widget.expanse?.id;
        context.read<ExpanseProvider>().updateExpanse(expanse);
        snackBarMassage(context, massage: 'Expense updated successfully');
        Navigator.pop(context);
      } else {
        context.read<ExpanseProvider>().addExpanse(expanse);
        snackBarMassage(context, massage: 'Expense added successfully');
        Navigator.pop(context);
      }
    } else {
      snackBarMassage(context, massage: 'Please fill all the fields');
    }
  }
}
