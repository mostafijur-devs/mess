import 'package:flutter/material.dart';
import 'package:mass/provider/expanse_provider.dart';
import 'package:mass/provider/member_provider.dart';
import 'package:mass/screen/home_screen.dart';
import 'package:mass/services/expanse_data_function.dart';
import 'package:mass/services/member_data_function.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              MemberProvider(memberRepository: MemberDataFunction()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ExpanseProvider(expanseRepository: ExpanseDataFunction()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
