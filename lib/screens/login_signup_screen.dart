import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:classenger_frontend/utils/routes.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';
import 'package:classenger_frontend/utils/auth_service.dart';
// import 'package:classenger_frontend/widgets/drawer_custom.dart';
import 'dart:async';

class LoginSignupScreen extends StatefulWidget {
  LoginSignupScreen({required this.title, super.key});

  String title;

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  late TabController tabController;
  String? character = 'Instructor';
  String? _email;
  String? _password;
  String? _userName;
  String? _emailErrorMsg,
      _passwordErrorMsg,
      fnErrorMsg,
      lnErrorMsg,
      nameErrorMsg;
  final emailKey = GlobalKey<FormFieldState>();
  final passwordKey = GlobalKey<FormFieldState>();
  final userNameKey = GlobalKey<FormState>();
  bool submittedForm = false;
  bool obscureText = true;
  bool isLoading = false;
  int tabSelected = 0;
  late AuthService authUser;
  late Timer timer;

  bool isEmailValid(String email) {
    String bisuEmail = '@bisu.edu.ph';
    int idx = email.indexOf(bisuEmail, 0);

    // checking if email is correct
    if (idx > -1 && email.length - 12 == idx) {
      return true;
    }
    return false;
  }

  // timer to obscure password after one second
  void startTimer() {
    timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        obscureText = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      if (tabController.index == 1) {
        emailController.text = _email!;
        passwordController.text = _password!;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double textFieldWidth = MediaQuery.of(context).size.width * 0.5;

    // submit button
    FloatingActionButton submitButton = FloatingActionButton(
      onPressed: () async {
        submittedForm = true;

        bool emailValidated = emailKey.currentState!.validate();
        bool passwordValidated = passwordKey.currentState!.validate();

        // checking if email or password is valid
        if (!emailValidated || !passwordValidated) {
          return;
        }

        // create user object
        AuthService authUser = AuthService(
          email: _email!,
          password: _password!,
          role: character!,
        );

        // if user wants to sign up
        if (tabSelected == 0) {
          try {
            if (await authUser.doesUserExist()) {
              setState(() {
                _emailErrorMsg = 'User already exists';
              });
            } else {
              // getting user name
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Enter user name'),
                    content: Form(
                      key: userNameKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              label:
                                  const Text('e.g. LastName, FirstName M.I.'),
                              errorText: nameErrorMsg,
                            ),
                            onChanged: (value) {
                              _userName = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  nameErrorMsg = 'Please enter some text';
                                });
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (userNameKey.currentState!.validate()) {
                                setState(() {
                                  nameErrorMsg = null;
                                });
                                saveUserName(_userName!);
                                authUser.userName = _userName;

                                // creating an account
                                isLoading = true;
                                authUser.signUpWithEmailAndPassword();
                                saveUserRole(character!);

                                // pushing to next screen, the welcome screen
                                Navigator.push(
                                    context,
                                    Routes.generateRoute(
                                      const RouteSettings(
                                        name: Routes.homePageRoute,
                                        arguments: null,
                                      ),
                                    ));
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } on Exception catch (e) {
            print(e);
          }
        } else {
          // if user wants to log in
          if (!await authUser.doesUserExist() ||
              !await authUser.isPasswordValid()) {
            setState(() {
              _emailErrorMsg = 'E-mail might be incorrect';
              _passwordErrorMsg = 'Password might be incorrect';
            });
            return;
          }
          setState(() {
            _emailErrorMsg = null;
            _passwordErrorMsg = null;
          });
          isLoading = true;
          await authUser.logInWithEmailAndPassword();
          saveUserRole(character!);
          // must throw username from firestore
          saveUserName(authUser.userName!);

          // pushing to home screen
          Navigator.push(
              context,
              Routes.generateRoute(
                const RouteSettings(
                  name: Routes.homePageRoute,
                  arguments: null,
                ),
              ));
        }
      },
      child: const Icon(Icons.check),
    );

    // users selection radio boxes
    StatefulBuilder radioBoxUsers =
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: RadioListTile<String>(
              title: const Text('Instructor'),
              activeColor: const Color(0xff5e9d8d),
              groupValue: character,
              value: 'Instructor',
              onChanged: (String? value) {
                setState(() {
                  character = value;
                });
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
              },
            ),
          ),
        ],
      );
    });

    // text fields
    List<Widget> formContent = [
      // text field for email
      SizedBox(
        width: textFieldWidth,
        child: TextFormField(
          key: emailKey,
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'E-mail (e.g. xxx@bisu.edu.ph)',
            errorText: _emailErrorMsg,
            icon: const Icon(Icons.email),
          ),
          validator: (value) {
            if (value == '' && submittedForm == true) {
              setState(() {
                _emailErrorMsg = 'Please enter an e-mail';
              });
              return 'Please enter an e-mail';
            }
            if (!isEmailValid(value!) && submittedForm == true) {
              setState(() {
                _emailErrorMsg = 'Invalid e-mail';
              });
              return 'Invalid e-mail';
            }
            return null;
          },
          onChanged: (value) {
            if (emailKey.currentState!.validate() && isEmailValid(value)) {
              _email = value;
              setState(() {
                _emailErrorMsg = null;
              });
            }
          },
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      // text field for password
      SizedBox(
        width: textFieldWidth,
        child: TextFormField(
          key: passwordKey,
          controller: passwordController,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: _passwordErrorMsg,
            icon: const Icon(Icons.password),
          ),
          validator: (value) {
            if (value == '' && submittedForm == true) {
              setState(() {
                _passwordErrorMsg = 'Please enter an password';
              });
              return 'Please enter a password';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              obscureText = false;
              startTimer();
            });
            if (passwordKey.currentState!.validate()) {
              _password = value;
              _passwordErrorMsg = null;
            }
          },
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      radioBoxUsers,
      const SizedBox(
        height: 50,
      ),
      submitButton,
    ];

    return isLoading
        ? Center(
            child: Visibility(
              visible: isLoading,
              child: const CircularProgressIndicator(),
            ),
          )
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Container(
                  height: AppBar().preferredSize.height,
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'logo.png',
                        fit: BoxFit.fitHeight,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(widget.title),
                    ],
                  ),
                ),
              ),
              // tabs contents
              body: TabBarView(
                controller: tabController,
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
              bottomNavigationBar: TabBar(
                tabs: const [
                  Tab(
                    text: 'Sign up',
                  ),
                  Tab(
                    text: 'Log in',
                  ),
                ],
                labelColor: const Color(0xff4e5c72),
                onTap: (value) {
                  setState(() {
                    tabSelected = value;
                  });
                },
                indicatorWeight: 10,
              ),
            ),
          );
  }
}
