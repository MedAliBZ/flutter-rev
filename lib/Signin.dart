import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartjewelry/utils/constants.dart';
import 'package:http/http.dart' as httpReq;
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late String? code;
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  void signinAction() {
    //URL
    Uri signInUri = Uri.parse("$BASE_URL/api/users/login");

    //Headers
    Map<String, String> headers = {"Content-Type": "application/json"};

    //Body
    Map<String, dynamic> userObject = {"code": code};

    //request
    httpReq
        .post(signInUri, headers: headers, body: jsonEncode(userObject))
        .then((resp) {
      if (resp.statusCode == 200) {
        SharedPreferences.getInstance().then((sp) {
          sp.setString("_id", json.decode(resp.body)['_id']);
          sp.setBool("isConnected", true);
        });
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      } else if (resp.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Username et/ou password incorrect!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Dismiss",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ))
              ],
            );
          },
        );
      }
    }).onError((error, stackTrace) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Warning"),
                  content:
                      const Text("Internal server error! Try again later."),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Dismiss",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ))
                  ],
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S'authentifier"),
      ),
      body: Form(
        key: _keyForm,
        child: ListView(
          children: [
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: const Image(image: AssetImage("images/minecraft.jpg"))),//Image.network("http://ambtunisi.esteri.it/ambasciata_tunisi/resource/img/2021/02/evax.jpeg"))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _textController,
                onSaved: (newValue) => code = newValue!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ce champ est requis";
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Code d'inscription"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        code = null;
                        _textController.clear();
                      }, child: const Text("Renetialiser")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                            if (_keyForm.currentState!.validate()){
                                _keyForm.currentState!.save();
                                signinAction();
                              }
                          },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text("Login")),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
