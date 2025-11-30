import 'package:floor/floor.dart';

@Entity(tableName: 'menu_ratings')
class MenuRating {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int menuId;
  final double rating;
  final String? comment;
  final int createdAt;

  MenuRating({
    this.id,
    required this.menuId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
