import 'package:flutter/material.dart';
import 'package:classenger_frontend/utils/routes.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';

// to dos:
// add create classroom for instructors
// add join classroom for students

class DrawerCustom extends StatefulWidget{
  DrawerCustom({
    required this.title,
    required this.scaffoldBody,
    this.editButton, 
    super.key});

  String title;
  Widget scaffoldBody;
  Widget? editButton;

  @override
  State<DrawerCustom> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<DrawerCustom> {
  // List<String> getItems(){
  //   // add code to fetch data from firebase
  //   return ['hi', 'hello', 'hagdok'];
  // }

  bool isExpanded = false;
  bool isInstructor = getUserRole() == 'Instructor';

  List<String> items = [
    'CPE 411 - Mechanics of Deformable Bodies', 
    'CPE 416 - Artificial Intelligence', 
    'CPE 415 - Embedded Systems'
  ];

  List<String> defClassContent = [
    'General',
    'Lecture Materials',
    'Activities',
    'Quizzes',
    'Major Exams',
    'Projects',
    'Group Chat',
  ];

  void toHome(){
    Navigator.push(
      context,
      Routes.generateRoute(
        const RouteSettings(
          name: '/home',
          arguments: null,
        ),
      ),
    );
  }

  @override 
  Widget build(BuildContext context){
    // if(isInstructor) {
    //   defClassContent.add('+ Add channel');
    // }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: AppBar().preferredSize.height,
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () => toHome(),
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
        automaticallyImplyLeading: false,
      ),
      endDrawer: Drawer( 
        backgroundColor: const Color(0xff4e5c72),
        // child: Stack(
        //   children: <Widget> [ 
        child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    const ListTile(
                      title: Text(
                        'Classrooms',
                        style: TextStyle(
                          // fontSize: MediaQuery.of(context).size.height * 0.03,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        // style: Theme.of(context).textTheme.headlineLarge,
                      )
                    ),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index){
                      return InkWell(
                        onTap: () {
                          // just a temporary print to see if drawer works
                          print('items on drawer tapped');
                        },
                        child: ExpansionTile(
                          title: Text(
                            items[index],
                            style: const TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          collapsedIconColor: Colors.white,
                          initiallyExpanded: isExpanded,
                          onExpansionChanged: (value) {
                            setState(() {
                              isExpanded = value;
                            });
                          },
                          children: defClassContent.map((content) {
                            return InkWell(
                              child: ListTile(
                                title: Text(
                                  content,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  // class content sublist
                                  // actions when tapped
                                  if(content == 'General') {
                                    Navigator.push(
                                      context,
                                      Routes.generateRoute(
                                        const RouteSettings(
                                          name: '/general',
                                          arguments: null,
                                        ),
                                      ),
                                    );
                                  }
                                  if(content == 'Lecture Materials') {
                                    Navigator.push(
                                      context,
                                      Routes.generateRoute(
                                        const RouteSettings(
                                          name: '/lecture materials',
                                          arguments: null,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              ],
            ),
          //   Positioned(
          //     bottom: 8,
          //     right: 8,
          //     child: ElevatedButton(
          //       onPressed: () {
          //         if(isInstructor){
          //           // function to create classroom
          //           generateClasscode();
          //         } else {
          //           //function to join classroom
          //         }
          //       },
          //       style: ButtonStyle(
          //         backgroundColor: MaterialStateProperty.all(Colors.white),
          //         foregroundColor: MaterialStateProperty.all(const Color(0xff4e5c72)),
          //       ),
          //       child: Text( isInstructor
          //         ? 'Create Classroom'
          //         : 'Join Classroom'
          //       ),
          //     ),
          //   ),
          // ]
        // ),
      ),
      body: widget.scaffoldBody,
      floatingActionButton: widget.editButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}