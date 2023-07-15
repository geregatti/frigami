import 'package:frigami/database/database.dart';
import 'package:frigami/database/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:frigami/models/calories.dart';

class DatabaseRepository extends ChangeNotifier{

  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});


// Per Products

  //This method wraps the findAllProducts() method of the DAO
  Future<List<Products>> findAllProducts(int id) async{
    final results = await database.productsDao.findAllProductsById(id);
    return results;
  } 

  //This method wraps the insertMeal() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertProduct(Products prod)async {
    await database.productsDao.insertProduct(prod);
    notifyListeners();
  }
  
  //This method wraps the deleteMeal() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> removeProducts(Products prod) async{
    await database.productsDao.deleteProducts(prod);
    notifyListeners();
  }
  
  //This method wraps the updateMeal() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> updateProducts(Products prod) async{
    await database.productsDao.updateProducts(prod);
    notifyListeners();
  }

// Per Recipes

  Future<List<Recipes>?> findAllRecipes(String ingredient) async{
    try {final result = await database.recipesDao.findAllRecipes(ingredient);
      return result;
    } catch (e) {
      List<Recipes> result = []; //voglio mi fornisca una lista vuota per la gestione in recipesPage
      return result;}
  }

  Future<List<Recipes>?> findAllRecipesWithId(String ingredient, int id) async{
    try {final result = await database.recipesDao.findAllRecipesWithId(ingredient, id);
      return result;
    } catch (e) {
      List<Recipes> result = []; //voglio mi fornisca una lista vuota per la gestione in recipesPage
      return result;}
  }
  
  Future<void> insertRecipes(Recipes rec)async {
    await database.recipesDao.insertRecipes(rec);
    notifyListeners();
  }

  Future<void> removeRecipes(Recipes rec) async{
    await database.recipesDao.deleteRecipes(rec);
    notifyListeners();
  }
  
  

// Per Users
  
  Future<void> removeUser(Users user) async{
    await database.usersDao.deleteUsers(user);
    notifyListeners();
  }

  Future<void> insertUser(Users user)async {
    await database.usersDao.insertUser(user);
    notifyListeners();
  }

  Future<void> updateUsers(Users user) async{
    await database.usersDao.updateUsers(user);
    notifyListeners();
  }

  Future<List<Users?>> findAllUser() async{
    final result = await database.usersDao.findAllUser();
    return result; //può ritornare null
  }

  Future<Users?> findUserByIdAndName(int id, String name) async{
    final result = await database.usersDao.findUserByIdAndName(id, name);
    return result; //può ritornare null
  }

  Future<Users?> findUserByCredentials(String username, String password) async{
    final result = await database.usersDao.userByCredentials(username,password);
    return result; //può ritornare null
  }
   
  Future<List<Users?>> findUserByUsername(String username) async{
    final result = await database.usersDao.userByUsername(username);
    return result; //può ritornare null
  }
  // Per FoodEated

  //Per FoodEated

  //This method wraps the findAllProducts() method of the DAO
  Future<List<FoodEated?>> findAllFoodEated(int id) async{
    final results = await database.foodEatedDao.findAllFoodEatedById(id);
    return results;
  } 

  //This method wraps the insertMeal() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertFoodEated(FoodEated food)async {
    await database.foodEatedDao.insertFoodEated(food);//prod?
    notifyListeners();
  }
  
  //This method wraps the deleteMeal() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> deleteFoodEated(FoodEated prod) async{
    await database.foodEatedDao.deleteFoodEated(prod);
    notifyListeners();
  }
  
  //This method wraps the updateMeal() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> updateFoodEated(FoodEated prod) async{
    await database.foodEatedDao.updateFoodEated(prod);
    notifyListeners();
  }




}