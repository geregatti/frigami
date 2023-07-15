import 'package:floor/floor.dart';
import 'package:frigami/database/entities/users.dart';
//Here, we are saying that the following class defines a dao.

@dao
abstract class UsersDao {

  //Query #2: INSERT -> this allows to add a Product in the table
  @insert
  Future<void> insertUser(Users user);

  @Query('SELECT * FROM Users WHERE id = :id and username = :name')
  Future<Users?> findUserByIdAndName(int id, String name);

  @Query('SELECT * FROM Users WHERE username = :username and password = :password') 
  Future<Users?> userByCredentials(String username, String password);

  @Query('SELECT * FROM Users WHERE username = :username') 
  Future<List<Users?>> userByUsername(String username);

  @Query('SELECT * FROM Users') 
  Future<List<Users?>> findAllUser();

  //Query #3: DELETE -> this allows to delete a Users from the table
  @delete
  Future<void> deleteUsers(Users user);

  //Query #4: UPDATE -> this allows to update a Users entry
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUsers(Users users);
  
}//MealDao