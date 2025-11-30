import 'package:floor/floor.dart';

@DatabaseView(
  '''
  SELECT 
    burger_menu.id,
    burger_menu.title,
    burger_menu.image,
    burger_menu.price,
    burger_menu.category,
    COALESCE(AVG(menu_ratings.rating), 0.0) AS rating,
    COUNT(menu_ratings.rating) AS ratingCount,
    (SELECT comment FROM menu_ratings WHERE menuId = burger_menu.id ORDER BY createdAt DESC LIMIT 1) AS latestComment,
    (SELECT createdAt FROM menu_ratings WHERE menuId = burger_menu.id ORDER BY createdAt DESC LIMIT 1) AS latestTimestamp
  FROM burger_menu
  LEFT JOIN menu_ratings ON burger_menu.id = menu_ratings.menuId
  GROUP BY burger_menu.id
  ''',
  viewName: 'show_reviews'
)
class ShowReviwes {
  final int? id;
  final String title;
  final String image;
  final double price;
  final String category;
  final double rating;
  final int ratingCount;
  final String? latestComment;
  final int? latestTimestamp;

  const ShowReviwes({
    this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.category,
    required this.rating,
    required this.ratingCount,
    this.latestComment,
    this.latestTimestamp,
  });
}