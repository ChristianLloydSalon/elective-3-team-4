import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget{
  SectionHeader({required this.text, super.key});

  String text;

  @override 
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        text,
        // style: const TextStyle(
        //   fontSize: 20,
        //   fontWeight: FontWeight.bold,
        // ),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}