import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet/menu_rating_entity.dart';
import 'package:gourmet/show_reviews.dart';
import 'review_page.dart';
import 'main.dart';
import 'package:intl/intl.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        surfaceTintColor: const Color(0xFF1E1E1E),
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.amber, size: 28),
            SizedBox(width: 10),
            Text(
              'Admin Dashboard',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        leading: const BackButton(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.verified_user, color: Colors.amber, size: 28),
          ),
        ],
      ),
      body: FutureBuilder<List<ShowReviwes>>(
        future: database.menuRatingDao.selectItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          final dishes = snapshot.data!;
          final totalRatings = dishes.fold<int>(
            0,
            (sum, d) => sum + d.ratingCount,
          );
          final avgRating = totalRatings == 0
              ? 0.0
              : dishes.fold<double>(
                      0,
                      (sum, d) => sum + (d.rating * d.ratingCount),
                    ) /
                    totalRatings;

          // ترتيب الأطباق
          final sortedByRating = List<ShowReviwes>.from(dishes)
            ..sort((a, b) => b.rating.compareTo(a.rating));
          final top3 = sortedByRating.take(3).toList();
          final worst3 = sortedByRating.reversed.take(3).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Ratings + Avg Rating (كروت منفصلة)
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Ratings',
                        '$totalRatings',
                        Icons.rate_review_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Avg Rating',
                        avgRating.toStringAsFixed(1),
                        Icons.star_border,
                        isRating: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Top Rated Dishes
                _buildSectionTitle('Top Rated Dishes'),
                const SizedBox(height: 12),
                ...top3.map(
                  (dish) => _buildRankedDishCard(
                    dish,
                    top3.indexOf(dish) + 1,
                    Colors.amber,
                  ),
                ),

                const SizedBox(height: 24),

                // Needs Improvement
                _buildSectionTitle('Needs Improvement'),
                const SizedBox(height: 12),
                ...worst3.map(
                  (dish) => _buildRankedDishCard(
                    dish,
                    null,
                    Colors.red,
                    isWarning: true,
                  ),
                ),

                const SizedBox(height: 24),

                // Latest Customer Ratings
                _buildSectionTitle('Latest Customer Ratings'),
                const SizedBox(height: 12),
                FutureBuilder<List<MenuRating>>(
                  future: database.menuRatingDao
                      .getLatestReviews(), // هنضيفها تحت
                  builder: (context, reviewSnap) {
                    if (!reviewSnap.hasData) return const SizedBox();
                    final latestReviews = reviewSnap.data!.take(3).toList();
                    return Column(
                      children: latestReviews.map((review) {
                        final dish = dishes.firstWhereOrNull(
                          (d) => d.id == review.menuId,
                        );
                        return _buildLatestReviewCard(
                          review,
                          dish?.title ?? 'Unknown Dish',
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // All Dishes Overview
                _buildSectionTitle('All Dishes Overview'),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dishes.length,
                  itemBuilder: (context, index) {
                    final dish = dishes[index];
                    return _buildAllDishesCard(dish);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon, {
    bool isRating = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRankedDishCard(
    ShowReviwes dish,
    int? rank,
    Color accentColor, {
    bool isWarning = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (rank != null)
            CircleAvatar(
              backgroundColor: accentColor,
              radius: 18,
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (isWarning)
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 36,
            ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              dish.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${dish.rating.toStringAsFixed(1)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${dish.ratingCount} reviews',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestReviewCard(MenuRating review, String dishName) {
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
          Text(
            dishName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                Icons.star,
                size: 20,
                color: i < review.rating.round() ? Colors.amber : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.comment ?? 'No comment',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            DateFormat(
              'dd/MM/yyyy - hh:mm a',
            ).format(DateTime.fromMillisecondsSinceEpoch(review.createdAt)),
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAllDishesCard(ShowReviwes dish) {
    return InkWell(
      onTap: () {
        Get.to(
          () => DishReviewsPage(dish: dish),
          transition: Transition.size,
          curve: Curves.easeInOut,
          preventDuplicates: true,
          duration: Duration(milliseconds: 600),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                dish.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dish.category,
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${dish.rating.toStringAsFixed(1)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${dish.ratingCount} reviews',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
