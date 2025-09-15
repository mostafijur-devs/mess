import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mass/models/member.dart';
import 'package:provider/provider.dart';

import '../../provider/member_provider.dart';
import '../../utils/common_helper_function.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key, required this.isEdit, this.member});

  final bool isEdit;
  final Member? member;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  // final TextEditingController _passwordController = TextEditingController();

  File? _imagePath;

   bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _nameController.text = widget.member!.name!;
      _emailController.text = widget.member!.email!;
      _phoneController.text = widget.member!.phone!;
      _imagePath = widget.member?.memberImageUrl != null ?File(widget.member!.memberImageUrl!): null ;
    }
  }

  Future<void> _imagePickByCamera() async {
    setState(() {
      _isLoading = true;
    });

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imagePath = File(pickedFile.path);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _imagePickByGallery() async {
    setState(() {
      _isLoading = true;
    });

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = File(pickedFile.path);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit
            ? const Text('Edit Member')
            : const Text('Add Member'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  PopupMenuButton(
                    icon:_isLoading? CircularProgressIndicator():_imagePath != null ?Image.file(_imagePath!,height: 100,width: 100,): Icon(Icons.person, size: 100),

                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Text('Camera'),
                          onTap: () async{
                            Future.delayed(Duration.zero, () async{

                              await _imagePickByCamera();


                            },);

                          },
                        ),
                        PopupMenuItem(
                          child:  Text('Gallery'),

                          onTap: () async{
                      Future.delayed(Duration.zero, () async{
                      await _imagePickByGallery();

                      },);

                      },
                        ),
                      ];
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
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
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@gmail')) {
                        return 'Please enter a valid @gmail code';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value[0] != '0') {
                        return 'Please enter your phone number';
                      } else if (value.length > 11) {
                        return 'your phone number length ${value.length} is too long';
                      } else if (value.length < 11) {
                        return 'your phone number length ${value.length} is too short ';
                      }

                      return null;
                    },
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
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      if (Form.of(context).validate()) {
                        Member member = Member(
                          name: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          memberImageUrl: _imagePath!.path
                        );
                        if (widget.isEdit) {
                          member.id = widget.member!.id;
                          context.read<MemberProvider>().updateMember(member);
                          snackBarMassage(
                            context,
                            massage: 'Member updated successfully',
                          );
                          Navigator.pop(context);
                        } else {
                          context.read<MemberProvider>().addMembers(member);
                          snackBarMassage(
                            context,
                            massage: 'Member added successfully',
                          );
                          Navigator.pop(context);
                        }
                      }
                      snackBarMassage(
                        context,
                        massage: 'Please fill all the fields',
                      );
                    },
                    child: widget.isEdit
                        ? const Text('Edit Member')
                        : const Text('Add Member'),
                  ),

                  SizedBox(height: 20),

                  _imagePath != null
                      ? Image.file(
                          _imagePath!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        )
                      : Text(''),
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
  }
}
