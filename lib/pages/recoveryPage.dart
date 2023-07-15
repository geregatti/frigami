import 'package:flutter/material.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:provider/provider.dart';
import 'package:frigami/database/entities/users.dart';
import 'package:frigami/pages/loginNew.dart';
import 'package:frigami/utils/globals.dart'; //per lo snackBar



class RecoveryPage extends StatefulWidget {
  RecoveryPage({Key? key}) : super(key: key);
    static const route = '/';
    static const routename = 'Recovery Page';

   @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  //mi servirà per la validazione dei form
  final formKey = GlobalKey<FormState>();

  //A controller in our context is used to read the values from the input. Using a controller, you'll be able to control its associated component.
  TextEditingController IdController = TextEditingController(); 
  TextEditingController emailController = TextEditingController(); 
  


  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RecoveryPage.routename),
      ),

      body: 
      
      Form(
        key: formKey,
        child: Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            return FutureBuilder(
              initialData: null,
              future: dbr.findUserByUsername(emailController.text), // CONTROLLO SE SI PUç TOGLERE MEGLIO
              builder:(context, snapshot){ 
                return Padding(   //The Form accepts a child. It can accept only one component.
                    //DA SISTEMARE tutti i padding (causa overflow)
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
                  child: Column( //This Padding widget also accepts only one child.
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Email or username"),
                        validator: (value) { //If the user’s input isn’t valid, the validator function returns a String containing an error message.
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username'; 
                          } else{ //If there are no errors, the validator must return null
                            return null;
                          }
                        },
                      ),
                    ),
                    

              
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: IdController,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "ID"),
                        validator: (value) { //If the user’s input isn’t valid, the validator function returns a String containing an error message.
                          
                          if (value == null || value.isEmpty) {
                            return 'Please enter the ID code that you recived during the registration'; 
                          } else if (value != null) {
                            try {
                              int code = int.parse(value);
                            } catch (e) {
                              return 'The ID code should be a number';
                            }
                          }else{ //If there are no errors, the validator must return null
                            return null;
                          }

                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
              
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          child: Text('RECOVER'),
                          onPressed:() async {
                            if (formKey.currentState!.validate()){ 

                            // PER DEBUG //////////////////////////////////////////
                          
                            //AlertDialog(
                                  //title: const Text('Registration excepion'),
                                  //String name = emailController.text;
                                  //content: const Text('cancellerò tutti gli users con nome utente: $name'),
                                  //actions: <Widget>[
                                    //TextButton(
                                    //onPressed: () => await Provider.of<DatabaseRepository>(context, listen: false).removeUser(user!);
                                    //child: const Text('OK'),
                                    //),
                                  //],
                                //);

                              
                                //await _deleteCredentials('g.g@g.com');
                                await _showAllUsers();
                            ////////////////////////////////
                            
                            
                            var user = await Provider.of<DatabaseRepository>(context, listen: false).findUserByIdAndName(int.parse(IdController.text), emailController.text);
                            print('PROVIDER OF: $user');
                            var sn = snapshot.data;
                            print('SNAPSHOT: $sn');
                              if (user != null){ 
                                await _showAlertDialogPos(user.id!, user.username); 
                              } else {  
                                await _showAlertDialogNeg();    
                              } // if

                            }
                          }
                        )
                       
                      )
                    )
                  ]
                  )
                );
              }
            );
          }
        )
      )
    );
  }




    // volendo, per alcune info ...
    // https://www.freecodecamp.org/news/how-to-build-a-simple-login-app-with-flutter/


  Future<void> _showAllUsers () async {
    String? name;
    String? pass;
    int? ID;
    var users = await Provider.of<DatabaseRepository>(context, listen: false).findAllUser();
    if (users.isNotEmpty){
      for (var user in users){
        ID = user!.id;
        name = user.username; //non possono essere nulli dato che li ho appena inseriti quindi non gestisco il caso
        pass = user.password;
        print('ID: $ID; Username: $name; Password: $pass');
      }
    } else {print('FINDALLUSER NON RITORNA NULLA');}
  }//_showAllUsers





  Future<void> _showAlertDialogPos(int data, String username) async {
    
    Users? user = await Provider.of<DatabaseRepository>(context, listen: false).findUserByIdAndName(data, username);
    if (user != null){
      print(user);
      int ID = user.id!;
      String name = user.username; //non possono essere nulli dato che li ho appena inseriti quindi non gestisco il caso
      String pass = user.password; 
    

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        
        return AlertDialog(
          title: Text('Done!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Recovery completed'),
                Text('Here below there are your credentials and your ID.'),
                
                Text('Username: $name'),
                Text('Password: $pass'),
                Text('ID: $ID'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewLogin())); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  } //if : non può esserci un secondo caso a questo punto
  }

  Future<void> _showAlertDialogNeg() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Credentials haven\'t been found! =( '),
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