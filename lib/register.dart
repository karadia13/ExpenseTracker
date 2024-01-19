import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'admin/form.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyRegisterPage(),
    );
  }
}

InputDecoration buildInputDecoration(
    IconData icons, String hinttext, IconButton suffixIcon) {
  return InputDecoration(
    hintText: hinttext,
    hintStyle: TextStyle(
      color: Colors.white,
    ),
    prefixIcon: Icon(
      icons,
      color: Colors.white,
    ),
    suffixIcon: suffixIcon,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.green, width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
  );
}

class MyRegisterPage extends StatefulWidget {
  @override
  _MyRegisterPageState createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;

  String email, password, name;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SpendWise"),
      ),
      body: Center(
        child: Expanded(
          child: ModalProgressHUD(
            inAsyncCall: showProgress,
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/financebg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 70.0,
                      ),
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage('assets/images/financelogo.jpg'),
                      ),
                      Container(
                        margin: EdgeInsets.all(25),
                      ),
                      Text(
                        "Registration Page",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.white),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: buildInputDecoration(
                              Icons.person, "Enter your email", null),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        child: TextFormField(
                          obscureText: !showPassword,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: buildInputDecoration(
                            Icons.lock,
                            "Enter your password",
                            IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Material(
                        elevation: 5,
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(32.0),
                        child: MaterialButton(
                          onPressed: () async {
                            setState(() {
                              showProgress = true;
                            });
                            try {
                              final newuser =
                              await _auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              if (newuser != null) {
                                // Show success message using SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Account created successfully!'),
                                  ),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyLoginPage(),
                                  ),
                                );

                                setState(() {
                                  showProgress = false;
                                });
                              }
                            } catch (e) {
                              setState(() {
                                showProgress = false;
                              });

                              String errorMessage;
                              if (e is FirebaseAuthException) {
                                if (e.code == 'email-already-in-use') {
                                  errorMessage = 'Account already exists for this email.';
                                } else {
                                  errorMessage = 'Error: ${e.message}';
                                }
                              } else {
                                errorMessage = 'An unexpected error occurred.';
                              }

                              // Show error message using SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                ),
                              );

                              // Allow the user to fill the form again
                              _formkey.currentState.reset();
                            }
                          },
                          minWidth: 200.0,
                          height: 45.0,
                          child: Text(
                            "Register",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyLoginPage()),
                          );
                        },
                        child: Text(
                          "Already Registered? Login Now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w900),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
