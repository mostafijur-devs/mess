import 'package:flutter/material.dart';

snackBarMassage( BuildContext context, {required String massage}){

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(massage),));

}