// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $MenuDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $MenuDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $MenuDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<MenuDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorMenuDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $MenuDatabaseBuilderContract databaseBuilder(String name) =>
      _$MenuDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $MenuDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$MenuDatabaseBuilder(null);
}

class _$MenuDatabaseBuilder implements $MenuDatabaseBuilderContract {
  _$MenuDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $MenuDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $MenuDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<MenuDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$MenuDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$MenuDatabase extends MenuDatabase {
  _$MenuDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MenuDao? _menuDaoInstance;

  MenuRatingDao? _menuRatingDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `burger_menu` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `price` REAL NOT NULL, `image` TEXT NOT NULL, `category` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `menu_ratings` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `menuId` INTEGER NOT NULL, `rating` REAL NOT NULL, `comment` TEXT, `createdAt` INTEGER NOT NULL)');

        await database.execute(
            'CREATE VIEW IF NOT EXISTS `show_reviews` AS   SELECT \n    burger_menu.id,\n    burger_menu.title,\n    burger_menu.image,\n    burger_menu.price,\n    burger_menu.category,\n    COALESCE(AVG(menu_ratings.rating), 0.0) AS rating,\n    COUNT(menu_ratings.rating) AS ratingCount,\n    (SELECT comment FROM menu_ratings WHERE menuId = burger_menu.id ORDER BY createdAt DESC LIMIT 1) AS latestComment,\n    (SELECT createdAt FROM menu_ratings WHERE menuId = burger_menu.id ORDER BY createdAt DESC LIMIT 1) AS latestTimestamp\n  FROM burger_menu\n  LEFT JOIN menu_ratings ON burger_menu.id = menu_ratings.menuId\n  GROUP BY burger_menu.id\n  ');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MenuDao get menuDao {
    return _menuDaoInstance ??= _$MenuDao(database, changeListener);
  }

  @override
  MenuRatingDao get menuRatingDao {
    return _menuRatingDaoInstance ??= _$MenuRatingDao(database, changeListener);
  }
}

class _$MenuDao extends MenuDao {
  _$MenuDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _menuUpdateAdapter = UpdateAdapter(
            database,
            'burger_menu',
            ['id'],
            (Menu item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'image': item.image,
                  'category': item.category
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final UpdateAdapter<Menu> _menuUpdateAdapter;

  @override
  Future<List<Menu>> selectItemsFromMenu() async {
    return _queryAdapter.queryList('SELECT * FROM burger_menu',
        mapper: (Map<String, Object?> row) => Menu(
            id: row['id'] as int?,
            title: row['title'] as String,
            price: row['price'] as double,
            image: row['image'] as String,
            category: row['category'] as String));
  }

  @override
  Future<List<Menu>> selectCategory(String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM burger_menu where category=?1',
        mapper: (Map<String, Object?> row) => Menu(
            id: row['id'] as int?,
            title: row['title'] as String,
            price: row['price'] as double,
            image: row['image'] as String,
            category: row['category'] as String),
        arguments: [category]);
  }

  @override
  Future<Menu?> getMenuById(int id) async {
    return _queryAdapter.query('SELECT * FROM burger_menu WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Menu(
            id: row['id'] as int?,
            title: row['title'] as String,
            price: row['price'] as double,
            image: row['image'] as String,
            category: row['category'] as String),
        arguments: [id]);
  }

  @override
  Future<void> updateMenuRating(Menu menu) async {
    await _menuUpdateAdapter.update(menu, OnConflictStrategy.abort);
  }
}

class _$MenuRatingDao extends MenuRatingDao {
  _$MenuRatingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _menuRatingInsertionAdapter = InsertionAdapter(
            database,
            'menu_ratings',
            (MenuRating item) => <String, Object?>{
                  'id': item.id,
                  'menuId': item.menuId,
                  'rating': item.rating,
                  'comment': item.comment,
                  'createdAt': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MenuRating> _menuRatingInsertionAdapter;

  @override
  Future<List<MenuRating>> selectReviews() async {
    return _queryAdapter.queryList('SELECT * FROM menu_ratings',
        mapper: (Map<String, Object?> row) => MenuRating(
            id: row['id'] as int?,
            menuId: row['menuId'] as int,
            rating: row['rating'] as double,
            comment: row['comment'] as String?,
            createdAt: row['createdAt'] as int));
  }

  @override
  Future<List<ShowReviwes>> selectItems() async {
    return _queryAdapter.queryList('SELECT * FROM show_reviews',
        mapper: (Map<String, Object?> row) => ShowReviwes(
            id: row['id'] as int?,
            title: row['title'] as String,
            image: row['image'] as String,
            price: row['price'] as double,
            category: row['category'] as String,
            rating: row['rating'] as double,
            ratingCount: row['ratingCount'] as int,
            latestComment: row['latestComment'] as String?,
            latestTimestamp: row['latestTimestamp'] as int?));
  }

  @override
  Future<List<ShowReviwes>> selectCategory(String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM show_reviews where category=?1',
        mapper: (Map<String, Object?> row) => ShowReviwes(
            id: row['id'] as int?,
            title: row['title'] as String,
            image: row['image'] as String,
            price: row['price'] as double,
            category: row['category'] as String,
            rating: row['rating'] as double,
            ratingCount: row['ratingCount'] as int,
            latestComment: row['latestComment'] as String?,
            latestTimestamp: row['latestTimestamp'] as int?),
        arguments: [category]);
  }

  @override
  Future<ShowReviwes?> getMenuById(int id) async {
    return _queryAdapter.query('SELECT * FROM show_reviews WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ShowReviwes(
            id: row['id'] as int?,
            title: row['title'] as String,
            image: row['image'] as String,
            price: row['price'] as double,
            category: row['category'] as String,
            rating: row['rating'] as double,
            ratingCount: row['ratingCount'] as int,
            latestComment: row['latestComment'] as String?,
            latestTimestamp: row['latestTimestamp'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<MenuRating>> getReviewsForDish(int menuId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM menu_ratings WHERE menuId = ?1 ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => MenuRating(
            id: row['id'] as int?,
            menuId: row['menuId'] as int,
            rating: row['rating'] as double,
            comment: row['comment'] as String?,
            createdAt: row['createdAt'] as int),
        arguments: [menuId]);
  }

  @override
  Future<List<MenuRating>> getLatestReviews() async {
    return _queryAdapter.queryList(
        'SELECT * FROM menu_ratings ORDER BY createdAt DESC LIMIT 10',
        mapper: (Map<String, Object?> row) => MenuRating(
            id: row['id'] as int?,
            menuId: row['menuId'] as int,
            rating: row['rating'] as double,
            comment: row['comment'] as String?,
            createdAt: row['createdAt'] as int));
  }

  @override
  Future<void> insertReview(MenuRating review) async {
    await _menuRatingInsertionAdapter.insert(review, OnConflictStrategy.abort);
  }
}
