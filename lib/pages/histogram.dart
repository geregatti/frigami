import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:frigami/models/calories.dart';
import 'package:http/http.dart' as http;
import 'package:frigami/repositories/preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:frigami/widgets/verticalGraph.dart';
import 'package:intl/intl.dart';
import 'package:frigami/utils/globals.dart';
import 'dart:io';

import '../utils/impact.dart';
import 'loginImpact.dart';
import 'package:flutter/material.dart';


class HistogramPage extends StatefulWidget {
  HistogramPage({Key? key, required this.messageFromFridge}) : super(key: key);
  List<Calories> messageFromFridge; //lista di calorie

  static const route = '/';
  static const routename = 'UserPage';

  @override
  State<HistogramPage> createState() => _HistogramPageState();
}

class _HistogramPageState extends State<HistogramPage> {
  

  //@override
  //void initState() {
    //super.initState();
    //_checkData();
  //}

  //Future<void> _checkData() async {

    //final result = await _requestData();
    //print(result);
    
    //if (result == null){
      //SnackBar snackBar = SnackBar(content: Text('Necessario autenticarsi a IMPACT oppure non trova dati per la data suggerita'));
      //snackbarKey.currentState?.showSnackBar(snackBar);
      // e mi fa vedere una pagina senza grafici impostando il booleano a false
      //setState(()  {
        //bool _hasData = false;
      //});
    //} else {
      // altrimenti il booleano diventerà vero e avrò tutta la pagina con grafici
      //List<String> y = _dataManagement(result);
      //print('Y DOPO MANAGEMENT: $y');
      //setState(()  {
        //bool _hasData = true;
      //});
   // }
 // }


  @override
  Widget build(BuildContext context) {
    //final List<Calories> messageFromFridge; //lista di calorie


    //final result = await _requestData();
    //print(result);
    
            // dovrebbe sparire: sto cercando di sostituirlo
    //if (result == null){
      //SnackBar snackBar = SnackBar(content: Text('Necessario autenticarsi a IMPACT oppure non trova dati per la data suggerita'));
      //snackbarKey.currentState?.showSnackBar(snackBar);
          // e mi fa vedere una pagina senza grafici impostando il booleano a false
      //setState(()  {
        //bool _hasData = false;
      //});
    //} else {
      // altrimenti il booleano diventerà vero e avrò tutta la pagina con grafici
      //List<String> y = _dataManagement(result);
      //print('Y DOPO MANAGEMENT: $y');
      //setState(()  {
        //bool _hasData = true;
      //});
    //}



    List<String> y = _dataManagement(widget.messageFromFridge);
    List<String> x = ['01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'];
    //print('Y: $y');


    return Scaffold(
        backgroundColor: const Color(0xFFE4DFD4),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFE4DFD4),
          iconTheme: const IconThemeData(color: Color(0xFF89453C)),
          title: const Text('Your fitbit data', style: TextStyle(color: Colors.black)),
        ),
        
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  Center(
                    child: Text('your daily calories')),
            
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: VerticalBarChart.withData(x, y),
                      ),
                    ),
                    ],
                  )
            )
                 

      )
    );
  }



  
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




  //Con questo metodo sistemo i dati ricevuti da impact nella forma di lista di calorie
  //e ritorna la y (cioè i valori di calorie per ora) per il grafico in forma di lista di stringhe
  List<String> _dataManagement(List<Calories> data){ // ? -> dovrebbero esserci dei valori altrimenti cambiare data!!!!!!!!!!
    List<DateTime> x = [];
    List<double> y = [];
    for (var cal in data) {
      var date = cal.time;
      x.add(date);
      var value = cal.value;
      y.add(value);
    }//for
      
    print('LABEL XXX: $x');
    print('LABEL YYY: $y');
    print(x.length);
    print(y.length);


    int i = 1;
    double counter = 0;
    List<String> y_new = [];

    for (var el in y) {
      counter = counter + el;
      if (i%60 == 0){
        i = 0;
        counter = counter*1000;
        int intCounter = counter.toInt();
        y_new.add(intCounter.toString());
        counter = 0;
      }
      i = i+1;
    }
    return y_new;
  }



} //Page