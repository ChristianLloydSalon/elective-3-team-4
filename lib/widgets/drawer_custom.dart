import 'package:flutter/material.dart';
import 'package:classenger_frontend/utils/routes.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';
import 'package:classenger_frontend/utils/classrooms_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classenger_frontend/popups/create_join_classroom.dart';

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
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  // List<String> getItems(){
  //   // add code to fetch data from firebase
  //   return ['hi', 'hello', 'hagdok'];
  // }

  bool isExpanded = false;
  // bool classroomIsEmpty = true;
  bool isInstructor = getUserRole() == 'Instructor';
  String userName = getUserName();
  List<String> classrooms = [];
  late QuerySnapshot<Map<String, dynamic>> snapshot;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  @override 
  void initState(){
    super.initState();
    getClassroomList();
  }

  // List<String> items = [
  //   'CPE 411 - Mechanics of Deformable Bodies', 
  //   'CPE 416 - Artificial Intelligence', 
  //   'CPE 415 - Embedded Systems'
  // ];

  List<String> defClassContent = [
    'General',
    'Group Chat',
  ];

  void getClassroomList() async{
    if(isInstructor) {
      snapshot = await ClassInfo.classroomsCollectionRef.where('instructor', isEqualTo: userName).get();
      docs = snapshot.docs;
      if(docs.isNotEmpty) {
      for (var element in docs) {
        final Map<String, dynamic> elementData = element.data();
        setState(() {
          classrooms.add(elementData['classroom name']);
        });
      }
      ClassInfo.classroomIsEmpty = false;
      ClassInfo.addController();
      } else {
        print('classroom not found');
      }
    } else {
      snapshot = await ClassInfo.usersCollectionRef.where('user name', isEqualTo: userName).get();
      docs = snapshot.docs;
      if(docs.isNotEmpty) {
        final DocumentSnapshot document = docs.first;
        final QuerySnapshot<Map<String, dynamic>>  classroomsRef = await document.reference.collection('classrooms').get();
        print(classroomsRef.docs);
        List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = classroomsRef.docs;
        if(documents.isEmpty) {
          print('no classrooms... drawer_custom ln 82');
          return;
        }
        for (var element in documents) {
          final Map<String, dynamic> classMap = element.data();
          print('element: {$element} ... element data: {$classMap}');
          classMap.forEach((key, value) { 
            print('key: {$key} value: {$value}');
            if (key == 'classroom name') {
              setState(() {
                classrooms.add(value);
              });
            }
          });
        }
        // final Map<String, dynamic> classMap = documents as Map<String, dynamic>;

        // classMap.forEach((key, value) { 
        //   setState(() {
        //     classrooms.add(value['classroom name']);
        //   });
        // });
        ClassInfo.classroomIsEmpty = false;
        ClassInfo.addController();
      } else {
        print('classroom not found');
      }
    }
    
    // i guess this only works for docs
    // docs = snapshot.docs;

    // if(docs.isNotEmpty) {
    //   for (var element in docs) {
    //     String elementData;
    //     if(isInstructor) {
    //       elementData = element.data()['class name'];
    //     } else {
    //       QuerySnapshot<Map<String, dynamic>> classroomsRef = await element.reference.collection('classrooms').get();
    //       elementData = classroomsRef.docs.
    //     }


    //     if (elementData['classroom name'] != null) {
    //       setState(() {
    //         classrooms.add(elementData['classroom name']);
    //       });
    //     }
    //   }
    //   classroomIsEmpty = false;
    // } else {
    //   print('classroom not found');
    // }
  }

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

    return StreamBuilder<Object>(
      stream: ClassInfo.stream.distinct(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Container(
              height: AppBar().preferredSize.height,
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () => toHome(),
                child: Row(
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
                child: ClassInfo.classroomIsEmpty 
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Image.asset('classroom_empty.png')),
                          const SizedBox(height: 20,),
                          const Text(
                            'It seems that you have no classrooms yet',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                        ),
                      ],
                      ),
                  )
                  : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            const ListTile(
                              title: Text(
                                'Classrooms',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ),
                          ]),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index){
                              return InkWell(
                                onTap: () {
                                },
                                child: ExpansionTile(
                                  title: Text(
                                    classrooms[index],
                                    style: const TextStyle(
                                      color: Colors.white,
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
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                            childCount: ClassInfo.classroomIsEmpty
                            ? 1
                            : classrooms.length,
                          ),
                        ),
                      ],
                    ),
              ),
          body: widget.scaffoldBody,
          floatingActionButton: widget.editButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      }
    );
  }
}