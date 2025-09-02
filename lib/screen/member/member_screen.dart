import 'package:flutter/material.dart';
import 'package:mass/screen/member/add_member_screen.dart';
import 'package:provider/provider.dart';

import '../../models/member.dart';
import '../../provider/member_provider.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MemberProvider>().fetchMember();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member'), centerTitle: true),
      body: Consumer<MemberProvider>(
        builder: (context, memberProvider, child) {
          List<Member>? member = memberProvider.members;
          return ListView.builder(
            itemBuilder: (context, index) {
              Member singleMember = member?[index] ?? Member();
              return _MemberView(
                member: singleMember,
                name: singleMember.name,
                email: singleMember.email,
                phone: singleMember.phone,
              );
            },
            itemCount: member?.length ?? 0,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMemberScreen(isEdit: false,)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _MemberView extends StatelessWidget {
  String? name;
  String? email;
  String? phone;
  Member? member;

  _MemberView({
    required this.name,
    required this.email,
    required this.phone,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(name?.toUpperCase() ?? ''),
                Text(email ?? ''),
                Text(phone ?? ''),
                Text(member?.personalAmount.toString() ?? '${0}'),
              ],
            ),
          ),
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
                            builder: (context) =>
                                AddMemberScreen(member: member, isEdit: true),
                          ),
                        );
                      },
                      child: Text('Edit'),
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        context.read<MemberProvider>().deleteMember(
                          member!.id!,
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
  }
}
