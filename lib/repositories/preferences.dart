import 'package:shared_preferences/shared_preferences.dart';
//-----------------------------------------------------------------------
//            DA TOGLIERE SE NON USATA
//-----------------------------------------------------------------------

class Preferences {
  
  Future<void> initialize() async {
    _sp = await SharedPreferences.getInstance();
  }

  late SharedPreferences _sp;

  // PER USER

  String getUsername (){
    String? value = _sp.getString('username');
    if (value == null){
      return 'No username found';
    } else {
      return value;
    }
  }

  String getPassword (){
    String? value = _sp.getString('password');
    if (value == null){
      return 'No password found';
    } else {
      return value;
    }
  }

  dynamic getUserId (){
    int? value = _sp.getInt('userId');
    if (value == null){
      return 'No userID found';
    } else {
      return value;
    }
  }

  // PER IMPACT

  String getUsernameImpact (){
    String? value = _sp.getString('usernameIM');
    if (value == null){
      return 'No username found';
    } else {
      return value;
    }
  }

  String getPasswordImpact (){
    String? value = _sp.getString('passwordIM');
    if (value == null){
      return 'No password found';
    } else {
      return value;
    }
  }

  String getToken (){
    String? value = _sp.getString('token');
    if (value == null){
      return 'No token found';
    } else {
      return value;
    }
  }

  String getRefreshToken (){
    String? value = _sp.getString('ReToken');
    if (value == null){
      return 'No refresh token found';
    } else {
      return value;
    }
  }

  List<String> getCaloriesDay(){
    List<String>? value = _sp.getStringList('calDay');
    if (value == null){
      return [''];
    } else {
      return value;
    }
  }

  // PER PROFILO

  String getGender (){
    String? value = _sp.getString('gender');
    if (value == null){
      return 'No gender found';
    } else {
      return value;
    }
  }

  dynamic getWeight (){
    int? value = _sp.getInt('weight');
    if (value == null){
      return 'No weight found';
    } else {
      return value;
    }
  }

  dynamic getAge (){
    int? value = _sp.getInt('age');
    if (value == null){
      return 'No age found';
    } else {
      return value;
    }
  }

  dynamic getHeight (){
    int? value = _sp.getInt('height');
    if (value == null){
      return 'No height found';
    } else {
      return value;
    }
  }



  // // // SET // // //


  // PER USER

  void setUsername (String value) {
    _sp.setString('username', value);
  }

  void setPassword (String value) {
    _sp.setString('password', value);
  }

  void setUserId (int value) {
    _sp.setInt('userId', value);
  }

  // PER IMPACT

  void setUsernameImpact (String value) {
    _sp.setString('usernameIM', value);
  }

  void setPasswordImpact (String value) {
    _sp.setString('passwordIM', value);
  }

  void setToken (String value) {
    _sp.setString('token', value);
  }

  void setRefreshToken (String value) {
    _sp.setString('ReToken', value);
  }

  void setCaloriesDay (List<String> value) {
    _sp.setStringList('caloriesDay', value);
  }

  // PER PROFILE

  void setGender (String value) {
    _sp.setString('gender', value);
  }
  void setAge (int value) {
    _sp.setInt('age', value);
  }
  void setWeight (int value) {
    _sp.setInt('weight', value);
  }
  void setHeight (int value) {
    _sp.setInt('height', value);
  }

  // PER CANCELLARE

  void clearAll () {
    _sp.clear();
  }
}