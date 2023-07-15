import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'package:frigami/pages/loginNew.dart';
import 'package:frigami/pages/fridge.dart';
import 'package:frigami/pages/logoPage.dart';
import 'package:frigami/repositories/preferences.dart';
import 'package:provider/provider.dart';
import 'package:frigami/utils/globals.dart';

import 'package:frigami/database/database.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<void> main() async {
  //This is a special method that use WidgetFlutterBinding to interact with the Flutter engine.
  //This is needed when you need to interact with the native core of the app.
  //Here, we need it since when need to initialize the DB before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  //This opens the database.

  //This opens the database.
  final AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build(); //assegno il nome del file del db
  
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);
  
  //Here, we run the app and we provide to the whole widget tree the instance 
  //of the DatabaseRepository.
  //That instance will be then shared through the platform and will be unique.
  runApp(
    ChangeNotifierProvider<DatabaseRepository>(
      create: (context) => databaseRepository,
      child: MyApp() 
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { //Key method for building the Widget that must be implemented
    return Provider<Preferences>( // ascolto da pagina 
      create: (context) => Preferences()..initialize(), //faccio in modo che _sp siano pronte e utlizzanili
          // This creates the preferences when the provider is creater. With lazy = true (default), the preferences would be initialized when first accessed, but we need them for the other services
      lazy: false,
      child: MaterialApp( 
        scaffoldMessengerKey: snackbarKey,
        theme: ThemeData(primarySwatch: Colors.green, secondaryHeaderColor: Colors.orange),
        home: LogoPage(),
      )
    );
  }
}

