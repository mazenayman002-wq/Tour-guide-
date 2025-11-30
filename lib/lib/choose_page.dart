import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gourmet/admin_panel.dart';
import 'package:gourmet/menu_page.dart';

class ChoosePage extends StatelessWidget {
  ChoosePage({super.key});
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Stack(
        children:[ const FLoatingDishes(),SafeArea(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black,
              ),
              width: Get.width * 0.9,
              height: Get.height * 0.83,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      Container(
                        width: Get.width * 0.8,
                        height: Get.height * 0.38,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/second_image.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFf7b127),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      buildText(
                        message: "Resturant\nSurvey system",
                        fontsize: 25,
                        fontweight: FontWeight.bold,
                        color: const Color(0xFFf7b127),
                      ),
                      buildText(
                        message:
                            'Rate dishes, request changes\nand manage your restaurant',
                        fontsize: 16,
                        fontweight: FontWeight.normal,
                        color: const Color.fromARGB(255, 110, 109, 109),
                      ),
                      SizedBox(height: 20),
                      buildButton(
                        page: MenuPage(),
                        backgroundColor: Color(0xFFf7b127),
                        forgroundColor: Colors.black,
                        icon: Icons.person_outline_outlined,
                        message: 'Guest/User',
                      ),
                      buildButton(
                        page: AdminPanel(),
                        backgroundColor: const Color.fromARGB(255, 68, 68, 68),
                        forgroundColor: Colors.white,
                        icon: Icons.verified_user_outlined,
                        message: 'Admin Panel',
                      ),
                      // buildButton(
                      //   page: ChefDashboard(),
                      //   backgroundColor: const Color.fromARGB(255, 68, 68, 68),
                      //   forgroundColor: Colors.white,
                      //   icon: Icons.fastfood_outlined,
                      //   message: 'Chef Dashboard',
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildText({
    required String message,
    required double fontsize,
    required FontWeight fontweight,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: GoogleFonts.lato(
          fontSize: fontsize,
          fontWeight: fontweight,
          color: color,
        ),
      ),
    );
  }

  Widget buildButton({
    required Widget page,
    required Color backgroundColor,
    required Color forgroundColor,
    required IconData icon,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: Get.width * 0.75,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
           
              Get.to(page,transition: Transition.size,curve: Curves.easeInOut,preventDuplicates: true,duration: Duration(milliseconds: 600));
            

            //
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor, 
            foregroundColor: forgroundColor, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              SizedBox(width: 8),
              Text(
                message,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ========= أطباق تتخبط وترجع + موفر للبطارية 100% =========
class FLoatingDishes extends StatelessWidget {
  const FLoatingDishes({super.key});

  final List<String> dishes = const [
    "assets/images/buns.jpg",
    "assets/images/cheese.jpg",
    "assets/images/lettece.jpg",
    "assets/images/Onions.jpg",
    "assets/images/patty.jpg",
    "assets/images/tomatoes.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(7, (i) => BouncingDish(
          imagePath: dishes[i % dishes.length],
          index: i,
        )),
      ),
    );
  }
}

class BouncingDish extends StatefulWidget {
  final String imagePath;
  final int index;
  const BouncingDish({required this.imagePath, required this.index, super.key});

  @override
  State<BouncingDish> createState() => _BouncingDishState();
}

class _BouncingDishState extends State<BouncingDish>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late double speedX, speedY;

  @override
  void initState() {
    super.initState();
    
    final random = Random();
    speedX = (random.nextBool() ? 1 : -1) * (30 + random.nextDouble() * 40);
    speedY = (random.nextBool() ? 1 : -1) * (30 + random.nextDouble() * 40);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // دورة كبيرة عشان ما يحسبش كتير
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final size = 90.0;
        final t = _controller.value;

        // حركة بتخبط في الجدار باستخدام triangle wave (أحسن من sin وأخف)
        double bounce(double period, double speed) {
          double p = t * period + widget.index * 0.1;
          return (2 * (p - p.floor()) - 1).abs() * speed;
        }

        double x = bounce(1.7, Get.width - size) + size / 2;
        double y = bounce(2.3, Get.height - size) + size / 2;

        return Positioned(
          left: x - size / 2,
          top: y - size / 2,
          child: Transform.rotate(
            angle: sin(t * 8 + widget.index) * 0.12,
            child: Opacity(
              opacity: 0.65,
              child: Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
                ),
                child: ClipOval(child: Image.asset(widget.imagePath, fit: BoxFit.cover)),
              ),
            ),
          ),
        );
      },
    );
  }
}