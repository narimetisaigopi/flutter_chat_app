import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTextEditingController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter Email",
                      border: OutlineInputBorder())),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.text,
                controller: _passwordTextEditingController,
                decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter Password",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text("Login")),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => RegisterScreen()));
                  },
                  child: Text("Create new account"))
            ],
          ),
        ),
      ),
    );
  }

  login() {
    String email = _emailTextEditingController.text;
    String password = _passwordTextEditingController.text;

    print("  $email  >>>> $password");
  }
}
