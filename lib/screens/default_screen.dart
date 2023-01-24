import 'package:classenger_frontend/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:classenger_frontend/screens/home_screen.dart';
import 'package:classenger_frontend/screens/posts_screen.dart';
import 'package:classenger_frontend/screens/group_chat_screen.dart';
import 'package:classenger_frontend/popups/create_post.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';
import 'dart:async';

class DefaultScreen extends StatefulWidget {
  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  bool isExpanded = false;
  bool isInstructor = getUserRole() == 'Instructor';
  String userName = getUserName();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  // static CollectionReference<Map<String, dynamic>> classroomsCollectionRef = _db.collection('classrooms');
  static CollectionReference<Map<String, dynamic>> usersCollectionRef =
      _db.collection('users');
  // static CollectionReference<Map<String, dynamic>> userClassCollectionRef = usersCollectionRef.doc().collection('classrooms');
  Widget scaffoldBody = HomeScreen();
  Widget? createPostButton;
  List<String> defClassContent = [
    'Posts',
    'Group Chat',
  ];
  QuerySnapshot<Map<String, dynamic>>? classCollectionRef;
  // late QueryDocumentSnapshot<Map<String, dynamic>> docFirst;
  // late CollectionReference<Map<String, dynamic>> classroomCollection;

  @override
  void initState() {
    // getReferences();
    super.initState();
    getReferences().then((val) {
      setState(() {
        classCollectionRef = val;
      });
      print('getReferences done processing..');
      // var dummy = classCollectionRef?.docs.first.reference.collection('classrooms').get();
      // print('contents of classCollectionRef docs: ${dummy!.then((value) => print(value))}');
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getReferences() async {
    print('inside getReferences');
    // print(getUserName());
    return await usersCollectionRef
        .where('user name', isEqualTo: getUserName())
        .get();
    // print(classCollectionRef?.docs.first.data());
    // var dummy = await classCollectionRef?.docs.first.reference.collection('classrooms').get();
    // var dummyDoc = dummy!.docs;
    // print('this is docs in dummy: ${dummyDoc.first.data()}');
    // YES, COLLECTION IS READ
  }

  @override
  Widget build(BuildContext context) {
    // getReferences();
    return StreamBuilder(
      // stream: usersCollectionRef.where('user name', isEqualTo: userName).snapshots(),
      stream: classCollectionRef?.docs.first.reference
          .collection('classrooms')
          .snapshots(),
      // initialData: classCollectionRef,
      // initialData: classCollectionRef?.docs.first.reference.collection('classrooms').get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          // print('snapshot data: ${streamSnapshot.data!.docs.first}');
          // print(classCollectionRef?.docs.first.reference.collection('classrooms').doc().id);
          return Scaffold(
            appBar: AppBar(
              title: Container(
                height: AppBar().preferredSize.height,
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      scaffoldBody = HomeScreen();
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'logo.png',
                        fit: BoxFit.fitHeight,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Classenger'),
                    ],
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            floatingActionButton: createPostButton,
            endDrawer: Drawer(
              backgroundColor: const Color(0xff4e5c72),
              child: streamSnapshot.data!.docs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Image.asset('classroom_empty.png')),
                          const SizedBox(
                            height: 20,
                          ),
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
                            ListTile(
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    logout(context);
                                  },
                                ),
                                title: Text(
                                  'Classrooms',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                          ]),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // print(
                              //     'value sa snapshot: ${streamSnapshot.data!.docs}');
                              // gama ta ug map ani sa classrooms
                              // Map<String, dynamic> dataMap = streamSnapshot.data!.docs.first['classrooms'] as Map<String, dynamic>;
                              // print('snapshot data: ${streamSnapshot.data!.docs.first['classrooms']} ... casted: $dataMap');
                              // print('datamap[index]: ${dataMap[index][0]}');
                              return InkWell(
                                onTap: () {},
                                child: ExpansionTile(
                                  title: Text(
                                    // classrooms[index],
                                    streamSnapshot.data!.docs[index]
                                        ['class name'],
                                    // streamSnapshot.data!.docs[index]['classroom name'],
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
                                          if (content == 'Posts') {
                                            if(userRole == 'Instructor') {
                                              setState(() {
                                                createPostButton = FloatingActionButton(
                                                  child: const Icon(Icons.create),
                                                  onPressed: () {
                                                    print('pressed create post button');
                                                    showDialog(
                                                      context: PostsScreen.postContext!, 
                                                      builder: (BuildContext context) {
                                                        print('this is context: ${context.toString()}...');
                                                        return CreatePost(
                                                          classCode: streamSnapshot.data!.docs[index]['class code'],
                                                          // post: streamSnapshot.data!.docs.
                                                        );
                                                        // return Text('Hi');
                                                      }
                                                    );
                                                  }
                                                );
                                              });
                                            }
                                            setState(() {
                                              scaffoldBody = PostsScreen(
                                                classCode: streamSnapshot.data!.docs[index]['class code']);
                                            });
                                          }
                                          if (content == 'Group Chat') {
                                            //set state of scaffoldBody to group chat body
                                            setState(() {
                                              createPostButton = null;
                                              scaffoldBody = ChatPage(
                                                groupId: streamSnapshot.data!
                                                    .docs[index]['class code'],
                                              );
                                            });
                                          }
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                            childCount: streamSnapshot.data!.docs.length,
                          ),
                        ),
                      ],
                    ),
            ),
            body: scaffoldBody,
          );
        } else if (streamSnapshot.hasError) {
          return Text("${streamSnapshot.error}");
        }
        // print('this is ref from collection ${classCollectionRef?.docs.first.reference.collection('classrooms').doc()}');
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginSignupScreen(title: 'Classenger'),
      ),
    );
  }
}
