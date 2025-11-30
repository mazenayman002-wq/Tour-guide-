import 'package:gourmet/menu_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class MenuDao {
  @Query('SELECT * FROM burger_menu')
  Future<List<Menu>> selectItemsFromMenu();
  @Query('SELECT * FROM burger_menu where category=:category')
  Future<List<Menu>> selectCategory(String category);
  @update
  Future<void> updateMenuRating(Menu menu);
  @Query('SELECT * FROM burger_menu WHERE id = :id')
  Future<Menu?> getMenuById(int id);
  
}
