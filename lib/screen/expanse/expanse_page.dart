import 'package:flutter/material.dart';
import 'package:mass/models/member.dart';
import 'package:mass/provider/expanse_provider.dart';
import 'package:mass/provider/member_provider.dart';
import 'package:mass/screen/expanse/expanse_add.dart';
import 'package:provider/provider.dart';

import '../../models/expanse.dart';

class ExpansePage extends StatefulWidget {
  const ExpansePage({super.key});

  @override
  State<ExpansePage> createState() => _ExpansePageState();
}

class _ExpansePageState extends State<ExpansePage> {
  late Member members;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expanse'),
        centerTitle: true,
      ),
      body: Consumer2<ExpanseProvider, MemberProvider>(builder:(context, expanse, member, child) {
        List<Expanse> expanseList = expanse.expanseList;
        List<Member> memberList = member.members!;
        return
          ListView.builder(
            itemCount: expanseList.length,
            itemBuilder: (context, index) {
              Expanse expanse = expanseList[index];
              members = memberList[index];
              return Card(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(expanse.category ?? ''),
                        Text(expanse.description ?? ''),
                        Text(expanse.amount.toString() ?? '')
                      ],
                    ),
                    // IconButton(onPressed: () {
                    //
                    // }, icon: Icon(Icons.more_vert))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: PopupMenuButton(
                        child: Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>ExpanseAdd(isEdit: true,member: members,)

                                    ),
                                  );
                                },
                                child: Text('Edit'),
                              ),
                            ),
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () {
                                  context.read<ExpanseProvider>().deleteExpanse(
                                    expanse.id!,
                                  );
                                },
                                child: Text('Delete'),
                              ),
                            ),
                          ];
                        },
                      ),
                    ),

                  ],
                ),
              );
            },);
      },

        ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpanseAdd(isEdit: false,),));
      },child: Icon(Icons.add),),
    );
  }
}
