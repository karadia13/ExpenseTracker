import 'package:flutter/material.dart';
import 'package:flutter_app/homepage_ui/Feedback.dart';
import 'package:flutter_app/login.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/images/financelogo.jpg'),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "SpendWise",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "WELCOME ",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),


      ListTile(
        onTap: () async {
          // Show confirmation dialog
          bool confirmLogout = await _showLogoutConfirmation(context);
          if (confirmLogout) {
            // Destroy the session or perform logout actions here
            // For now, navigate to the home page
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyLoginPage()),
                  (route) => false,
            );
          }
        },
        leading: Icon(
          Icons.login_outlined,
          color: Colors.black,
        ),
        title: Text("Log Out"),
      ),
    ]);
  }

  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the logout
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the logout
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
