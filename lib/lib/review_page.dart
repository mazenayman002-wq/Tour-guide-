import 'package:flutter/material.dart';
import 'package:gourmet/main.dart';
import 'package:gourmet/menu_rating_entity.dart';
import 'package:gourmet/show_reviews.dart';
import 'package:intl/intl.dart';

class DishReviewsPage extends StatelessWidget {
  final ShowReviwes dish;

  const DishReviewsPage({Key? key, required this.dish}) : super(key: key);

  // دالة لتحويل التايم ستامب لتاريخ قابل للقراءة
  String formatDate(int? timestamp) {
    if (timestamp == null) return 'Unknown date';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy - hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Text(dish.title, style: const TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: FutureBuilder<List<MenuRating>>(
        future: database.menuRatingDao.getReviewsForDish(dish.id!), // هنضيف الدالة دي في الـ DAO
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No reviews yet for this dish',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          final reviews = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (i) => Icon(
                        Icons.star,
                        size: 20,
                        color: i < review.rating.round() ? Colors.amber : Colors.grey,
                      )),
                    ),
                    const SizedBox(height: 8),
                    if (review.comment != null && review.comment!.isNotEmpty)
                      Text(
                        review.comment!,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      )
                    else
                      const Text(
                        'No comment',
                        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      formatDate(review.createdAt),
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}