import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frigami/database/entities/products.dart';
import 'package:frigami/database/entities/recipes.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:frigami/widgets/formTiles.dart';
import 'package:frigami/widgets/formSeparator.dart';
import 'package:frigami/utils/formats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:frigami/repositories/preferences.dart';


// pagina per la creazione e aggiunta di nuove ridette
class AddRecipesPage extends StatefulWidget {
  //Creo una nuova ricetta che quindi avrà le caratteristiche "nome", "testo", "ingrediente" e identificato tramite un suo codice. 
  //"ingrediente" c'è per forza, mancano da definire nome e testo della ricetta ed eventuale codice (meglio di no? forse dipende
  //se è un db accessibile a tutti o no: DA DEFINIRE: magari posso evitare di cancellarlo all'arrivo di un nuovo user)
  
  //non è mai nullo perchè creo una ricetta a partire da un ingrediente 
  //(nell'app ma anche nella realtà => cardinalità: obbligatorio almeno un prodotto) (1:N)
  //Però posso anche aggiungere nuove ricette dal nulla ....
  final String? ingredient;

  //constructore
  AddRecipesPage({Key? key, required this.ingredient}): super(key: key); //è richiesto il prodotto prod passato dal floatingActionButton nella pagina del frigo


  static const routeDisplayName = 'Add recipe';

  @override
  State<AddRecipesPage> createState() => _AddRecipesPageState();
} 


class _AddRecipesPageState extends State<AddRecipesPage> {
  //mi servirà per la validazione dei form
  final formKey = GlobalKey<FormState>();

  //variabili per tenere le informazioni inserite nei form
  TextEditingController _nameController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  //con initState() inizializzo i valori del form fields
  //Quando si crea un nuovo prodotto le inizializzazioni del contenuto dei form e della data 
  //sono vuoti: li inizializzo con ' ' e now(), altrimenti ci metto i valori che vengono
  //inseriti da utente
  @override
  void initState() {
    //gli ingressi del form andranno a costituire le caratteristiche del prodotto
    // ? = if e : = else  =>  se nullo metto ' ' altrimenti il nome assegnato al prodotto
      widget.ingredient == null ? '' : widget.ingredient!; //name non può essere realmente nullo (come definito dall'entità)
      //AL MOMENTO NON PUò ESSERE NULLO QUINDI NO PROBLEM

      _nameController.text = "";
      _textController.text = "";
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {

    //The page is composed of a form. An action in the AppBar is used to validate and save the information provided by the user.
    //A FAB is showed to provide the "delete" functinality. It is showed only if the meal already exists.
    return Scaffold(
      appBar: AppBar(
        title: Text(AddRecipesPage.routeDisplayName),
        actions: [
          IconButton(
              onPressed: () => _validateAndSave(context),
              icon: Icon(Icons.done),)
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
      // SE DOVESSI AGGIUNGERE UNA RICETTA DA QUI L'INGREDIENTE SARà NULLO !!
      //floatingActionButton: widget.prod == null
        //  ? null
        //  : FloatingActionButton(
        //      onPressed: () => _deleteAndPop(context),
        //      child: Icon(Icons.delete),
        //    ),
    );
  } //build

  //Costrisco il form che andrà in nel body
  Widget _buildForm(BuildContext context) {
    return Form(
      key: formKey, // mi serve per validare il suo stato (automatico)
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 8, left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            FormSeparator(label: 'New recipe'),
            FormTextTile(
              labelText: 'Name',
              controller: _nameController,
              //icon: MdiIcons.pasta,
            ),
            FormSeparator(label: "Recipe's text"),
            TextField(
              decoration: InputDecoration(hintText: 'Add your recipe'),
              controller: _textController,
              maxLines: null,             
            ),
          ],
        ),
      ),
    );
  } // _buildForm

  
  // INSERIRE GESTIONE DI CODICI UGUALI (nel dao si scieglie la strategia rispetto ai conflitti) e magari inserire una nota se verrà sovrascritto il prodotto
      // devo modificare dao e quindi ricreare un nuovo db.g.dart
  // controlla la validità del form e nel caso salva le sue informazioni
  void _validateAndSave(BuildContext context) async {
    
    var pref = Provider.of<Preferences>(context, listen: false); // senza questo no posso andare al main dove inizializzo la sp
    int _userId = pref.getUserId();
      // se gli ingressi non sono validi fornisco un avviso
      if (formKey.currentState!.validate() == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill properly all the form before the validation of the recipe')));

       //Se l'ingrediente passato alla pagina era nullo, ne aggiungo uno nuovo...
       // PROBLEMA CHE POTRà ESSERE INSERITO SOLO UN INGREDIENTE
       // A meno che non produca un form con + a lato che aggiunga sempre un nuovo ingrediente
       // e la ricetta verrà salvata per tutti gli ingredienti messi (con codici diversi)

       //if(widget.ingredient == null){

        //Se il prodotto è nullo, quello nuovo avrà codice nullo, nome messo
        //nel form e la data scelta. Allora avviso con provider il db di 
        //aggiungere li nuovo prodotto (il codice allora sarà autogenerato)

        //Recipes newRecipe = Recipes(null, _nameController.text, _textController); 
          //await Provider.of<DatabaseRepository>(context, listen: false).insertProduct(newProd);

                          // comunico con i metodi di databaseRepository dicendo di inserire
                          //a sua volta in dao viene gestito l'inserimento nel database con le query
        } // if
      
        // dalle sp conosco le credenziali di chi ha fatto l'ultimo accesso -> 
        // ricavo il suo ID -> lo appioppo alle ricette create da lui
        else {
          //Consumer<DatabaseRepository>(
            //builder: (context, dbr, child) {
              //return FutureBuilder(
                //initialData: null,
                //future: dbr.findUserByCredentials(username,password), //ne trovo per forza solo uno perchè gli username saranno tutti diversi (gestito nella registrazione)
                //builder:(context, snapshot) {
                  //userId = snapshot.data?.id;
                
                  //return CircularProgressIndicator(); }   
              //);
            //},
          //);

          Recipes newRecipe =  Recipes(null, _nameController.text, _textController.text, widget.ingredient!, _userId); 
          await Provider.of<DatabaseRepository> (context, listen: false).insertRecipes(newRecipe); 
          Navigator.pop(context); //solo quando va a buon fine torno indietro al frigo  
        }    
    }// _validateAndSave
}
