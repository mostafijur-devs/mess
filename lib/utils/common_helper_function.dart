import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void snackBarMassage( BuildContext context, {required String massage}){

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(massage),));

}

String dateFormat({ required DateTime date, String pattern = 'yyyy-MM-dd'}){
  return DateFormat(pattern).format(date);
}

Future<DateTime?> datePickerFunction({ required BuildContext context,required DateTime date})async{
 DateTime? dateTime= await showDatePicker(context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
  );
 if( dateTime != null){
   return dateTime;
 }
 return null;

}