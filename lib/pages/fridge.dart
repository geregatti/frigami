import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frigami/database/entities/products.dart';
import 'package:frigami/pages/profile.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:frigami/utils/formats.dart';
import 'package:frigami/pages/productPage.dart';
import 'package:frigami/pages/recipesPage.dart';
import 'package:frigami/pages/loginNew.dart';
import 'package:frigami/repositories/preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frigami/pages/loginImpact.dart';

import 'package:http/http.dart' as http;

import '../database/entities/entities.dart';
import '../models/calories.dart';
import '../utils/globals.dart';
import '../utils/impact.dart';
import 'histogram.dart';


class FridgePage extends StatefulWidget {
  const FridgePage({Key? key}) : super(key: key);
    static const routename = 'LoginImpact';

  @override
  _FridgePageState createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage>  {
  
  static const route = '/'; // If wanted, this maps names to the corresponding routes within the app                                
    
  static final  DateTime today = DateTime.now();
    
    //late final int? userId = Preferences().getUserId(); // con pagina Preferences

  @override
  Widget build(BuildContext context) {
    var pref = Provider.of<Preferences>(context, listen: false);
    int userId =  pref.getUserId();
    String username = pref.getUsername();
    return Scaffold(

      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
        
      ),


      

      body: Center(
        child:
              //faccio vedere la lista dei prodotti con una lista. Uso il consumer del database per aggiornare la lista  
          Consumer<DatabaseRepository>(
            builder: (context, dbr, child) {
              
              
                      //Chiedo tutta la lista di prodotti nel frigo usando dbr.findAllProducts()
                      //(il medoto ritorna un tipo Future quindi uso FutureBuilder) 
            
                      //Il futureBuilder ritorna un CircularProgressIndicator 
                      //mentre "inserisce" tutti i dati la cui "sorgente" è 
                      //il metodo async findAllProducts.
                      //Context contiene l'albero dei Widget usati nell'app, mentre 
                      //l'altro è async e mi collega in qualche modo alla sorgente; 
                      //Il tutto restituirà un widget (es.: CircularProgressIndicator)
           
                return FutureBuilder(
                  initialData: null,
                  future: dbr.findAllProducts(userId), //trovo i prodotti di utente
                  builder:(context, snapshot) {
                    if(snapshot.hasData){
                      final data = snapshot.data as List<Products>;
                      //Se la tabella è vuota fornisco un messaggio
                      return data.isEmpty 
                        ? const Text('Your fridge is currently empty') 
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              //Sfrutto l'oggeto Card per visualizzare i prodotti
                            return Card(
                              color: _checkDate(Formats.onlyDayDateFormatTicks.format(data[index].bestBefore),Formats.onlyDayDateFormatTicks.format(today)), //devo averle con "-"                    
                              elevation: 5,
                              child: Dismissible( // per farla muovere
                                key: UniqueKey(), //necessaria ma inutile
                                  //This is the background to show when the ListTile is swiped
                                background: Container(color: Color.fromARGB(255, 252, 136, 41)),
                                child: ListTile(
                                  leading: Icon(MdiIcons.pasta),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.settings),
                                    onPressed: () => _toProductsPage(context, data[index]),
                                    ),
                                  title:  Text('Name : ${data[index].name}'), //fornisco il nome dell'elemento (su entities) che l'utente immette nella productPage
                                  subtitle: Text('${Formats.onlyDayDateFormat.format(data[index].bestBefore)}'), // e la data di scadenza salvati nel db
                                    // toccando la Card si torna a ProductPage per le modifche
                                  onTap: () => _toRecepesPage(context, data[index].name), // porta alla pagina della ricetta
                                  ),
                                  confirmDismiss: (direction) async {
                                    await _showAlertDialog(context, data[index]);
                                      
                                  } ,//passo alla pagina frigo il prodotto che voglio fare e le sue specifiche
                              ),
                            );
                            }
                          );
                    } // if snapshot non ha dati ritorno circularprogress...
                    else{ return CircularProgressIndicator(); }
                  }, // builder of FutureBuilder     
                );
              } //builder of Consumer<DatabaseRepository>
          ) //Consumer<DatabaseRepository>: fine dell'oggetto che ascolta le notifiche
      ),


      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text('$username'), //<-------------------------------------------------------------------------------------------
                    accountEmail: Text('ID: $userId'),
                    currentAccountPicture: Center(
                      child: CircleAvatar(
                        radius: 70,
                        child: Image.asset('assets/avatar.png'),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Profile(messageFromFridge: null,)),);
                      
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Impact'),
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => LoginImpactPage()),);
                      
                    },
                  ),
                  ListTile(
                    title: Text('Grafics (doesn\'t work)'),
                    onTap: () async {
                      List<Calories>? data = await _requestData(); 
                      //////////////// PER DEBUG cancellare sp token e controllare dove si perde
                      if (data != null){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HistogramPage(messageFromFridge: data)));
                      }else{
                        SnackBar snackBar = SnackBar(content: Text('It\'s necessary to login to Impact'));
                        snackbarKey.currentState?.showSnackBar(snackBar);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginImpactPage()),);
                      }
                      
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => HistogramPage()),); //no loginImpact
                      // Handle profile tap
                    },
                  ),
                  ListTile(
                    title: Text('Profile'),
                    onTap: () async {
                      var pref = Provider.of<Preferences>(context, listen: false);
                      String name = pref.getUsername();
                      int id = pref.getUserId();
                      Users? user = await Provider.of<DatabaseRepository>(context, listen: false).findUserByIdAndName(id,name);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(messageFromFridge: user)));
                      
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout), // Use the appropriate icon here
                  SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
      
      
      // FloatingActionButton per agguinta di prodotti.
      // Sfrutto _toProductsPage() che richiede un oggetto Product in ingresso. Dato che 
      // è ancora da fare uso null, ma la pagina saprà che è un oggetto Products
      floatingActionButton: FloatingActionButton(
        child: Icon(MdiIcons.plus),
        onPressed: (){
          _toProductsPage(context,null);
        } 
      )


    );
  } //build

  //Navigazione alla pagina di creazione dei prodotti
  //primo context: Current BuildContext
  //secondo context: The new MaterialPageRoute to be pushed into the stack
  //passo alla pagina frigo il prodotto che voglio fare e le sue specifiche
  void _toProductsPage(BuildContext context, Products? prod) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(prod: prod,)));
  } 

   void _toRecepesPage(BuildContext context, String prod) { // prod DEVE DIVENTARE STRING (prendo solo .name)
    Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesPage(ingredient: prod,)));
  }



  Color _checkDate(data,day){ // E SE IL GIORNO E' GIA PASSATO??? https://www.fluttercampus.com/guide/166/how-to-compare-two-datetime-in-dart-flutter/
    DateTime dt1 = DateTime.parse('$day 00:00:00');
    DateTime dt2 = DateTime.parse('$data 00:00:00');
    if (dt1.isAfter(dt2)){ // se è scaduto ritorno ROSSO
      return Color.fromARGB(255, 255, 136, 128);
    } else if (dt1.isAtSameMomentAs(dt2)){ // se è in scadenza ritorno GIALLO
      return Color.fromARGB(255, 230, 238, 159);
    } else { // altrimenti ritorno VERDE
    return Color.fromARGB(255, 181, 229, 179);}
  }


  //RIPIEGO AL CONSUMER PER FUTURE
  //Future<SharedPreferences> insert() async {
    //final sp = await SharedPreferences.getInstance();
    //return sp;
  //}



  Future<void> _showAlertDialog(BuildContext context, Products prod) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Hi!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Have you eated it?'),
              ],
            ),
          ),
          actions: <Widget>[
            Row( children: [
            TextButton(
              child: Text('YES'),
              onPressed: () async {
                await Provider.of<DatabaseRepository>(context, listen: false).removeProducts(prod);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('NOP'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ]
            )
          ],
        );
      },
    );
  }


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                var pref = Provider.of<Preferences>(context, listen: false); 
                pref.clearAll();

                Navigator.push(context,MaterialPageRoute(builder: (context) => NewLogin()),
                );
              },
            ),
          ],
        );
      },
    );
  }
  


  // richiesta dati per calorie
  Future<List<Calories>?> _requestData() async {
    //Initialize the result
    List<Calories>? result;

    //Get the stored access token (Note that this code does not work if the tokens are null)
    //final sp = await SharedPreferences.getInstance();
    //var access = sp.getString('access');
    var sp = Provider.of<Preferences>(context, listen: false); 
    var access =  sp.getToken();
    if (access == 'No token found'){ // se non ci sono no mi sono mai autenticato 
      print('No token found');
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginImpactPage())); 
    }

    //If access token is expired, refresh it
    if(JwtDecoder.isExpired(access)){ // se ci sono token potrebbero essere scaduti
      print('Refreshing Token');
      await _refreshTokens();
      access = sp.getToken(); // get nuovi token
    }//if

    //Create the (representative) request
    final day = '2023-05-04'; // DA IMPOSTARE LA DATA GIUSTA
    final url = Impact.baseUrl + Impact.caloriesEndpoint + Impact.patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      result = [];
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        result.add(Calories.fromJson(decodedResponse['data']['date'], decodedResponse['data']['data'][i]));
      }//for
    } //if
    else{
      result = null;
    }//else

    //Return the result
    return result;

  } //_requestData



  //_refreshTokens
  Future<int> _refreshTokens() async {

    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    var sp = Provider.of<Preferences>(context, listen: false); 
    final refresh =  sp.getRefreshToken();
    
    final body = {'refresh': refresh};

    //Get the respone
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If 200 set the tokens
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      var sp = Provider.of<Preferences>(context, listen: false); 
      sp.setToken(decodedResponse['access']);
      sp.setRefreshToken(decodedResponse['refresh']);
    } //if

    //Return just the status code
    return response.statusCode;

  } //_refreshTokens




} //FridgePage
