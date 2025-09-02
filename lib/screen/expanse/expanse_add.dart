import 'package:flutter/material.dart';
import 'package:mass/models/expanse.dart';
import 'package:mass/provider/expanse_provider.dart';
import 'package:provider/provider.dart';

import '../../models/member.dart';
import '../../provider/member_provider.dart';
import '../../utils/common_helper_function.dart';

class ExpanseAdd extends StatefulWidget {
  const ExpanseAdd({super.key, required this.isEdit, this.expanse, this.member});
  final bool isEdit;
  final Expanse? expanse;
  final Member? member;

  @override
  State<ExpanseAdd> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<ExpanseAdd> {
  final TextEditingController _categoryController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  // final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isEdit){
      _categoryController.text = widget.expanse!.category!;
      _descriptionController.text = widget.expanse!.description!;
      _amountController.text = widget.expanse!.amount! as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit ?const Text('Edit Expense') : const Text('Add Expense'),
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
                        controller:_categoryController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Category',
                          hintText: 'Enter your Category',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Category';
                          }
                          return null;
                        }
                    ),
                    SizedBox(height: 20,),

                    TextFormField(
                        controller:_descriptionController,
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
                          // else if ( !value.contains('@gmail')){
                          //   return 'Please enter a valid @gmail code';
                          // }
                          // return null;
                        }
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                        controller:_amountController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Amount',
                          hintText: 'Enter your Amount ',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty ) {
                            return 'Please enter your Amount';
                          }
                          // else if(value.length >11){
                          //   return 'your phone number length ${value.length} is too long';
                          // }else if(value.length <11){
                          //   return 'your phone number length ${value.length} is too short ';
                          // }

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

                        Expanse expanse =Expanse(
                          memberId:widget.member?.id ?? 0,
                          amount : int.parse(_amountController.text),
                          description: _descriptionController.text,
                          category: _categoryController.text,
                        );
                        if(widget.isEdit ){
                          expanse.id = widget.expanse!.id;
                          context.read<ExpanseProvider>().updateExpanse(expanse);
                          snackBarMassage(context, massage: 'Expense updated successfully');
                          Navigator.pop(context);
                        }else{
                          context.read<ExpanseProvider>().addExpanse(expanse);
                          snackBarMassage(context, massage: 'Expense added successfully');
                          Navigator.pop(context);
                        }


                      }
                      snackBarMassage(context,massage: 'Please fill all the fields');

                    }, child:widget.isEdit? const Text('Edit Expense') : const Text('Add Expense'))


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
    _categoryController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
  }
}
