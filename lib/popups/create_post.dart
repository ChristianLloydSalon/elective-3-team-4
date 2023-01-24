import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePost extends StatefulWidget{
  CreatePost({super.key, required this.classCode});

  String classCode;

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>>? postRef;
  TextEditingController headerController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

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

  void savePost() async {
    await postRef?.docs.first.reference.collection('posts').add({
      'header': headerController.text,
      'body': bodyController.text,
      'timestamp': Timestamp.now(),
    });
  }

  @override 
  Widget build(BuildContext context){
    print('inside CreatePost()...');
    return AlertDialog(
      title: const Text('Post Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: headerController,
            decoration: InputDecoration(
              labelText: 'Enter header here',
            ),
            onChanged: (value) {
              // text = value;
            },
          ),
          TextField(
            controller: bodyController,
            decoration: InputDecoration(
              labelText: 'Enter body here',
            ),
            onChanged: (value) {
              // text = value;
            },
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text("Save"),
          onPressed: () {
            savePost();
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}