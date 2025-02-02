import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz/screens/quiz/quiz.dart';

class Categories extends StatelessWidget {
  final String Categories_name;
  final String Categories_des;
  const Categories(
      {super.key, required this.Categories_name, required this.Categories_des});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Mkcl Quiz",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.xmark,
              color: Colors.white,
            )),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz,
            size: 100,
            color: Colors.white,
          ),
          SizedBox(
            width: double.infinity,
            height: 10,
          ),
          Text(
            Categories_name,
            style: TextStyle(
                fontSize: 27, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              Categories_des,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 15,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Quiz(
                              category: Categories_name,
                            )));
              },
              child: Text("Start Quiz"))
        ],
      ),
    );
  }
}
