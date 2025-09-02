import 'package:flutter/material.dart';
import 'package:mass/models/member.dart';
import 'package:provider/provider.dart';

import '../../provider/member_provider.dart';
import '../../utils/common_helper_function.dart';

class AddMemberScreen extends StatefulWidget {
  AddMemberScreen({super.key, required this.isEdit, this.member});
  bool isEdit;
  Member? member;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  // final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isEdit){
      _nameController.text = widget.member!.name!;
      _emailController.text = widget.member!.email!;
      _phoneController.text = widget.member!.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit ?const Text('Edit Member') : const Text('Add Member'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Form(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  TextFormField(
                    controller:_nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter your name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    }
                  ),
                  SizedBox(height: 20,),

                  TextFormField(
                      controller:_emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        else if ( !value.contains('@gmail')){
                          return 'Please enter a valid @gmail code';
                        }
                        return null;
                      }
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                      controller:_phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value[0] != '0' ) {
                          return 'Please enter your phone number';
                        }else if(value.length >11){
                          return 'your phone number length ${value.length} is too long';
                        }else if(value.length <11){
                          return 'your phone number length ${value.length} is too short ';
                        }

                        return null;
                      }
                  ),
                  // TextFormField(
                  //     controller:_nameController,
                  //     decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: 'Name',
                  //       hintText: 'Enter your name',
                  //     ),
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please enter your name';
                  //       }
                  //       return null;
                  //     }
                  // ),
                  // TextFormField(
                  //     controller:_nameController,
                  //     decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: 'Name',
                  //       hintText: 'Enter your name',
                  //     ),
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please enter your name';
                  //       }
                  //       return null;
                  //     }
                  // ),
                  SizedBox(height: 20,),

                  ElevatedButton(onPressed: () {
                    if(Form.of(context).validate()){

                      Member member =Member(
                        name: _nameController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                      );
                      if(widget.isEdit){
                        member.id = widget.member!.id;
                        context.read<MemberProvider>().updateMember(member);
                        snackBarMassage(context, massage: 'Member updated successfully');
                        Navigator.pop(context);
                      }else{
                        context.read<MemberProvider>().addMembers(member);
                        snackBarMassage(context, massage: 'Member added successfully');
                        Navigator.pop(context);
                      }


                    }
                    snackBarMassage(context,massage: 'Please fill all the fields');

                  }, child:widget.isEdit? const Text('Edit Member') : const Text('Add Member'))


                ],
              );
            }
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
  }
}
