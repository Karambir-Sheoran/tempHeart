import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';


const SERVER_IP = 'https://infinitysmartapi-dev.azurewebsites.net/api/auth';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

void displayDialog(context, title, text) => showDialog(
  context: context,
  builder: (context) =>
      AlertDialog(
          title: Text(title),
          content: Text(text)
      ),
);

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  bool _showPassword = false;

  Future<int> createAccount(String username, String password) async {
    var res = await http.post(
        '$SERVER_IP',
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "password": password,
        }));
      return res.statusCode;
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Account"),),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.blue],
              begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40,child: Center(child: Text("Create your Account",
                style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),),
              TextFormField(
                validator: (value){
                  if(value.length < 4)
                    return "The username should be at least 4 characters long";
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Username',
                ),
              ),
              TextFormField(
                controller: _usernameController,
                validator: (value){
                  if(value.length < 5)
                    return "Input Email format is not valid";
                  return null;
                },
                //controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Email ID'
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value.length < 5)
                    return "The password should be at least 4 characters long";
                  return null;
                },
                controller: _passwordController1,
                obscureText: _showPassword,
                decoration: InputDecoration(
                    labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye,
                        color: this._showPassword ? Colors.orange : Colors.black54),
                    onPressed: () {setState(() {
                      this._showPassword = !this._showPassword;
                    });},
                  ),
                ),
              ),
              TextFormField(
                validator: (value){
                  if(_passwordController2.text != _passwordController1.text) {
                    return "Confirm Password is not matched.";
                  }
                  return null;
                },
                controller: _passwordController2,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                ),
              ),
              SizedBox(height: 50,),
              Container(decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
                child: FlatButton(
                  color: Colors.grey,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      var username = _usernameController.text;
                      var password = _passwordController1.text;

                        if(_formKey.currentState.validate()) {
                          var res = await createAccount(username, password);
                          if (res == 201) {
                            _usernameController.clear();
                            _passwordController1.clear();
                            _passwordController2.clear();
                            displayDialog(context, "Success",
                                "The user is created. Log in now.");
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          }else {
                            _usernameController.clear();
                            displayDialog(context, "Error",
                                "Input Email ID is not valid");
                          }
                        }
                      },
                    child: Text("Create Account")
                ),
              ),
              SizedBox(height: 10,),
              Container(decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
                child: FlatButton(
                  color: Colors.grey,
                  child: Text("Already Registered|Log In"),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
