import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget{

  String text, sender, timestamp;

  MessageBox({super.key, required this.text, required this.sender, required this.timestamp});

  @override 
  Widget build(BuildContext context){
    return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xff4e5c72),
                width: 1,
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Sent on $timestamp',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}