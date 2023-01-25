import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classenger_frontend/widgets/section_content.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';
import 'package:classenger_frontend/popups/create_edit_post.dart';
// import 'package:classenger_frontend/widgets/file_box.dart';
// import 'package:classenger_frontend/screens/posts_screen.dart';

// must add file box child property para butangan sa file

class PostBox extends StatelessWidget{
  PostBox({
    required this.header,
    required this.body,
    required this.timestamp,
    required this.classcode,
    required this.id,
    // this.fileName,
    // this.docType,
    // this.url,
    super.key
  });

  String header;
  String body;
  String timestamp;
  String classcode;
  String id;
  final _firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>>? classSnap;
  QuerySnapshot<Map<String, dynamic>>? postSnap;
  // String? fileName, docType, url;
  // bool hasFile;

  void getReferences() async {
    await _firestore
      .collection('classrooms')
      .where('classcode', isEqualTo: classcode)
      .snapshots().first.then((value) {
        classSnap = value;
        print('this is classSnap value: $value');
      });
    await classSnap?.docs.first.reference
      .collection('posts')
      .where('uid', isEqualTo: id)
      .snapshots().first.then((value) {
        postSnap = value;
      });
      // var dummy;
      // await postSnap?.docs.first.reference.get().then((value) => dummy = value.data()!['header']);
      // print('dummy data which contains header of post: $dummy');
  }

  void deletePost() async {
    await postSnap?.docs.first.reference.delete();
    print('deleted post $id...');
  }

  @override 
  Widget build(BuildContext context){
    getReferences();
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff4e5c72),
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: [
          // header of the post
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostHeader(
                  header: header,
                  timestamp: timestamp,
                ),
                getUserRole() == 'Instructor'
                ? PopupMenuButton(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (value) {
                    if(value == 1) {
                      // perform edit operation
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return CreateEditPost(
                            classCode: classcode,
                            postSnap: postSnap,
                            toEdit: true,
                          );
                        }
                      );
                    } else {
                      //perform delete operation
                      deletePost();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Delete'),
                    ),
                  ]
                )
                : const SizedBox(width: 20)
              ],
            ),
          ),
          // contents of the post
          SectionContent(
            text: body,
          ),
          // hasFile == true
          // ? FileBox(
          //   fileName: fileName!,
          //   docType: docType!,
          //   url: url!,
          // )
          // : const SizedBox(),
        ],
      ),
    );
  }
}

class PostHeader extends StatelessWidget{
  PostHeader({
    required this.header,
    required this.timestamp,
    super.key
  });

  String header;
  String timestamp;

  @override 
  Widget build(BuildContext context){
    return Row(
      children: [
        Text(
          // replace this string with the header of this post
          header,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(width: 20,),
        // posting date
        Text(
          // replace this string with the time this is posted
          timestamp,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}