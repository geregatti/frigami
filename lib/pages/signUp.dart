import 'package:flutter/material.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:provider/provider.dart';
import 'package:frigami/database/entities/users.dart';
import 'package:frigami/pages/loginNew.dart';
import 'package:frigami/utils/globals.dart'; //per lo snackBar



class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);
    static const routename = 'Sign Up Page';

   @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //mi servirà per la validazione dei form
  final formKey = GlobalKey<FormState>();

  //A controller in our context is used to read the values from the input. Using a controller, you'll be able to control its associated component.
  TextEditingController emailController = TextEditingController(); 
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
    bool _obscureText = true;

  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SignUpPage.routename),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
                child: Consumer<DatabaseRepository>( // si può togliere o risolvere il problema di snap chimando "Provider.of<DatabaseRepository>(context, listen: false).findUserByUsername(emailController.text);" 
                                             // sotto il body o sopra scaffold e inizializzando emailController.text ... no
                  builder: (context, dbr, child) {
                  return FutureBuilder(
                  initialData: null,
                  future: dbr.findUserByUsername(emailController.text), // devo inserire un metodo async
                  builder:(context, snapshot){ 
                    return Padding(   //The Form accepts a child. It can accept only one component.
                    //DA SISTEMARE tutti i padding (causa overflow)
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
                  child: Column( //This Padding widget also accepts only one child.
                  mainAxisSize: MainAxisSize.min,//se da problemi mettere center
                    children: [
                      Padding( padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email or username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        validator: (value) { //If the user’s input isn’t valid, the validator function returns a String containing an error message.
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email'; 
                          } else{ //If there are no errors, the validator must return null
                            return null;
                          }
                        },
                      ),
                    ),
              
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: passwordController1,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                             });
                            },
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password'; 
                          } else{
                            return null;
                          }
                        },
                        obscureText: _obscureText,
                      ),

                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: passwordController2,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                             });
                            },
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password'; 
                          } else{ if (passwordController1.text != passwordController2.text) {
                            return 'Passwords don\'t match';
                          } else {
                              return null;
                          }
                          }
                        },
                        obscureText: _obscureText,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          child: Text('SIGNUP NOW!'),
                          onPressed:() async {
                            if (formKey.currentState!.validate()){ 

                            // PER DEBUG //////////////////
                          
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
                            var lista = await Provider.of<DatabaseRepository>(context, listen: false).findUserByUsername(emailController.text);
                            print('SNAPSHOT: $lista');
                              if (lista.isNotEmpty){ await _showAlertDialogNeg();
                                
                              } else {
                          
                              await _getAndStoreCredentials(emailController.text, passwordController1.text); 
                              
                              String freshData = _userData(emailController.text).toString();
                              print('DATI INSERITI : $freshData');
                              await _showAlertDialogPos(emailController.text);
                              
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
    )
      )
    )
    );
  }

                


                      //var data = await Provider.of<DatabaseRepository>(context, listen: false).findUserByUsername(emailController.text);
                      //print('USER: $data');
                      //if (data!.username != null) { 
                        // viene trovato uno username uguale e gestisco
                        //AlertDialog(
                          //title: const Text('Registration excepion'),
                          //content: const Text('Please, choose another username'),
                          //actions: <Widget>[
                            //TextButton(
                              //onPressed: () => Navigator.pop(context), //torno alla loginPage
                              //child: const Text('OK'),
                            //),
                          //],
                        //);
                        //} else {
                          
                          //_getAndStoreCredentials(emailController.text, passwordController.text); 
                          //Future<String> freshData = _userData(emailController.text);
                          //print('DATI INSERITI : $freshData');
                          
                          //AlertDialog(
                          //title: const Text('Registration completed'),
                          //titleTextStyle: ,
                          //content: Text('Your registration has been completed succesfully. Here below there are your credentials and your ID. Please remember your ID in case you lose the credentials. $freshData'),
                          //actions: <Widget>[
                            //TextButton(
                              //onPressed: () => Navigator.pop(context), // torno alla loginPage
                              //child: const Text('OK'),
                            //),
                          //],
                        //);
                          //}
                      //}, 
                    //child: Text('SIGNUP NOW!')
                      //),
                    
              
    




    // volendo, per alcune info ...
    // https://www.freecodecamp.org/news/how-to-build-a-simple-login-app-with-flutter/


  Future<void> _getAndStoreCredentials(String username,String password) async {
    if (formKey.currentState!.validate()) {
      Users newUser = Users(null, username, password, null,null, null); 
      await Provider.of<DatabaseRepository>(context, listen: false).insertUser(newUser); //listen: false
      await _showAllUsers();
    }
  }//_getAndStoreCredentials

  // Se ci sono già delle credenziali devo fornire un avviso di cambiarle -> lo user per sbaglio 
  // conosce le credenziali di qualcun altro: meglio fare il check solo sullo username -> tutti
  // gli users dovranno avere username diversi (possibile nuova private key). Tengo comunque 
  // l'Id degli utenti come recovery password... DA MOSTRARE ALLA REGISTRAZIONE 
  Future<void> _deleteCredentials(String username) async {
    List<Users?> users = await Provider.of<DatabaseRepository>(context, listen: false).findUserByUsername(username);
    print(users);
    if (users.isNotEmpty || users != null){
      for (Users? user in users){
        await Provider.of<DatabaseRepository>(context, listen: false).removeUser(user!);
      }
    } else {print('FINDALLUSERBYUSERNAME NON RITORNA NULLA');}
  }//_deleteCredentials



  // funzione per ottenere tutti i dati dell'utente
  Future<String?> _userData (String? username) async {
    String? name;
    String? pass;
    int? ID;
    var users = await Provider.of<DatabaseRepository>(context, listen: false).findUserByUsername(username!);
    if (users.isNotEmpty){
      for (var user in users){
    ID = user!.id;
    name = user.username; //non possono essere nulli dato che li ho appena inseriti quindi non gestisco il caso
    pass = user.password; 
    return 'Username: $name; Password: $pass; ID: $ID'; 
    }
    } else {return 'FINDALLUSERBYUSERNAME NON RITORNA NULLA';}
  }//_userData

// per debug (funzione miglio in login?)
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





  Future<void> _showAlertDialogPos(String data) async {
    
    List<Users?> users = await Provider.of<DatabaseRepository>(context, listen: false).findUserByUsername(data);
    //if (users.isNotEmpty && users.length <= 1){
      print(users);
      int? ID = users[0]!.id;
      String? name = users[0]!.username; //non possono essere nulli dato che li ho appena inseriti quindi non gestisco il caso
      String? pass = users[0]!.password; 
    //}

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        
        return AlertDialog(
          title: Text('Done!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Registration completed'),
                Text('Your registration has been completed succesfully. Here below there are your credentials and your ID. Please remember your ID in case you lose the credentials.'),
                Text('ID: $ID'),
                Text('Username: $name'),
                Text('Password: $pass'),
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
                Text('Username already used.'),
                Text('Please choose another.'),
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