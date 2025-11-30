import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gourmet/main.dart'; // Assuming this is your database instance
import 'package:gourmet/menu_rating_entity.dart';
import 'package:gourmet/show_reviews.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final menu = <ShowReviwes>[].obs;
  final filteredMenu = <ShowReviwes>[].obs;
  var searchQuery = '';
  final selectedRating = 0.0.obs;
  final isLoading = false.obs;
  final selectedCategory = 'All'.obs;
  final cont = TextEditingController();
  final ratingController = TextEditingController();
  final isPressed = false.obs;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  Future<void> getItems() async {
    try {
      isLoading.value = true;
      final items = await database.menuRatingDao.selectItems();
      menu.value = items;
      filteredMenu.value = items;
    } catch (e, stack) {
      debugPrint('Error loading menu: $e\n$stack');
      Get.snackbar(
        'Error',
        'Failed to load menu. Check database.',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false; // دايمًا هيتعمل حتى لو حصل خطأ
    }
  }

  @override
  void dispose() {
    super.dispose();
    cont.dispose();
    ratingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        surfaceTintColor: const Color(
          0xFF1E1E1E,
        ), 
        scrolledUnderElevation: 0, 
        elevation: 0,
        leading: BackButton(color: Colors.white),
        actions: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFf7b127),
            child: Icon(Icons.person, color: Colors.black, size: 30),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Obx(
        () => isLoading.value
            ? Center(child: CircularProgressIndicator(color: Colors.amber))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Guest 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Rate dishes and request changes',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: cont,
                      onChanged: (value) {
                        searchQuery = value.toLowerCase();
                        applyFilter();
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2C2C2E),
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildButton(
                          message: 'All',
                          selectMessage: 'All',
                          backgroundBefore: const Color(0xFFf7b127),
                          backgroundAfter: Colors.transparent,
                          foregroundBefore: Colors.black,
                          foregroundAfter: Colors.white,
                        ),
                        buildButton(
                          message: 'Beef',
                          selectMessage: 'Beef',
                          backgroundBefore: const Color(0xFFf7b127),
                          backgroundAfter: Colors.transparent,
                          foregroundBefore: Colors.black,
                          foregroundAfter: Colors.white,
                        ),
                        buildButton(
                          message: 'Chicken',
                          selectMessage: 'Chicken',
                          backgroundBefore: const Color(0xFFf7b127),
                          backgroundAfter: Colors.transparent,
                          foregroundBefore: Colors.black,
                          foregroundAfter: Colors.white,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          itemCount: filteredMenu.length,
                          itemBuilder: (context, index) {
                            final menuItem = filteredMenu[index];
                            return SizedBox(
                              width: Get.width * 0.9,
                              height: 170,
                              child: Card(
                                color: const Color(0xFF2C2C2E),
                                elevation: 5,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  menuItem.image,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 5),
                                              Text(
                                                menuItem.title,
                                                style: GoogleFonts.lato(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                menuItem.category,
                                                style: GoogleFonts.lato(
                                                  fontSize: 13.5,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  ...List.generate(
                                                    5,
                                                    (index) => Icon(
                                                      Icons.star,
                                                      size: 14,
                                                      color:
                                                          index <
                                                              menuItem.rating
                                                                  .round()
                                                          ? const Color(
                                                              0xFFf7b127,
                                                            )
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    menuItem.rating
                                                        .toStringAsFixed(1),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 1),
                                                  Text(
                                                    '(${menuItem.ratingCount})',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${menuItem.price} \$',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 300,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.amberAccent,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showRatingDialog(
                                                context,
                                                menuItem,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFf7b127,
                                              ),
                                              foregroundColor: Colors.black,
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.star_border),
                                                Text('Rate Meal'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildButton({
    required String message,
    required String selectMessage,
    required Color backgroundBefore,
    required Color backgroundAfter,
    required Color foregroundBefore,
    required Color foregroundAfter,
  }) {
    return Obx(
      () => TextButton(
        onPressed: () async {
          selectedCategory.value = selectMessage;
          menu.value = selectMessage == 'All'
              ? await database.menuRatingDao.selectItems()
              : await database.menuRatingDao.selectCategory(selectMessage);
          applyFilter();
        },
        style: ButtonStyle(
          backgroundColor: selectedCategory.value == selectMessage
              ? WidgetStatePropertyAll(backgroundBefore)
              : WidgetStatePropertyAll(backgroundAfter),
          foregroundColor: selectedCategory.value == selectMessage
              ? WidgetStatePropertyAll(foregroundBefore)
              : WidgetStatePropertyAll(foregroundAfter),
        ),
        child: Text(message),
      ),
    );
  }

  void applyFilter() {
    final q = searchQuery;
    if (q.isEmpty) {
      filteredMenu.value = menu.toList();
    } else {
      filteredMenu.value = menu
          .where((item) => item.title.toLowerCase().contains(q))
          .toList();
    }
  }

  void showRatingDialog(BuildContext context, ShowReviwes menuItem) {
    TextEditingController commentController = TextEditingController();
    selectedRating.value = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(5),
          elevation: 20,
          backgroundColor: Color(0xFF2C2C2E),
          title: Text(
            'Rate this Meal',
            style: GoogleFonts.lateef(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Obx(
                    () => InkWell(
                      onTap: () => selectedRating.value = index + 1,
                      onHighlightChanged: (highlight) {
                        isPressed.value = highlight;
                      },
                      splashColor: Colors.amber.withValues(alpha: 0.5),
                      highlightColor: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                      child: AnimatedScale(
                        scale: isPressed.value ? 1.2 : 1.0,
                        duration: Duration(milliseconds: 150),
                        child: Icon(
                          Icons.star_rounded,
                          size: 40,
                          color: index < selectedRating.value
                              ? Colors.amber
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: commentController,
                    maxLines: 4,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Share more details about your experience...',
                      labelText: 'Add a comment',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: GoogleFonts.lateef(
                        color: Colors.amber,
                        fontSize: 25,
                      ),
                      filled: true,
                      fillColor: Color(0xFF1E1E1E),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.amber, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.amber, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedRating.value > 0) {
                  await _submitRating(
                    menuItem,
                    selectedRating.value,
                    commentController.text,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Please select a rating!',
                    backgroundColor: Colors.red,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFf7b127),
              ),
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitRating(
    ShowReviwes menuItem,
    double newRating,
    String comment,
  ) async {
    // Validate inputs
    if (menuItem.id == null) {
      Get.snackbar('Error', 'Invalid menu item!', backgroundColor: Colors.red);
      return;
    }

    if (newRating < 1 || newRating > 5) {
      Get.snackbar(
        'Error',
        'Please select a rating between 1 and 5!',
        backgroundColor: Colors.red,
      );
      return;
    }

    // Create MenuRating object - matches your actual entity
    final now = DateTime.now();
    final newMenuRating = MenuRating(
      menuId: menuItem.id!,
      rating: newRating,
      comment: comment.trim().isNotEmpty ? comment.trim() : null,
      createdAt: now.millisecondsSinceEpoch,
    );

    try {
      // Insert into database
      await database.menuRatingDao.insertReview(newMenuRating);

      // Refresh the list from the show_reviews view (which correctly calculates AVG and COUNT)
      final updatedList = await database.menuRatingDao.selectItems();

      menu.value = updatedList;
      filteredMenu.value = updatedList;
      applyFilter(); // Re-apply any active search/filter

      // Success feedback
      Get.back();
      Get.snackbar(
        'Success',
        'Thank you! Your rating has been submitted.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      debugPrint('Rating submission error: $e\n$stackTrace');
      Get.snackbar(
        'Error',
        'Failed to submit rating. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
