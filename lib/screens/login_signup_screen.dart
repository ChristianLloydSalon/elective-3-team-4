import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:classenger_frontend/utils/routes.dart';

class LoginSignupScreen extends StatefulWidget{
  LoginSignupScreen({required this.title, super.key});

  String title;

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  @override 
  Widget build(BuildContext context){

    double textFieldWidth = MediaQuery.of(context).size.width * 0.5;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    String? character = 'Instructor';
    // bool isCheckedInstructor = false;
    // bool isCheckedStudent = false;

    // submit button
    FloatingActionButton submitButton =  FloatingActionButton(
      onPressed: () {
        // temporary print on pressed
        print('submit button pressed');
        // create a function that validates the email and password
        // or create a new account based on the email and password
        // then push to welcome screen
        Navigator.push(
          context,
          Routes.generateRoute(
            const RouteSettings(
              name: Routes.homePageRoute,
              arguments: null,
            ),
          )
        );
      },
      child: const Icon(Icons.check),
    );

    // users selection radio boxes
    StatefulBuilder radioBoxUsers = StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              // child: CheckboxListTile(
              //   title: Text(user),
              //   activeColor: const Color(0xff5e9d8d),
              //   checkColor: Colors.white,
              //   enabled: true,
              //   value: (user == 'Instructor')
              //     ? isCheckedInstructor
              //     : isCheckedStudent, 
              //   onChanged: (bool? value) {
              //     setState(() {
              //       (user == 'Instructor')
              //       ? isCheckedInstructor = value
              //       : isCheckedStudent = value;
              //     });
              //   },
              // ),
              child: RadioListTile<String>(
                title: const Text('Instructor'),
                activeColor: const Color(0xff5e9d8d),
                groupValue: character,
                value: 'Instructor', 
                onChanged: (String? value) {
                  setState(() {
                    character = value;
                  });
                  print('character: $character');
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: RadioListTile<String>(
                title: const Text('Student'),
                activeColor: const Color(0xff5e9d8d),
                groupValue: character,
                value: 'Student', 
                onChanged: (String? value) {
                  setState(() {
                    character = value;
                  });
                  print('character: $character');
                },
              ),
            ),
          ],
        );
      }
    );

    // text fields
    List<Widget> formContent = [
      // text field for email
      SizedBox(
        width: textFieldWidth,
        child: TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'E-mail',
            icon: Icon(Icons.email),
          ),
        ),
      ),
      const SizedBox(height: 10,),
      // text field for password
      SizedBox(
        width: textFieldWidth,
        child: TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            icon: Icon(Icons.password),
          ),
        ),
      ),
      const SizedBox(height: 30,),
      radioBoxUsers,
      const SizedBox(height: 50,),
      submitButton,
    ];


    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
        // tabs contents
        body: TabBarView(
          children: [
            // sign up tab
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: formContent,
            ),
            // log in tab
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: formContent,
            ),
          ],
        ),
        // sign in log in tabs
        bottomNavigationBar: const TabBar(
            tabs: [
              Tab(text: 'Sign up',),
              Tab(text: 'Log in',),
            ],
            labelColor: Color(0xff4e5c72),
            onTap: null,
            indicatorWeight: 10,
          ),
      ),
    );
  }
}

