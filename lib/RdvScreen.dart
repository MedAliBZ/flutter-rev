import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RdvScreen extends StatefulWidget {
  final String title;
  const RdvScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<RdvScreen> createState() => _RdvScreenState();
}

class _RdvScreenState extends State<RdvScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
