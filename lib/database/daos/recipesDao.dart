import 'package:frigami/database/entities/recipes.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class RecipesDao {

  //Query #1: SELECT -> per ottenere tutte le entries della tabella Products
  @Query('SELECT * FROM Recipes WHERE ingredient = :ingredient')
  Future<List<Recipes>> findAllRecipes(String ingredient); 
  
  //Query #1: SELECT -> per ottenere tutte le entries della tabella Products
  @Query('SELECT * FROM Recipes WHERE ingredient = :ingredient and userId = :id')
  Future<List<Recipes>> findAllRecipesWithId(String ingredient, int id); 

  @insert
  Future<void> insertRecipes(Recipes recipe);

  //When using the capitalized @Insert you can specify a conflict 
  //strategy. Else it just defaults to aborting the insert.
  //Example:
  //@Insert(onConflict:
  //OnConflictStrategy.rollback)
  //Future<void> insertPerson(Person person);

  //voglio una query che mi permetta di avere i prossimi in scadenza
  //@Query('SELECT * FROM Products WHERE bestBefore = : bestBefore')
  //Stream<Products?> findProductsByDate(DateTime bestBefore); //ritorna prodotti come streams

  //Query #3: DELETE -> this allows to delete a Product from the table
  @delete
  Future<void> deleteRecipes(Recipes task);
  
}//MealDao