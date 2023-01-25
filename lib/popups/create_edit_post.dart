import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEditPost extends StatefulWidget{
  CreateEditPost({super.key, required this.classCode, this.postSnap, this.toEdit});

  String classCode;
  QuerySnapshot<Map<String, dynamic>>? postSnap;
  bool? toEdit;

  @override
  State<CreateEditPost> createState() => _CreateEditPostState();
}

class _CreateEditPostState extends State<CreateEditPost> {
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
    if(widget.toEdit != null && widget.postSnap != null) {
      //get text data from firebase
      await widget.postSnap?.docs.first.reference.get().then((value) {
        headerController.text = value.data()!['header'];
        bodyController.text = value.data()!['body'];
      });
    }
    
    return await _firestore
        .collection('classrooms')
        .where('classcode', isEqualTo: widget.classCode)
        .get();
  }

  void savePost() async {
    final collectionRef = postRef?.docs.first.reference.collection('posts');
    print(collectionRef?.doc().id);
    final docRef = await collectionRef?.add({
      // 'uid': collectionRef.doc().id,
      'header': headerController.text,
      'body': bodyController.text,
      'timestamp': Timestamp.now(),
    });
    await docRef?.update({
      'uid': docRef.id,
    });
  }

  void editPost() async{
    await widget.postSnap?.docs.first.reference.update({
      'header': '${headerController.text} (edited)',
      'body': bodyController.text,
      // 'timestamp': Timestamp.now(),
    });
  }

  @override 
  Widget build(BuildContext context){
    print('inside CreatePost()...');
    print('value of toEdit: ${widget.toEdit}');
    return AlertDialog(
      title: const Text('Post Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            maxLines: null,
            controller: headerController,
            decoration: InputDecoration(
              labelText: 'Enter header here',
            ),
            onChanged: (value) {
              // text = value;
            },
          ),
          Expanded(
            child: TextField(
              maxLines: null,
              controller: bodyController,
              decoration: InputDecoration(
                labelText: 'Enter body here',
              ),
              onChanged: (value) {
                // text = value;
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text("Save"),
          onPressed: () {
            widget.toEdit != null
            ? editPost()
            : savePost();
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