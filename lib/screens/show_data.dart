import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;


class ShowData extends StatelessWidget {
  ShowData(this.jwt);
  Future<Map<String, dynamic>> fetchData() async {
    var res = await http.get('https://infinitysmartapi-dev.azurewebsites.net/api/HumanVitals/karambir-123',
        headers: {"Content-Type": "application/json", "Authorization": 'Bearer $jwt'});
    return json.decode(res.body);
  }

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );
  final String jwt;
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text("Your Health Data")),
        body: Center(
          child: FutureBuilder(
              future: fetchData(),
              builder: (context, AsyncSnapshot snapshot) =>
              snapshot.hasData ?
              ListView.builder(itemCount: snapshot.data["humanVitals"].length,
                  itemBuilder: (context, index){
                    return Card(
                      child: ListTile(onTap: () {displayDialog(context, "Time: ${DateTime.parse(snapshot.data["humanVitals"][index]["timestamp"]).toLocal()}",
                          "Heart Rate:- ${snapshot.data["humanVitals"][index]['heartRate']}\nTemperature:- ${snapshot.data["humanVitals"][index]["temperature"]}");},
                        leading: Icon(Icons.person,color: Colors.red[200],),
                        title: Text("Heart Rate:- ${snapshot.data["humanVitals"][index]['heartRate']}\nTemperature:- ${snapshot.data["humanVitals"][index]["temperature"]}"),
                        subtitle: Text("timestamp:- ${DateTime.parse(snapshot.data["humanVitals"][index]["timestamp"]).toLocal()}"),),elevation: 10,
                    );
                  })
                  :
              snapshot.hasError ? Text(snapshot.toString()) : CircularProgressIndicator()
          ),
        ),
      );
}