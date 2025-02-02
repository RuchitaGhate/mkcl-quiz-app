import 'dart:convert'; // Add this for json decoding
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // Add this to load assets
import 'package:flutter/material.dart';
import 'package:quiz/screens/auth/logIn.dart';
import 'package:quiz/screens/categories.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userEmail = "";
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
    loadCategoriesFromJson();
  }

  // Fetch user email (no changes here)
  Future<void> fetchUserEmail() async {
    // Assume you're using FirebaseAuth as before
    User? user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "No email available";
      });
    }
  }

  // Load categories from the local JSON file
  Future<void> loadCategoriesFromJson() async {
    String data = await rootBundle.loadString('assets/data.json');
    List<dynamic> jsonData = json.decode(data);

    setState(() {
      categories = jsonData.map((category) {
        return {
          'name': category['name'],
          'icon': category['icon'], // Replace with appropriate icon
          'description': category['description'],
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mkcl Quiz",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  userEmail,
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
            backgroundColor: Colors.deepPurpleAccent,
            actions: [
              IconButton(
                onPressed: () async {
                  try {
                    // Sign out from Firebase
                    await FirebaseAuth.instance.signOut();

                    // After signing out, navigate to the Login screen and clear the navigation stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) =>
                          false, // This will remove all routes from the stack
                    );
                  } catch (e) {
                    // Handle any errors that occur during sign out
                    print('Error signing out: $e');
                  }
                },
                icon: Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final category = categories[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            Categories(
                          Categories_name: category['name'],
                          Categories_des: category['description'],
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset(0.0, 0.0);
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            category['name'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            category['description'],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: categories.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
