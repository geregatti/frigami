import 'package:frigami/database/entities/entities.dart';
//import 'package:frigami/database/entities/foodEated.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class FoodEatedDao {

  //Query #1: SELECT -> per ottenere tutte le entries della tabella FoodEated
  @Query('SELECT * FROM foodEated WHERE userId = :id')
  Future<List<FoodEated?>> findAllFoodEatedById(int id);

  //Query #2: INSERT -> this allows to add a Product in the table
  @insert
  Future<void> insertFoodEated(FoodEated food);

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
  Future<void> deleteFoodEated(FoodEated task);

  //Query #4: UPDATE -> this allows to update a Product entry
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateFoodEated(FoodEated food);
  
}//KcalBurntDao