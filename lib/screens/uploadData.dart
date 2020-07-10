import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tempheart/screens/login_screen.dart';
import 'package:tempheart/screens/show_data.dart';
import 'contactUs.dart';


class UploadData extends StatefulWidget {
  final token, user;
  UploadData(this.token, this.user);
  @override
  _UploadDataState createState() => _UploadDataState(token, user);
}

class _UploadDataState extends State<UploadData> {
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller1 = TextEditingController();

  final token, user;
  _UploadDataState(this.token, this.user);
  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );
  // ignore: non_constant_identifier_names
  Future<int> upload_data(String heart, String temp) async {
    var res = await http.post("https://infinitysmartapi-dev.azurewebsites.net/api/HumanVitals",
    headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
    body: json.encode({
      "organizationId": "karambir-123",
      "businessUnitId": "UK-london",
      "deviceId": "device123",
      "heartRate": int.parse(heart),
      "temperature": int.parse(temp),
    }));
    return res.statusCode;
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home page"),),
      drawer: Drawer(
        elevation: 20,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(child: Image.asset("assets/kraken_log.png",),backgroundColor: Colors.white54,),
                    accountEmail: Text(user),
                    accountName: Text(user.toString().split("@")[0]),
                    decoration: BoxDecoration(
                    //color: Colors.blue
                  ),),
                  ListTile(
                    leading: Icon(Icons.add_location),
                    title: Text("Contact Us"),
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUs()));},
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text("Log Out"),
                    onTap: () {Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                    },
                  ),

                ],
              ),
            ),
            Divider(),
            Container(padding: EdgeInsets.only(left: 30, bottom: 20),child: Align(alignment: FractionalOffset.bottomLeft,
              child: Text("app version: 1.0"),)),
          ],
        ),
      ),
      body: Card(
        color: Colors.red[40],
        elevation: 20,
        shadowColor: Colors.black,
        margin: EdgeInsets.fromLTRB(15,15,15,15),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: <Widget>[
              GestureDetector(onTap: () { FocusScope.of(context).requestFocus(new FocusNode());},
                  child: Container(child: Image.asset('assets/kraken_log.png',width: 20,height: 200,color: Colors.white,))),
              TextFormField(
                autofocus: false,
                validator: (value){
                  if(value.length < 2 || value.length >3){
                    return "invalid range";
                  }
                  return null;
                },
                controller: _controller1,
                decoration: InputDecoration(
                  labelText: 'Input Your Heart rate',
                  prefixIcon: Icon(Icons.favorite,color: Colors.orange,),
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value.length < 2 || value.length > 3){
                    return "invalid range";
                  }
                  return null;
                },
                controller: _controller2,
                //obscureText: !this._showPassword,
                decoration: InputDecoration(
                  labelText: 'Input your Temperature',
                  prefixIcon: Icon(Icons.flash_on,color: Colors.orange,),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                ),
                child: FlatButton(child: Text("Upload Data"),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                if(_formKey.currentState.validate()) {
                  var res = await upload_data(
                      _controller1.text, _controller2.text);
                  if (res == 200) {
                    _controller1.clear();
                    _controller2.clear();
                    displayDialog(
                        context, "Success!!", "Data uplaoded successfully!");
                  } else {
                    displayDialog(context, "Error!", "An Unknown error!");
                  }
                }
                },),
              ),Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey  ,
                ),
                child: FlatButton(child: Text("Show Data"),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShowData(token)));
                },),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
