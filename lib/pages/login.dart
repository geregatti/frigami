import 'package:flutter/material.dart';
import 'package:frigami/pages/home.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:frigami/repositories/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frigami/pages/signUp.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:provider/provider.dart';
import 'package:frigami/utils/globals.dart'; //per lo snackBar
import 'package:frigami/database/entities/users.dart';
import 'package:frigami/database/database.dart';
import 'package:frigami/repositories/databaseRepositories.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const route = '/';
  static const routename = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController(); 
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController_new = TextEditingController();
  final formKey = GlobalKey<FormState>();





  @override
  void initState() {
    super.initState();
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
  }//initState

  void _checkLogin() async {

    //QUI POSSO cancellare gli sp (per la presentazione dell'app)
    //Preferences().clearAll();

    //password = 
    //username = 

    // DA MODIFICARE TUTTO AVENDO GIA' I CODICI in Preferences
    //Get the SharedPreference instance and check if the value of the 'username' filed is set or not
    final sp = await SharedPreferences.getInstance();
    if(sp.getString('username') != null){
      //If 'username is set, push the HomePage
      //_toHomePage(context);
    }//if
  }//_checkLogin
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Stack( 
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background_image.jpg', // Replace with image path
              fit: BoxFit.cover,
            ),
          ),
          Center(



            child:Form(
              key: formKey,
            child: Consumer<DatabaseRepository>(
            builder: (context, dbr, child) {
            return FutureBuilder(
              initialData: null,
              future: dbr.findUserByUsername(emailController.text), // devo inserire un metodo async
              builder:(context, snapshot){
                List<Users?>? savedData = snapshot.data;



              return SingleChildScrollView(
              child: Container(
                width: 300, // Adjust the width as per your preference
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color.fromARGB(255, 248, 247, 247).withOpacity(0), // Adjust opacity as needed
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Opacity(
                      opacity: 0.8, // Adjust opacity as needed
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) { //If the user’s input isn’t valid, the validator function returns a String containing an error message.
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email'; 
                          } else{ //If there are no errors, the validator must return null
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),                        
                      ),
                    ),

                    SizedBox(height: 16),

                    Opacity(
                      opacity: 0.8, // Adjust opacity as needed
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) { //If the user’s input isn’t valid, the validator function returns a String containing an error message.
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password'; 
                          } else{ //If there are no errors, the validator must return null
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: false,
                      ),
                    ),
                    

                    SizedBox(height: 16),
                    
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {

                        // per debug ///////////
                        await _deleteCredentials('g.g@g.com');
                        await _showAllUsers();


                        // Perform login or sign-up based on _isLogin value
                       
                          

                      },
                      
                      child: Text('Login'),
                    ),

                    SizedBox(height: 8),

                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                      },
                      child: Text('Don\'t have an account? Sign up'),
                    ),
                  ],
                ),
              ),
            );
              });}))
          ),
        ],
      ),
    );
  }



  Future<void> _getAndStoreCredentials(String username,String password) async {
    if (formKey.currentState!.validate()) {
      Users newUser = Users(null, username, password, null, null, null); 
      await Provider.of<DatabaseRepository>(context, listen: false).insertUser(newUser); //listen: false
      
    }else{
      SnackBar snackBar = SnackBar(content: Text('registration uncompleted'));
      snackbarKey.currentState?.showSnackBar(snackBar);
      Navigator.pop(context);
    } 
  }//_getAndStoreCredentials

  // funzione per ottenere tutti i dati dell'utente
  Future<String?> _userData (String? username) async {
    String? name;
    String? pass;
    int? ID;
    var users = await Provider.of<DatabaseRepository>(context, listen: false).findUserByUsername(username!);
    if (users.isNotEmpty && users.length == 1){
      for (var user in users){
        ID = user!.id;
        name = user.username; //non possono essere nulli dato che li ho appena inseriti quindi non gestisco il caso
        pass = user.password; 
    return 'Username: $name; Password: $pass; ID: $ID'; 
    }
    } else {return 'FINDALLUSERBYUSERNAME NON RITORNA NULLA oppure HO PIU DI UNO USER';} // PER DUBUG
  }//_userData

  Future<void> _deleteCredentials(String username) async {
    List<Users?> users = await Provider.of<DatabaseRepository>(context, listen: true).findUserByUsername(username);
    print(users);
    if (users.isNotEmpty || users != null){
      for (Users? user in users){
        await Provider.of<DatabaseRepository>(context, listen: false).removeUser(user!);
      }
    } else {print('FINDALLUSERBYUSERNAME NON RITORNA NULLA');}
  }//_deleteCredentials


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


}
