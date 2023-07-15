//Imports that are necessary to the code generator of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:frigami/database/typeConverter/dateTimeConverter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Here, we are importing the entities and the daos of the database
import 'daos/dao.dart';
import 'entities/entities.dart';

part 'database.g.dart';

//Here we are saying that this is the first version of the Database and it has just 1 entity, i.e., Meal.
//We also added a TypeConverter to manage the DateTime of a Meal entry, since DateTimes are not natively
//supported by Floor.
@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Products, Recipes, Users, FoodEated])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  ProductsDao get productsDao;
  RecipesDao get recipesDao;
  UsersDao get usersDao;
  FoodEatedDao get foodEatedDao;
}//AppDatabase