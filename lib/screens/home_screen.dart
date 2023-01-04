import 'package:flutter/material.dart';
import 'package:classenger_frontend/widgets/drawer_custom.dart';

class HomeScreen extends StatelessWidget{
  HomeScreen({super.key});

  //just some dummy data
  //make a function to fetch user name
  String user = 'Kuina';

  @override 
  Widget build(BuildContext context){
    return DrawerCustom(
      title: 'Classenger', 
      scaffoldBody: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
            Text(
              'Welcome back, $user!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Image.asset('people.png'),
            ),
          ],
        ),
      ),
    );
  }
}