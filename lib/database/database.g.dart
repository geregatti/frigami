// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProductsDao? _productsDaoInstance;

  RecipesDao? _recipesDaoInstance;

  UsersDao? _usersDaoInstance;

  FoodEatedDao? _foodEatedDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `products` (`code` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `bestBefore` INTEGER NOT NULL, `userId` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `recipes` (`recipeCode` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `testo` TEXT NOT NULL, `ingredient` TEXT NOT NULL, `userId` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `username` TEXT NOT NULL, `password` TEXT NOT NULL, `gender` TEXT, `weight` INTEGER, `height` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `foodEated` (`foodEatedcode` INTEGER PRIMARY KEY AUTOINCREMENT, `kcal` INTEGER NOT NULL, `dateEated` INTEGER NOT NULL, `userId` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProductsDao get productsDao {
    return _productsDaoInstance ??= _$ProductsDao(database, changeListener);
  }

  @override
  RecipesDao get recipesDao {
    return _recipesDaoInstance ??= _$RecipesDao(database, changeListener);
  }

  @override
  UsersDao get usersDao {
    return _usersDaoInstance ??= _$UsersDao(database, changeListener);
  }

  @override
  FoodEatedDao get foodEatedDao {
    return _foodEatedDaoInstance ??= _$FoodEatedDao(database, changeListener);
  }
}

class _$ProductsDao extends ProductsDao {
  _$ProductsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productsInsertionAdapter = InsertionAdapter(
            database,
            'products',
            (Products item) => <String, Object?>{
                  'code': item.code,
                  'name': item.name,
                  'bestBefore': _dateTimeConverter.encode(item.bestBefore),
                  'userId': item.userId
                }),
        _productsUpdateAdapter = UpdateAdapter(
            database,
            'products',
            ['code'],
            (Products item) => <String, Object?>{
                  'code': item.code,
                  'name': item.name,
                  'bestBefore': _dateTimeConverter.encode(item.bestBefore),
                  'userId': item.userId
                }),
        _productsDeletionAdapter = DeletionAdapter(
            database,
            'products',
            ['code'],
            (Products item) => <String, Object?>{
                  'code': item.code,
                  'name': item.name,
                  'bestBefore': _dateTimeConverter.encode(item.bestBefore),
                  'userId': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Products> _productsInsertionAdapter;

  final UpdateAdapter<Products> _productsUpdateAdapter;

  final DeletionAdapter<Products> _productsDeletionAdapter;

  @override
  Future<List<Products>> findAllProductsById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Products WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Products(
            row['code'] as int?,
            row['name'] as String,
            _dateTimeConverter.decode(row['bestBefore'] as int),
            row['userId'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertProduct(Products product) async {
    await _productsInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProducts(Products product) async {
    await _productsUpdateAdapter.update(product, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteProducts(Products task) async {
    await _productsDeletionAdapter.delete(task);
  }
}

class _$RecipesDao extends RecipesDao {
  _$RecipesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _recipesInsertionAdapter = InsertionAdapter(
            database,
            'recipes',
            (Recipes item) => <String, Object?>{
                  'recipeCode': item.recipeCode,
                  'name': item.name,
                  'testo': item.testo,
                  'ingredient': item.ingredient,
                  'userId': item.userId
                }),
        _recipesDeletionAdapter = DeletionAdapter(
            database,
            'recipes',
            ['recipeCode'],
            (Recipes item) => <String, Object?>{
                  'recipeCode': item.recipeCode,
                  'name': item.name,
                  'testo': item.testo,
                  'ingredient': item.ingredient,
                  'userId': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Recipes> _recipesInsertionAdapter;

  final DeletionAdapter<Recipes> _recipesDeletionAdapter;

  @override
  Future<List<Recipes>> findAllRecipes(String ingredient) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Recipes WHERE ingredient = ?1',
        mapper: (Map<String, Object?> row) => Recipes(
            row['recipeCode'] as int?,
            row['name'] as String,
            row['testo'] as String,
            row['ingredient'] as String,
            row['userId'] as int),
        arguments: [ingredient]);
  }

  @override
  Future<List<Recipes>> findAllRecipesWithId(
    String ingredient,
    int id,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Recipes WHERE ingredient = ?1 and userId = ?2',
        mapper: (Map<String, Object?> row) => Recipes(
            row['recipeCode'] as int?,
            row['name'] as String,
            row['testo'] as String,
            row['ingredient'] as String,
            row['userId'] as int),
        arguments: [ingredient, id]);
  }

  @override
  Future<void> insertRecipes(Recipes recipe) async {
    await _recipesInsertionAdapter.insert(recipe, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRecipes(Recipes task) async {
    await _recipesDeletionAdapter.delete(task);
  }
}

class _$UsersDao extends UsersDao {
  _$UsersDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _usersInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (Users item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'gender': item.gender,
                  'weight': item.weight,
                  'height': item.height
                }),
        _usersUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (Users item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'gender': item.gender,
                  'weight': item.weight,
                  'height': item.height
                }),
        _usersDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (Users item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'gender': item.gender,
                  'weight': item.weight,
                  'height': item.height
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Users> _usersInsertionAdapter;

  final UpdateAdapter<Users> _usersUpdateAdapter;

  final DeletionAdapter<Users> _usersDeletionAdapter;

  @override
  Future<Users?> findUserByIdAndName(
    int id,
    String name,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM Users WHERE id = ?1 and username = ?2',
        mapper: (Map<String, Object?> row) => Users(
            row['id'] as int?,
            row['username'] as String,
            row['password'] as String,
            row['gender'] as String?,
            row['weight'] as int?,
            row['height'] as int?),
        arguments: [id, name]);
  }

  @override
  Future<Users?> userByCredentials(
    String username,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM Users WHERE username = ?1 and password = ?2',
        mapper: (Map<String, Object?> row) => Users(
            row['id'] as int?,
            row['username'] as String,
            row['password'] as String,
            row['gender'] as String?,
            row['weight'] as int?,
            row['height'] as int?),
        arguments: [username, password]);
  }

  @override
  Future<List<Users?>> userByUsername(String username) async {
    return _queryAdapter.queryList('SELECT * FROM Users WHERE username = ?1',
        mapper: (Map<String, Object?> row) => Users(
            row['id'] as int?,
            row['username'] as String,
            row['password'] as String,
            row['gender'] as String?,
            row['weight'] as int?,
            row['height'] as int?),
        arguments: [username]);
  }

  @override
  Future<List<Users?>> findAllUser() async {
    return _queryAdapter.queryList('SELECT * FROM Users',
        mapper: (Map<String, Object?> row) => Users(
            row['id'] as int?,
            row['username'] as String,
            row['password'] as String,
            row['gender'] as String?,
            row['weight'] as int?,
            row['height'] as int?));
  }

  @override
  Future<void> insertUser(Users user) async {
    await _usersInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUsers(Users users) async {
    await _usersUpdateAdapter.update(users, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUsers(Users user) async {
    await _usersDeletionAdapter.delete(user);
  }
}

class _$FoodEatedDao extends FoodEatedDao {
  _$FoodEatedDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _foodEatedInsertionAdapter = InsertionAdapter(
            database,
            'foodEated',
            (FoodEated item) => <String, Object?>{
                  'foodEatedcode': item.foodEatedcode,
                  'kcal': item.kcal,
                  'dateEated': _dateTimeConverter.encode(item.dateEated),
                  'userId': item.userId
                }),
        _foodEatedUpdateAdapter = UpdateAdapter(
            database,
            'foodEated',
            ['foodEatedcode'],
            (FoodEated item) => <String, Object?>{
                  'foodEatedcode': item.foodEatedcode,
                  'kcal': item.kcal,
                  'dateEated': _dateTimeConverter.encode(item.dateEated),
                  'userId': item.userId
                }),
        _foodEatedDeletionAdapter = DeletionAdapter(
            database,
            'foodEated',
            ['foodEatedcode'],
            (FoodEated item) => <String, Object?>{
                  'foodEatedcode': item.foodEatedcode,
                  'kcal': item.kcal,
                  'dateEated': _dateTimeConverter.encode(item.dateEated),
                  'userId': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FoodEated> _foodEatedInsertionAdapter;

  final UpdateAdapter<FoodEated> _foodEatedUpdateAdapter;

  final DeletionAdapter<FoodEated> _foodEatedDeletionAdapter;

  @override
  Future<List<FoodEated?>> findAllFoodEatedById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM foodEated WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => FoodEated(
            row['foodEatedcode'] as int?,
            row['kcal'] as int,
            _dateTimeConverter.decode(row['dateEated'] as int),
            row['userId'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertFoodEated(FoodEated food) async {
    await _foodEatedInsertionAdapter.insert(food, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateFoodEated(FoodEated food) async {
    await _foodEatedUpdateAdapter.update(food, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteFoodEated(FoodEated task) async {
    await _foodEatedDeletionAdapter.delete(task);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
