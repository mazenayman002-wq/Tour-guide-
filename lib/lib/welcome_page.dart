import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gourmet/choose_page.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
   WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        children: [
          SizedBox.expand(
            child: Lottie.asset(
              'assets/animation/Star_Skin.json',
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ),
      
          // 2. طبقة بيضاء شفافة عشان المحتوى يبان واضح
         // Container(color: Colors.black87),
          
           SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFf7b127),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFf7b127),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.restaurant_menu_sharp,
                        color: Colors.black87,
                        size: 35,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/main_page_image.jpg'),
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
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome to\n   Gourmet',
                      style: GoogleFonts.greatVibes(
                        color: const Color(0xFFf7b127),
                        fontSize: 45,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
        
                    Text(
                      'Your experience makes our table better',
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(203, 255, 255, 255),
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Share your thoughts with us',
                      style: GoogleFonts.lato(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 30),
        
                    Container(
                      width: Get.width * 0.9,
                      height: 40,
        
                      decoration: BoxDecoration(
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
        
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            const Color(0xFFf7b127),
                          ),
                        ),
                        onPressed: () {
                              Get.to(ChoosePage(),transition: Transition.size,curve: Curves.easeInOut,preventDuplicates: true,duration: Duration(milliseconds: 600));
                        },
                        child: Text(
                          "Let's get started",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Premium dining experience, crafted with care',
                      style: GoogleFonts.lato(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
        
                  ],
                ),
              ),
            ),
          ),
        ] 
      ),
    );
  }
}
