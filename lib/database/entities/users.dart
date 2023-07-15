import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@Entity(tableName: 'users') //opens up the possibility to use a custom name for
                              //that specific entity instead of using the class name
class Users {
  //id will be the primary key of the table. Moreover, it will be autogenerated.
  //id is nullable since it is autogenerated.
  @PrimaryKey(autoGenerate: true)
  final int? id; 

  final String username; //per semplicità magari può essere anche la sua email
 
  final String password;

  final String? gender;

  final int? weight;

  final int? height;

  //Default constructor
  Users(this.id, this.username, this.password, this.gender, this.weight, this.height);
  
}