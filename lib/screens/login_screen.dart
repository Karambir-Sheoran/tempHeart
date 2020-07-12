import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tempheart/screens/register_screen.dart';
import 'package:tempheart/screens/uploadData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;


const SERVER_IP = 'https://infinitysmartapi-dev.azurewebsites.net/api/auth';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post(
        '$SERVER_IP',
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "password": password,
        }));
    if(res.statusCode == 201) {
      return res.body;
    }
    return null;
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Log In"),),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.green, Colors.blue],
                begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 50,),
                  Center(child: Text("Welcome to Login Page", style: TextStyle(fontSize: 20),)),
                  SizedBox(height: 50,),
                  TextFormField(
                    validator: (value){
                      if(value.length < 4){
                        return "Input email is not valid.";
                      }
                      return null;
                    },
                    controller: _usernameController,
                    decoration: InputDecoration(
                        labelText: 'Email ID'
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if(value.isEmpty){
                        return "*Required";
                      }
                      return null;
                    },
                    controller: _passwordController,
                    obscureText: !this._showPassword,
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
                  SizedBox(height: 30,),
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
                    child: RaisedButton(
                      color: Colors.grey,
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          var email = _usernameController.text;
                          var password = _passwordController.text;

                          if (_formKey.currentState.validate()) {
                            var jwt = await attemptLogIn(email, password);
                            print(jwt);
                            if(jwt != null){
                              _usernameController.clear();
                              _passwordController.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UploadData(json.decode(jwt)['token'], json.decode(jwt)['userName'])
                                ),
                            );}
                            else displayDialog(context, "An Error Occurred",
                                "No account was found matching that username and password");
                          }

                        },
                        child: Text("Log In")
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
                    child: RaisedButton(
                      color: Colors.grey,
                      child: Text("No Account? Sign Up"),
                      onPressed: () {FocusScope.of(context).requestFocus(new FocusNode());
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAccount()));},
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
