import 'dart:async'; // StreamController
import 'package:floor/floor.dart';
import 'package:gourmet/menu_rating_dao.dart';
import 'package:gourmet/menu_rating_entity.dart';
import 'package:gourmet/show_reviews.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:gourmet/menu_dao.dart';
import 'package:gourmet/menu_entity.dart';
part 'menu_database.g.dart';

@Database(version: 1, entities: [Menu, MenuRating],views: [ShowReviwes])
abstract class MenuDatabase extends FloorDatabase {
  MenuDao get menuDao;
  MenuRatingDao get menuRatingDao;
}
