import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartjewelry/Pharmacie.dart';
import 'package:smartjewelry/RdvScreen.dart';
import 'package:smartjewelry/utils/constants.dart';
import 'package:http/http.dart' as http;

class PharmacieScreen extends StatefulWidget {
  const PharmacieScreen({Key? key}) : super(key: key);

  @override
  State<PharmacieScreen> createState() => _PharmacieScreenState();
}

class _PharmacieScreenState extends State<PharmacieScreen> {
  List<Pharmacie> phar = [];
  late Future<bool> fetched;

  //actions
  Future<bool> getPhar() async {
    //url
    Uri fetchUri = Uri.parse("$BASE_URL/api/pharmacies/list");
    //Headers
    Map<String, String> headers = {"Content-Type": "application/json"};
    //request
    await http.get(fetchUri, headers: headers).then((response) {
      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);
        for (var item in jsonArray) {
          phar.add(Pharmacie(
              item['_id'], item['title'], item['address'], item['image']));
        }
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
    fetched = getPhar();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: fetched,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: phar.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){ Navigator.push(context,MaterialPageRoute(builder: (context) => RdvScreen(title: phar[index].title)));},
                      child: Card(
                          // games[index]
                        child: Column(
                          children: [
                            Image.network("$BASE_URL/${phar[index].image}"),
                            Text("title: ${phar[index].title}", style: TextStyle(fontSize: 24),),
                            Text("address: ${phar[index].address}", style: TextStyle(fontSize: 12),),
                            SizedBox(height: 10,)
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
