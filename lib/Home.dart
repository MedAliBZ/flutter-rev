import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartjewelry/CertifScreen.dart';
import 'package:smartjewelry/PharmacieScreen.dart';
import 'package:smartjewelry/doses.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("evax"),
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.health_and_safety),
              text: "Mes doses",
            ),
            Tab(
              icon: Icon(Icons.local_pharmacy),
              text: "Pharmacies",
            ),
            Tab(
              icon: Icon(Icons.qr_code),
              text: "Certificats",
            ),
          ]),
        ),
        drawer: Drawer(
            child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              ListTile(
                onTap: (){},
                title: Row(
                  children: [
                    Icon(Icons.history),
                    SizedBox(
                      width: 15,
                    ),
                    Text("Historique", style: TextStyle(fontSize: 20),),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              ListTile(
                onTap: (){},
                title: Row(
                  children: [
                    Icon(Icons.power_settings_new),
                    SizedBox(
                      width: 15,
                    ),
                    Text("Se deconnecter", style: TextStyle(fontSize: 20),),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              )
            ],
          ),
        )
        ),
        body: const TabBarView(children: [
          DoseScreen(),
          PharmacieScreen(),
          CertifScreen(),
        ],),

      ),
    );
  }
}
