import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/entities/users.dart';
import '../repositories/databaseRepositories.dart';
import '../repositories/preferences.dart';

class ModifyProfilePage extends StatefulWidget {
  ModifyProfilePage({Key? key, required this.messageFromFridge}) : super(key: key);
  final messageFromFridge;
  static const route = '/';
  static const routename = 'UserPage';

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  final _formKey = GlobalKey<FormState>();
int? radioValue;
  late TextEditingController _genderController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();

    Users user = widget.messageFromFridge;
    String gender = user.gender!;
    int weight = user.weight!;
    int height = user.height!;

    _genderController = TextEditingController(text: gender);
    _weightController = TextEditingController(text: weight.toString());
    _heightController = TextEditingController(text: height.toString());
  }

  @override
  void dispose() {
    _genderController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4DFD4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE4DFD4),
        iconTheme: const IconThemeData(color: Color(0xFF89453C)),
        title: const Text('Your Profile', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                    radius: 70,
                    child: Image.asset('assets/avatar.png'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: Center(
                        child: Row(



                          children: <Widget>[
                        const SizedBox(width: 15),
                        const Text('Gender',
                            style: TextStyle(
                                color: Color(0xFF89453C), fontSize: 15)),
                        Radio(
                          fillColor: MaterialStateColor.resolveWith((states) => const Color(0xFF89453C)),
                          value: 0,
                          groupValue: radioValue,
                          onChanged: (val) {
                            setState(() {
                              radioValue = val as int;
                            });
                          },
                        ),

                        const Text(
                          'Male',
                          style: TextStyle(fontSize: 15.0),
                        ),

                        Radio(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => const Color(0xFF89453C)),
                            value: 1,
                            groupValue: radioValue,
                            onChanged: (val) {
                              setState(() {
                                radioValue = val as int;
                              });
                            }),
                        const Text(
                          'Female',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ],



                            
                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              'WEIGHT: ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter your weight',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your weight';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Text(
                              ' kg',
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              'HEIGHT: ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter your height',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your height';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Text(
                              ' cm',
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _updateUserData();
                        }
                      },
                      child: Text('Update your Data'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {


    String gender = '';
  var pref = Provider.of<Preferences>(context, listen: false); 
    int id = pref.getUserId();
    String name = pref.getUsername();
    String pass = pref.getPassword();

    Users? user = await Provider.of<DatabaseRepository>(context, listen: false).findUserByIdAndName(id,name);
      if (radioValue == 1) { 
        gender = 'Female';} 
      else { 
      gender = 'Male';}
      int height = int.parse(_heightController.text);
      int weight = int.parse(_weightController.text);
      Users newUser = Users(id, name, pass, gender, weight, height);
      await Provider.of<DatabaseRepository>(context, listen: false).updateUsers(newUser);
      //await _showAllUsers();
                        
      Navigator.pop(context);
                    
    // Implement the logic to update the user data here
    // You can access the updated values using the _genderController, _weightController, and _heightController
    // For example, you can retrieve the updated gender value using _genderController.text
    // Update the user data accordingly
    // ...

    // Display a success message or perform any other necessary actions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User data updated')),
    );
  }
}
