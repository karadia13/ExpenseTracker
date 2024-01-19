import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/homepage_ui/expense_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'mont'),
      home: ViewExpense(),
    );
  }
}

class ViewExpense extends StatefulWidget {
  @override
  _ViewExpenseState createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _user;
  List<Expense> expenses = [];
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User user) {
      setState(() {
        _user = user;
      });

      if (_user!=null) {
        _loadExpensesFromFirestore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpendWise'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Expenses',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                _user != null ? _buildExpensesList() : _buildLoginPrompt(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _addExpense(context),
                  child: Text('Add Expense'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpensesList() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(expenses[index].description),
              subtitle: Text(
                '${expenses[index].category} - ₹${expenses[index].amount.toStringAsFixed(2)}',
              ),
              trailing: Text(
                '${expenses[index].date.month}/${expenses[index].date.day}/${expenses[index].date.year}',
              ),
            );
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLoginPrompt() {
    return Column(
      children: [
        Text(
          'Please log in to view expenses.',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Implement your login logic here.
          },
          child: Text('Log In'),
        ),
      ],
    );
  }

  Future<void> _addExpense(BuildContext context) async {
    if (_user == null) {
      _showLoginPrompt(context);
      return;
    }

    categoryController.clear();
    amountController.clear();
    descriptionController.clear();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Column(
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (categoryController.text.isNotEmpty &&
                    amountController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  await _saveExpenseToFirestore(
                    categoryController.text,
                    double.parse(amountController.text),
                    descriptionController.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Expense saved successfully!'),
                    ),
                  );

                  setState(() {
                    // Refresh the screen.
                    _loadExpensesFromFirestore();
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLoginPrompt(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log In Required'),
          content: Text('Please log in to add expenses.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveExpenseToFirestore(
      String category,
      double amount,
      String description,
      ) async {
    try {
      await _firestore.collection('users').doc(_user.uid).collection('expenses').add({
        'category': category,
        'amount': amount,
        'description': description,
        'date': DateTime.now(),
      });
    } catch (e) {
      print('Error saving expense to Firestore: $e');
    }
  }

  Future<void> _loadExpensesFromFirestore() async {
    try {
      if (_user != null) {
        QuerySnapshot querySnapshot = await _firestore.collection('users').doc(_user.uid).collection('expenses').get();

        setState(() {
          expenses = querySnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Expense(
              category: data['category'],
              amount: data['amount'],
              description: data['description'],
              date: (data['date'] as Timestamp).toDate(),
            );
          }).toList();
        });
      }
    } catch (e) {
      print('Error loading expenses from Firestore: $e');
    }
  }
}
