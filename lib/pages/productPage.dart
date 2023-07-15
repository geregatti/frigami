import 'package:flutter/material.dart';
import 'package:frigami/repositories/preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'package:frigami/database/entities/products.dart';
import 'package:frigami/repositories/databaseRepositories.dart';
import 'package:frigami/widgets/formTiles.dart';
import 'package:frigami/widgets/formSeparator.dart';
import 'package:frigami/utils/formats.dart';
import 'package:shared_preferences/shared_preferences.dart';


//pagina per creare nuovi prodotti e la gestione di quelli già prodotti 
class ProductPage extends StatefulWidget {
  //Creo un nuovo prodotto che quindi avrà le caratteristiche "nome","bestBefore" e identificato tramite "code". 
  //E' ammesso che sia nullo (da FAB di fridgePage è sempre nullo per esempio)
  final Products? prod;

  //constructore
  ProductPage({Key? key, required this.prod}): super(key: key); //è richiesto il prodotto prod passato dal floatingActionButton nella pagina del frigo


  static const routeDisplayName = 'Product page';

  @override
  State<ProductPage> createState() => _ProductPageState();
} 


class _ProductPageState extends State<ProductPage> {
  //mi servirà per la validazione dei form
  final formKey = GlobalKey<FormState>();

  //variabili per tenere le informazioni inserite nei form
  TextEditingController _choController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); //lo inizilaizza con data e ora corrente

  //con initState() inizializzo i valori del form fields
  //Quando si crea un nuovo prodotto le inizializzazioni del contenuto dei form e della data 
  //sono vuoti: li inizializzo con ' ' e now(), altrimenti ci metto i valori che vengono
  //inseriti da utente
  @override
  void initState() {
    //gli ingressi del form andranno a costituire le caratteristiche del prodotto
    // ? = if e : = else  =>  se nullo metto ' ' altrimenti il nome assegnato al prodotto
    _choController.text =
        widget.prod == null ? '' : widget.prod!.name.toString(); //name non può essere nullo (come definito dall'entità)
    _selectedDate =
        widget.prod == null ? DateTime.now() : widget.prod!.bestBefore;
    super.initState();
  } 

  //Remember that form controllers need to be manually disposed. So, here we need also to override the dispose() method.
  //Nel momento in cui elimino l'oggetto, la memoria associata alla variabile dello stato viene liberata
  @override
  void dispose() {
    _choController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //The page is composed of a form. An action in the AppBar is used to validate and save the information provided by the user.
    //A FAB is showed to provide the "delete" functinality. It is showed only if the meal already exists.
    return Scaffold(
      appBar: AppBar(
        title: Text(ProductPage.routeDisplayName),
        actions: [
          IconButton(
              onPressed: () => _validateAndSave(context),
              icon: Icon(Icons.done),)
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
      floatingActionButton: widget.prod == null
          ? null
          : FloatingActionButton(
              onPressed: () => _deleteAndPop(context),
              child: Icon(Icons.delete),
            ),
    );
  } //build

  //Utility method used to build the form.
  Widget _buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 8, left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            FormSeparator(label: 'Product'),
            FormTextTile(
              labelText: 'Name',
              controller: _choController,
              icon: MdiIcons.carrot,
            ),
            FormSeparator(label: 'Deadline'),
            FormDateTile(
              labelText: 'Date', 
              date: _selectedDate,
              icon: MdiIcons.clockTimeFourOutline,
              onPressed: () {
                _selectDate(context);
              },
              dateFormat: Formats.onlyDayDateFormat, // mi basta la data
            ),
          ],
        ),
      ),
    );
  } // _buildForm


  //Mi basta la data, ma volendo posso implementare data e orario
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate, //deve stare tra prima e ultima data disponibili (già inizializzato con data di oggi)
            firstDate: DateTime(2010), //prima data disponibile
            lastDate: DateTime(2101)); //ultima data disponibile
        //.then((value) async {
      //if (value != null) {
        //TimeOfDay? pickedTime = await showTimePicker(
          //context: context,
          //initialTime: TimeOfDay(
              //hour: _selectedDate.hour, minute: _selectedDate.minute),
        //);
        //return pickedTime != null
            //? value.add(
                //Duration(hours: pickedTime.hour, minutes: pickedTime.minute))
            //: null;
      //}
      //return null;
    //});
    if (picked != null && picked != _selectedDate)
      //aggiorno lo stato di _selectedDate se non nullo ed è stato modificato
      // e ricostruisco la UI con ciò che ho scelto.
      setState(() {
        _selectedDate = picked;
      });
  } //_selectDate



  // DA CONTROLLARE IL PRIMO IF
  // INSERIRE GESTIONE DI CODICI UGUALI (nel dao si scieglie la strategia rispetto ai conflitti) e magari inserire una nota se verrà sovrascritto il prodotto
      //devo modificare dao e quindi ricreare un nuovo db.g.dart
  //controlla la validità del form e nel caso salva le sue informazioni
  void _validateAndSave(BuildContext context) async {

    var pref = Provider.of<Preferences>(context, listen: false); // senza questo no posso andare al main dove inizializzo la sp
    int _userId = pref.getUserId();
    

    if (formKey.currentState!.validate()) {
      //Se il prodotto passato alla pagina era nullo, ne aggiungo uno nuovo...
      //If the original Meal passed to the MealPage was null, then add a new Meal...
      if(widget.prod == null){
        //Se il prodotto è nullo, quello nuovo avrà codice nullo, nome messo
        //nel form e la data scelta. Allora avviso con provider il db di 
        //aggiungere li nuovo prodotto (il codice allora sarà autogenerato)
        Products newProd = Products(null, _choController.text, _selectedDate, _userId); // visualizzo solo il mio frigo e non quello di atri utenti
          await Provider.of<DatabaseRepository>(context, listen: false).insertProduct(newProd);
                          // comunico con i metodi di databaseRepository dicendo di inserire
                          //a sua volta in dao viene gestito l'inserimento nel database con le query
      }
      //se il codice viene immesso allora lo inserisco. 
      else{
        Products updatedProduct =  Products(widget.prod!.code, _choController.text, _selectedDate, _userId);
          await Provider.of<DatabaseRepository>(context, listen: false)
              .updateProducts(updatedProduct);
      }
      Navigator.pop(context);
    }
  } // _validateAndSave

  //metodo di cancellazione del prodotto e ritorno al frigo
  void _deleteAndPop(BuildContext context) async{
    await Provider.of<DatabaseRepository>(context, listen: false).removeProducts(widget.prod!);
    Navigator.pop(context);
  } //_deleteAndPop

}