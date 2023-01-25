import 'package:flutter/material.dart';

class SectionContent extends StatelessWidget{
  SectionContent({required this.text, super.key});

  String text;

  @override 
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.left,
      ),
    );
  }
}