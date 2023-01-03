import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget{
  WelcomeScreen({required this.title, super.key});

  String title;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: AppBar().preferredSize.height,
          padding: const EdgeInsets.all(5.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'logo.png',
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(width: 10,),
              Text(widget.title),
            ],
          ),
        ),
      ),
      drawer: const Drawer(
        backgroundColor: Color(0xff4e5c72),
        child: Text('hi'),
      ),
    );
  }
}