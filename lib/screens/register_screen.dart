import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                    register();
                  },
                  child: Text("Register")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Alreay had an account?"))
            ],
          ),
        ),
      ),
    );
  }

  register() {
    String email = _emailTextEditingController.text;
    String password = _passwordTextEditingController.text;

    print("  $email  >>>> $password");
  }
}
