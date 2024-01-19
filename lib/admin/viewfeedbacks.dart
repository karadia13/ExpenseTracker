import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class feedapp extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("feedbacks"),
      ),
      body: StreamBuilder(
          stream: firestoreInstance.collection("feedback").snapshots(),
          // ignore: non_constant_identifier_names
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> Querysnapshot) {
            if (Querysnapshot.hasError) {
              return Text("Error");
            }
            if (Querysnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              final data = Querysnapshot.data.docs;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text('${data[index]['phone']}'),
                    subtitle: Text('${data[index]['comment']}'),
                    isThreeLine: true,
                  );
                },
              );
            } //else
          }),
    );
  }
}
