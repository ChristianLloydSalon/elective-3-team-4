import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:classenger_frontend/widgets/drawer_custom.dart';
import 'package:classenger_frontend/widgets/post_box.dart';

class PostsScreen extends StatefulWidget{
  PostsScreen({super.key, required this.classCode});

  String classCode;
  static BuildContext? postContext;

  @override
  State<PostsScreen> createState() => _PostsScreenState();

  // static void _showPostDialog(BuildContext context) => _showDialog();

  // static void _showDialog(BuildContext context) => _show(context);
}

class _PostsScreenState extends State<PostsScreen> {
  final _firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>>? postRef;
  TextEditingController headerController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  

  // must fetch existing data for header and body

  @override 
  void initState(){
    super.initState();
    getReference().then((value) {
      setState(() {
        postRef = value;
      });
    });
  }

  @override 
  void dispose(){
    headerController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getReference() async {
    return await _firestore
        .collection('classrooms')
        .where('classcode', isEqualTo: widget.classCode)
        .get();
  }

  @override 
  Widget build(BuildContext context){

    PostsScreen.postContext = context;
    
    return Column(
      children: [
        const SizedBox(height: 8),
        StreamBuilder(
          stream: _firestore
            .collection('classrooms')
            .where('classcode', isEqualTo: widget.classCode)
            .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData) {
              var classroomSnap = snapshot.data!.docs.first;
              return Text(
                classroomSnap['classroom name'],
                style: Theme.of(context).textTheme.headlineSmall,
                softWrap: true,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        ),
        const SizedBox(height: 8),
        Text(
          'Class code: ${widget.classCode}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: postRef?.docs.first.reference
            .collection('posts')
            .orderBy('timestamp')
            .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('snapshot has error');
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final posts = snapshot.data?.docs;
              List<Widget> postWidgets = [];
              for (var post in posts!) {
                final header = post['header'];
                final body = post['body'];
                final timestamp = post['timestamp'].toDate().toString();
                final postWidget = PostBox(
                  header: header,
                  body: body,
                  timestamp: timestamp,
                );
                postWidgets.add(postWidget);
              }
              // return CustomScrollView(
              //         slivers: postWidgets,
              //       );
              return ListView(
                children: postWidgets,
              );
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Image.asset('notebook.png')
                  ),
                  const SizedBox(height: 10,),
                  const Text('No posts yet.'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}