import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:quiz/screens/home.dart';

// Function to load JSON from assets
Future<List<Map<String, dynamic>>> loadQuestions() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((data) => data as Map<String, dynamic>).toList();
}

// Function to get 5 random questions from the specified category
List<Map<String, dynamic>> getRandomQuestions(
    List<Map<String, dynamic>> data, String category) {
  var categoryData =
      data.firstWhere((item) => item['name'] == category, orElse: () => {});
  List<dynamic> questions = categoryData['questions'] ?? [];

  if (questions.length < 5) {
    return List<Map<String, dynamic>>.from(questions);
  }

  final random = Random();
  List<Map<String, dynamic>> randomQuestions = [];
  while (randomQuestions.length < 5) {
    var question = questions[random.nextInt(questions.length)];
    if (!randomQuestions.contains(question)) {
      randomQuestions.add(question);
    }
  }
  return randomQuestions;
}

class Quiz extends StatefulWidget {
  final String category;

  const Quiz({super.key, required this.category});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late List<Map<String, dynamic>> randomQuestions = [];
  List<String> userAnswers = [];
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions().then((data) {
      setState(() {
        randomQuestions = getRandomQuestions(data, widget.category);
      });
    });
  }

  // Function to move to the next question
  void nextQuestion(String answer) {
    setState(() {
      userAnswers.add(answer); // Store the answer
      currentQuestionIndex++; // Move to the next question
    });
  }

  // Function to generate and display the result
  String generateResult() {
    int score = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i] == randomQuestions[i]['correctAnswer']) {
        score++;
      }
    }
    return "Your score is: $score / ${randomQuestions.length}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: Text(
          currentQuestionIndex < randomQuestions.length
              ? 'Question ${currentQuestionIndex + 1}/${randomQuestions.length}'
              : 'Complete', // Show 'Complete' when all questions are answered
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        leading: currentQuestionIndex < randomQuestions.length
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              )
            : Icon(
                Icons.arrow_back,
                color: Colors.deepPurpleAccent,
              ),
        actions: [
          currentQuestionIndex < randomQuestions.length
              ? IconButton(
                  onPressed: () {
                    // Move to the next question when the right arrow is clicked
                    nextQuestion('');
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    // Show the result when all questions are answered
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Quiz Completed"),
                              content: Text(generateResult()),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/home', // Use the named route '/home'
                                      (Route<dynamic> route) =>
                                          false, // This removes all previous routes
                                    );
                                  },
                                  child: Text("Close"),
                                ),
                              ],
                            ));
                  },
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
      body: randomQuestions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : currentQuestionIndex < randomQuestions.length
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      randomQuestions[currentQuestionIndex]['questionText'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ...List.generate(
                        randomQuestions[currentQuestionIndex]['answers'].length,
                        (index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            nextQuestion(randomQuestions[currentQuestionIndex]
                                ['answers'][index]);
                          },
                          child: Text(randomQuestions[currentQuestionIndex]
                              ['answers'][index]),
                        ),
                      );
                    }),
                    SizedBox(height: 25),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Thank You for completing the quiz!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Text(
          "Created By @RuchitaGhate",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }
}
