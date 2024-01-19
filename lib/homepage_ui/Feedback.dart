import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class Feedback1 extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback1> {
  final phone = TextEditingController();
  final comment = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance;

  String successMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
        title: Text(
          "Feedback",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              buildFeedbackForm(),
              SizedBox(height: 20.0),
              buildNumberField(),

              Row(
                children: [
                  // ignore: deprecated_member_use
                  ElevatedButton(
                    onPressed: () {
                      if (validateInput()) {
                        submitFeedback();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFE5E5E5), // Background color
                      padding: EdgeInsets.all(16.0),
                    ),
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                successMessage,
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateInput() {
    if (phone.text.isEmpty || comment.text.isEmpty) {
      setState(() {
        successMessage = "Please fill in all fields";
      });
      return false;
    }

    return true;
  }

  void submitFeedback() {
    try {
      Map<String, dynamic> data = {
        "phone": phone.text,
        "comment": comment.text,
      };

      var firebaseUser = FirebaseAuth.instance.currentUser;

      firestoreInstance
          .collection("feedback")
          .doc(firebaseUser.uid)
          .set(data)
          .then((value) {
        setState(() {
          successMessage = "Feedback submitted successfully!";
          clearForm();
        });
      }).catchError((error) {
        setState(() {
          successMessage = "Error submitting feedback: $error";
        });
      });
    } catch (e) {
      print('Error submitting feedback: $e');
    }
  }

  void clearForm() {
    setState(() {
      phone.clear();
      comment.clear();
    });
  }

  buildNumberField() {
    return Container(
      height: 150,
      child: Stack(
        children: [
          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone),
              hintText: "Enter your phone number",
              hintStyle: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  buildFeedbackForm() {
    return Container(
      height: 150,
      child: Stack(
        children: [
          TextField(
            controller: comment,
            maxLines: 15,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.feedback),
              hintText: "Please briefly describe the issue",
              hintStyle: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1.0,
                    color: Color(0xFFA6A6A6),
                  ),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
