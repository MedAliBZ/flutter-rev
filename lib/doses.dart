import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartjewelry/Dose.dart';
import 'package:smartjewelry/utils/constants.dart';
import 'package:http/http.dart' as httpReq;

class DoseScreen extends StatefulWidget {
  const DoseScreen({Key? key}) : super(key: key);

  @override
  State<DoseScreen> createState() => _DoseScreenState();
}

class _DoseScreenState extends State<DoseScreen> {
  List<Dose> doses = [];
  late Future<bool> fetchedDoses;

  Future<bool> getDoses() async {
    String? id;
    var sp = await SharedPreferences.getInstance();
    id = sp.get("_id") as String?;
    //url
    Uri fetchUri =
        Uri.parse("$BASE_URL/api/pharmacies/rendez_vous/liste/${id}");
    //Headers
    Map<String, String> headers = {"Content-Type": "application/json"};
    //request
    await httpReq.get(fetchUri, headers: headers).then((response) {
      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);
        for (var item in jsonArray) {
          doses.add(Dose(item['_id'], item['type'], item['title']));
        }
      }
    }).onError((error, stackTrace) {
      print("Internal error : ${error.toString()}");
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
    fetchedDoses = getDoses();
    print(doses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: fetchedDoses,
      builder: (context, snapshot) {
        if (doses.length > 0) {
          return ListView.builder(
              itemCount: doses.length,
              itemBuilder: (context, index) {
                  return Card(
                    // games[index]
                    child: Column(
                      children: [
                        Text("Type: ${doses[index].type}"),
                        Text("Date: ${doses[index].date}")
                      ],
                    ),
                  );

              });
        } else {
          return const Center(
            child: Center(child: Text("Vous n'avez pris aucune dose"))
          );
        }
      },
    ));
  }
}
