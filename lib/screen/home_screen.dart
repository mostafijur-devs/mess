
import 'package:flutter/material.dart';
import 'package:mass/screen/member/member_screen.dart';
import 'expanse/expanse_page.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'), centerTitle: true),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MemberScreen()),
              );
            },
            autofocus: true,
            child: Text('Member page'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpansePage()),
              );
            },
            child: Text('Expanse page'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
