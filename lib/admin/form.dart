import 'package:flutter/material.dart';
import 'package:flutter_app/login.dart';
import 'adminopreations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FormPage(),
    );
  }
}

InputDecoration buildInputDecoration(IconData icons, String hinttext) {
  return InputDecoration(
    hintText: hinttext,
    hintStyle: TextStyle(
      color: Colors.white,
    ),
    prefixIcon: Icon(
      icons,
      color: Colors.white,
    ),
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

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String name, email, phone;
  //TextController to read text entered in text field
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),

        elevation: 2.0,
        centerTitle: true,
        title: Text(
          "Admin",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyLoginPage()),
            );
          },
        ),
      ),
      body: Center(
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
              children: [
                SizedBox(
                  height: 100.0,
                ),
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/images/financelogo.jpg'),
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.email, "Email"),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (value != "spendwise@gmail.com") {
                        return 'not a valid Email';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      email = value;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: buildInputDecoration(Icons.lock, "Password"),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your Password';
                      }
                      if (password.text != "adminofspendwise") {
                        return "Wrong password";
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(
                  width: 200,
                  height: 50,
                  // ignore: deprecated_member_use
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        print("successful");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminHome()),
                        );
                      } else {
                        print("Unsuccessful");
                      }
                    },
                    child: Text("Submit"),
                  ),
                )
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  RaisedButton({MaterialAccentColor color, Future Function() onPressed, RoundedRectangleBorder shape, Color textColor, Text child}) {}
}
