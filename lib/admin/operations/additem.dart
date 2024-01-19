import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class additem extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<additem> {
  final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController no = new TextEditingController();
  TextEditingController email = new TextEditingController();
  CollectionReference users =
      FirebaseFirestore.instance.collection('expenses');
  Future<void> addExpense() {
    return users
        .add({
          'category': email.text,
          'amount': no.text,
        })
        .then((value) => print("Expense Added"))
        .catchError((error) => print("Failed to add expense: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Category Name",
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              controller: no,
              decoration: InputDecoration(
                labelText: "Amount",
              ),
            ),
            SizedBox(
              height: 12,
            ),
            // ignore: deprecated_member_use
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Set the button color to blue
              ),
              onPressed: () {
                addExpense(); // Call the addUser() function when the button is pressed
              },
              child: Text(
                "add", // Display the text "add"
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
