import 'package:flutter/material.dart';
import 'package:frigami/database/entities/recipes.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:frigami/pages/productPage.dart';
import 'package:frigami/pages/addRecipes.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:frigami/database/entities/products.dart';

//rimane stateless: deve solo farmi vedere le ricette
class RecipesPage extends StatelessWidget {
  final String ingredient; // non può essere negativo in quanto deve esserci un ingrediente nella dicetta
  const RecipesPage({Key? key, required this.ingredient}) : super(key: key);
    //static const route = '/';// If wanted, this maps names to the corresponding routes within the app                                
    static const routename = 'Recipes page';
    static final  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      title: Text(RecipesPage.routename),
      ),

      body: Center(
        //faccio vedere la lista dei prodotti con una lista. Uso il consumer del database
        // per aggiornare la lista  
        child: Consumer<DatabaseRepository>(
          //il db contiene le ricette. Le modifiche della pagina devono aggiornare il db
          builder: (context, dbr, child) {
            
            //Chiedo tutta la lista di ricette usando dbr.findAllRecepies() <--------
            //(il medoto ritorna un tipo Future quindi uso FutureBuilder) 
            
            //Il futureBuilder ritorna un CircularProgressIndicator 
            //mentre "inserisce" tutti i dati la cui "sorgente" è 
            //il metodo async findAllProducts.
            //Context contiene l'albero dei Widget usati nell'app, mentre 
            //l'altro è async e mi collega in qualche modo alla sorgente; 
            //Il tutto restituirà un widget (es.: CircularProgressIndicator)
            
            return FutureBuilder(
              initialData: null,
              future: dbr.findAllRecipes(ingredient), // devo inserire un metodo async
              builder:(context, snapshot) {
                if(snapshot.hasData){
                  final data = snapshot.data as List<Recipes>;
                  //Se la tabella è vuota fornisco un messaggio e un bottone 
                  //per la creazione di una nuova ricetta
                  return data.isEmpty 
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("There aren't recipes yet. Do you want to add one?"),
                          ElevatedButton(
                            onPressed: () => _tocreateRecipes(context, ingredient), 
                            child: const Text('Create!')
                            ),
                        ]
                      )
                      
                      //se invece non è vuota, ma ci sono già ricette... (AGGIUNGERE UN BOTTON ANCHE QUI)
                    : ListView.builder(
                    itemCount: data.isEmpty //SERVE questo controllo? boh, ma è figo
                        ? 0 
                        : data.length,
                    itemBuilder: (context, index) {
                      //Sfrutto l'oggeto Card per visualizzare i prodotti
                      return Card(
                        //color: _checkDate(Formats.onlyDayDateFormat.format(data[index].bestBefore),Formats.onlyDayDateFormat.format(today)),                     
                        elevation: 5,
                        child: ListTile(
                          //leading: Icon(MdiIcons.pasta),
                          trailing: Icon(MdiIcons.noteEdit), // METTERE UN'IMMAGINE anche se sempre uguale??
                          title:
                              Text('Name : ${data[index].name}'), //fornisco il nome dell'elemento (su entities) che l'utente immette nella productPage
                          subtitle: Text('data[index].INGREDIENTI'), // e la data di scadenza salvati nel db
                          //toccando la Card si torna a ProductPage per le modifche
                          //onTap: () // => _toProductsPage(context, data[index]),//passo alla pagina la ricetta da vedere e le sue specifiche
                        ),
                      );
                    });
                }//if
                else{
                  return CircularProgressIndicator();
                }//else
              },//FutureBuilder builder 
            );
          }//builder 
        ),//Consumer: fine dell'oggetto che ascolta le notifiche
      ),
      
    
    );
  } //build

  //Navigazione alla pagina di creazione delle ricette
  //primo context: Current BuildContext
  //secondo context: The new MaterialPageRoute to be pushed into the stack
  //passo alla pagina frigo il prodotto che voglio fare e le sue specifiche
  void _tocreateRecipes(BuildContext context, String ingred) { // devo passare l'ingrediente esatto per forza
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddRecipesPage(ingredient: ingred,)));
  } 

  Color _checkDate(data,day){
    return (data == day) ? Color.fromARGB(255, 255, 136, 128) : Color.fromARGB(255, 181, 229, 179);
  }


} //FridgePage