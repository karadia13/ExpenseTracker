import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class delitem extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<delitem> {
  final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController no = new TextEditingController();
  TextEditingController email = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remove Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Category",
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
                primary: Colors.blue,
              ),
              onPressed: () {
                firestoreInstance
                    .collection('expenses')
                    .doc('admin')
                    .update({
                  "category": FieldValue.delete(),
                  "amount": FieldValue.delete(),
                })
                    .then((value) => print("success"))
                    .catchError((error) => print("Error: $error"));
              },
              child: Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
