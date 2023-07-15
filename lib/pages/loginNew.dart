import 'package:flutter/material.dart';
import 'package:frigami/utils/impact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:frigami/pages/signUp.dart';
import 'package:frigami/pages/recoveryPage.dart';
import 'package:frigami/pages/welcomePage.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:frigami/repositories/preferences.dart';
import 'package:provider/provider.dart';

import 'package:frigami/models/calories.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:frigami/utils/globals.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


class NewLogin extends StatefulWidget {
  NewLogin({Key? key}) :
    super(key: key);
    static const routename = 'Login';

   @override
  _NewLoginState createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {//serve lo stato??
  final formKey = GlobalKey<FormState>();
  
  TextEditingController emailController = TextEditingController(); //A controller in our context is used to read the values from the input. Using a controller, you'll be able to control its associated component.
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
    

              // LOGIN
                Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()){
                        var user = await Provider.of<DatabaseRepository>(context, listen: false).findUserByCredentials(emailController.text, passwordController.text);
                        print('SNAPSHOT: $user'); // PER DEBUG
                          if (user != null){ // salvo sp e vado welcome page
                          //SharedPreferences sp1 = await SharedPreferences.getInstance();
                          //sp1.setString('password', user.password);
                          //sp1.setString('username', user.username);
                          //sp1.setInt('id', user.id!);
                          var pref = Provider.of<Preferences>(context, listen: false); 
                          pref.setPassword(user.password);
                          pref.setUsername(user.username);
                          pref.setUserId(user.id!);
                          
                          //Preferences().setPassword(user.password);
                          //Preferences().setUsername(user.username);
                          //Preferences().setUserId(user.id!);
                          
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
                          //Navigator.push(context,PageRouteBuilder(
                            //transitionDuration: Duration(milliseconds: 500),
                            //pageBuilder: (_, __, ___) => WelcomePage(),
                            //transitionsBuilder: (_, animation, __, child) {
                            //return FadeTransition(
                              //opacity: animation,
                              //child: child,
                              //);
                            //},
                          //), MaterialPageRoute(builder: (context)),);
                          } else {
                            SnackBar snackBar = SnackBar(content: Text('Wrong credentials! Try again.'));
                            snackbarKey.currentState?.showSnackBar(snackBar);

                            //await _showAlertDialog();
                              
                          } // if

                      }
                    },
                    child: const Text('LOGIN'),
                  ),
                ),
              ),

               Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: const Text('Don\'t u have an account? Sign up!'),
                  ),
                ),
              ),


              // RECOVERY
                 Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RecoveryPage()));
                    },
                    child: const Text('Recover credentials with ID!'),
                  ),
                ),
              ),
                ]
          ))  
            
          ),
            )
          ),
        );
      
    
  }
  



// volendo, per alcune info ...
// https://www.freecodecamp.org/news/how-to-build-a-simple-login-app-with-flutter/



  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Wrong credentials.'),
                Text('Try with others.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

}