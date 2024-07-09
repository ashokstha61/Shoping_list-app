import 'package:shoping_app/models/category.dart';

class GroceryItem {
  final String id;
  final String name;
  final num quantity;
  final Category category;

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });
}
