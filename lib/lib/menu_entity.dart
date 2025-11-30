import 'package:floor/floor.dart';

@Entity(tableName: 'burger_menu')
class Menu {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final double price;
  final String image;
  final String category;
  

  const Menu({
    this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    
  });
}
