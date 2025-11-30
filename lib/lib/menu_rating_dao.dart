import 'package:gourmet/menu_rating_entity.dart';
import 'package:floor/floor.dart';
import 'package:gourmet/show_reviews.dart';

@dao
abstract class MenuRatingDao {
  @Query('SELECT * FROM menu_ratings')
  Future<List<MenuRating>> selectReviews();
  @insert  
  Future<void> insertReview(MenuRating review);
  @Query('SELECT * FROM show_reviews')
  Future<List<ShowReviwes>> selectItems();
  @Query('SELECT * FROM show_reviews where category=:category')
  Future<List<ShowReviwes>> selectCategory(String category);
  @Query('SELECT * FROM show_reviews WHERE id = :id')
  Future<ShowReviwes?> getMenuById(int id);
  @Query('SELECT * FROM menu_ratings WHERE menuId = :menuId ORDER BY createdAt DESC')
  Future<List<MenuRating>> getReviewsForDish(int menuId);
  @Query('SELECT * FROM menu_ratings ORDER BY createdAt DESC LIMIT 10')
  Future<List<MenuRating>> getLatestReviews();

}
