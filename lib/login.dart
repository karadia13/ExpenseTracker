import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'admin/form.dart';
import 'package:flutter_app/homepage_ui/main.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../register.dart';

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
      home: MyLoginPage(),
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

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String email, password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String emailError, passwordError;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SpendWise"),
      ),
      body: Center(
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
                      backgroundImage:
                      AssetImage('assets/images/financelogo.jpg'),
                    ),
                    Container(
                      margin: EdgeInsets.all(25),
                    ),
                    Text(
                      "Login Page",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20.0,
                          color: Colors.white),
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
                          setState(() {
                            email = value;
                            emailError = null; // Reset email error on change
                          });
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
                          return emailError;
                        },
                      ),
                    ),
                    if (emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          emailError,
                          style: TextStyle(color: Colors.red),
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
                          setState(() {
                            password = value;
                            passwordError = null; // Reset password error on change
                          });
                        },
                        decoration: buildInputDecoration(
                          Icons.lock,
                          "Enter your Password",
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
                          return passwordError;
                        },
                      ),
                    ),
                    if (passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          passwordError,
                          style: TextStyle(color: Colors.red),
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
                            var newUser =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);

                            print(newUser.toString());
                            if (newUser != null) {
                              setState(() {
                                showProgress = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()));
                            } else {
                              setState(() {
                                showProgress = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              showProgress = false;
                              if (e.code == 'user-not-found') {
                                emailError = 'Email not found';
                              } else if (e.code == 'wrong-password') {
                                passwordError = 'Wrong password';
                              }
                            });
                          }
                        },
                        minWidth: 200.0,
                        height: 45.0,
                        child: Text(
                          "Login",
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
                              builder: (context) => MyRegisterPage()),
                        );
                      },
                      child: Text(
                        "New user? Register Now",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FormPage()),
                        );
                      },
                      child: Text(
                        "Are you an admin?",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
