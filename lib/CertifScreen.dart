import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartjewelry/User.dart';
import 'package:smartjewelry/utils/constants.dart';
import 'package:http/http.dart' as http;

class CertifScreen extends StatefulWidget {
  const CertifScreen({Key? key}) : super(key: key);

  @override
  State<CertifScreen> createState() => _CertifScreenState();
}

class _CertifScreenState extends State<CertifScreen> {
  late User user;
  late Future<bool> fetched;

  //actions
  Future<bool> getUser() async {
    String? id;
    var sp = await SharedPreferences.getInstance();
    id = sp.get("_id") as String?;
    //url
    Uri fetchUri = Uri.parse("$BASE_URL/api/certificate/${id}");
    //Headers
    Map<String, String> headers = {"Content-Type": "application/json"};
    //request
    await http.get(fetchUri, headers: headers).then((response) {
      if (response.statusCode == 200 || response.statusCode == 401) {
        dynamic jsonArray = json.decode(response.body);
        user = User(jsonArray["etat"],jsonArray["qr_code"],jsonArray["code"],jsonArray["email"],jsonArray["nom"],jsonArray["prenom"]);
      }
    }).onError((error, stackTrace) {
      print("Internal error : ${error.toString()}");
    });
    return true;
  }

  //states
  @override
  void initState() {
    super.initState();
    fetched = getUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: fetched,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("votre nom: ${user.nom}", textAlign: TextAlign.left),
                            Text("votre prenom: ${user.prenom}"),
                            Text("votre code: ${user.code}"),
                            Text("votre email: ${user.email}"),
                            user.etat == "non vacciné" ?
                              Text("Non vacciné", style: TextStyle(color: Colors.red)) :
                                Column(
                                  children: [
                                    Text("Etat: Vacciné", style: TextStyle(color: Colors.green),),
                                    Image.network("$BASE_URL/${user.qr_code}")
                                  ],
                                )
                            
                          ],
                        );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
