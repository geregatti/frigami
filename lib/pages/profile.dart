import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/entities/users.dart';
import '../repositories/databaseRepositories.dart';
import '../repositories/preferences.dart';
import 'package:frigami/pages/modifyProfilePage.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, required this.messageFromFridge}) : super(key: key);
  final messageFromFridge;
  static const route = '/';
  static const routename = 'UserPage';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  int? radioValue;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Users user = widget.messageFromFridge;
    String gender = user.gender!;
    int weight = user.weight!;
    int height = user.height!;
    double base = height / 100;
    double bmi = (weight / (base * base));
    bmi.toStringAsFixed(2);

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
                          children: [
                            Text(
                              'GENDER: ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              '$gender',
                              style: TextStyle(fontSize: 20.0),
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
                            Text(
                              '$weight',
                              style: TextStyle(fontSize: 20.0),
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
                            Text(
                              '$height',
                              style: TextStyle(fontSize: 20.0),
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
                    SizedBox(
                      width: 400,
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              'BMI: ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              '$bmi',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              ' kg/m^2',
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // "Modify your Data" button
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ModifyProfilePage(messageFromFridge: null,)),
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Modify your Data'),
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
}
