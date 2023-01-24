import 'package:flutter/material.dart';
// import 'package:classenger_frontend/widgets/drawer_custom.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';
import 'package:classenger_frontend/popups/create_join_classroom.dart';

class HomeScreen extends StatelessWidget {
  bool isInstructor = getUserRole() == 'Instructor';

  HomeScreen({super.key});

  String user = getUserName();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Center(
            child: Text(
              'Welcome $user!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.05,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          // button for creating or joining classroom
          ElevatedButton(
            onPressed: () {
              // function to create or join classroom
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CreateJoinClassroom();
                },
              );
            },
            child: Text(isInstructor ? 'Create Classroom' : 'Join Classroom'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset('people.png'),
          ),
        ],
      ),
    );
  }
}
