import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frigami/pages/fridge.dart';
import 'package:frigami/repositories/preferences.dart';
import 'package:provider/provider.dart';

import '../database/entities/users.dart';
import '../repositories/databaseRepositories.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Timer _timer;
  bool _showWelcomeMessage = true;

  final formKey = GlobalKey<FormState>();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  int? radioValue;


  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _startTimer() async {
    var pref = Provider.of<Preferences>(context, listen: false);
    var id = pref.getUserId();
    var name = pref.getUsername();
    Users? user = await Provider.of<DatabaseRepository>(context, listen: false).findUserByIdAndName(id,name);
    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        if (user!.gender == null){
          _showWelcomeMessage = false;
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => FridgePage()));
        }

       
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showWelcomeMessage)
              Center(
                child: Image.asset('assets/welcome.png'),
              ),
            if (!_showWelcomeMessage)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('We need some informations to personalize the experience with Frigami. They won\'t be shared, but they will be stored only in your device. If you disinstall Frigami all your data will be lost!'),
                  Text('You will be able to change these informations later in your prifile page!'),
                  
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(width: 15),
                        const Text('Gender',
                            style: TextStyle(
                                color: Color(0xFF89453C), fontSize: 15)),
                        Radio(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => const Color(0xFF89453C)),
                          value: 0,
                          groupValue: radioValue,
                          onChanged: (val) {
                            setState(() { // CREARE TABELLA PERSONAL DATA E ISERIRE I DATI
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

                  SizedBox(height: 10),
                  
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Age'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                            return 'Please enter your age'; 
                          } else if (value != null) {
                            try {
                              int.parse(value);
                            } catch (e) {
                              return 'It should be a number';
                            }
                          }else{ //If there are no errors, the validator must return null
                            return null;
                          }
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: weightController,
                    decoration: InputDecoration(labelText: 'Weight'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                            return 'Please enter your weight'; 
                          } else if (value != null) {
                            try {
                              int.parse(value);
                            } catch (e) {
                              return 'It should be a number';
                            }
                          }else{ //If there are no errors, the validator must return null
                            return null;
                          }
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: heightController,
                    decoration: InputDecoration(labelText: 'Height'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                            return 'Please enter your height'; 
                          } else if (value != null) {
                            try {
                              int.parse(value);
                            } catch (e) {
                              return 'It should be a number';
                            }
                          }else{ //If there are no errors, the validator must return null
                            return null;
                          }
                    },
                  ),
                  
                  SizedBox(height: 20),
                  
                  ElevatedButton(
                    onPressed: () async {
                      String gender = '';
                      if (formKey.currentState!.validate()){ 
                        var pref = Provider.of<Preferences>(context, listen: false); 
                        int id = pref.getUserId();
                        String name = pref.getUsername();
                        String pass = pref.getPassword();
                        Users? user = await Provider.of<DatabaseRepository>(context, listen: false).findUserByIdAndName(id,name);
                          if (radioValue == 1) { 
                            gender = 'Female';} 
                          else { 
                            gender = 'Male';}
                        int height = int.parse(heightController.text);
                        int weight = int.parse(weightController.text);
                        Users newUser = Users(id, name, pass, gender, weight, height);
                        await Provider.of<DatabaseRepository>(context, listen: false).updateUsers(newUser);
                        await _showAllUsers();
                        
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FridgePage()));
                      }
                    },
                    child: Text('Start Frigami!'),
                  ),
                ],
              ),
          ],
        ),
      ),
      )
    );
  }

// PER DEBUG
  Future<void> _showAllUsers () async {
    String? name;
    String? pass;
    String? gender;
    int? ID;
    int? weight;
    int? height;

    var users = await Provider.of<DatabaseRepository>(context, listen: false).findAllUser();
    if (users.isNotEmpty){
      for (var user in users){
        ID = user!.id;
        name = user.username; //non possono essere nulli dato che li ho appena inseriti quindi non gestisco il caso
        pass = user.password;
        gender = user.gender;
        weight = user.weight;
        height = user.height;
        
        print('ID: $ID; Username: $name; Password: $pass; Gender: $gender; Weight: $weight; Height: $height.');
      }
    } else {print('FINDALLUSER NON RITORNA NULLA');}
  }//_showAllUsers



}