import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';
import 'package:classenger_frontend/utils/classcode_generator.dart';

class CreateJoinClassroom extends StatefulWidget{

  @override
  State<CreateJoinClassroom> createState() => _CreateJoinClassroomState();
}

class _CreateJoinClassroomState extends State<CreateJoinClassroom> {
  TextEditingController textController = TextEditingController();
  final formKey = GlobalKey<FormFieldState>();
  late String fieldText;
  String? instructor;
  late String classcode;
  String userRole = getUserRole();
  String userID = getUserID();
  String userName = getUserName();
  String? errorMsg;
  bool submitted = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void createClassroom() async {
    // adding classroom to classroom collection
    var classroom = await _db.collection('classrooms').add({
      'classroom name': fieldText,
      'instructor': instructor,
      'classcode': classcode,
    });

    // adding classroom to (instructor) user's document
    var snapshot = await _db.collection('users').where('user name', isEqualTo: userName).get();
    var docs = snapshot.docs;

    if(docs.isNotEmpty) {
      final DocumentSnapshot document = docs.first;
      await document.reference.update({
        'classrooms': {
          classroom.id: fieldText 
        }
      });
    } else {
      print('classroom not found');
    }
  }

  void joinClassroom() async{
    var className;
    classcode = fieldText;

    // adding student to classroom document
    var classSnapshot= await _db.collection('classrooms').where('classcode', isEqualTo: classcode).get();
    var classroom = classSnapshot.docs;
    
    if(classroom.isNotEmpty) {
      final DocumentSnapshot document = classroom.first;
      await document.reference.update({
        'students': {
          userID: userName
        }
      });
      var classObject = document.data() as Map<String, dynamic>;
      className = classObject['classroom name'];
    } else {
      print('classroom not found');
    }

    // adding classroom to student user's document
    var userSnapshot= await _db.collection('users').where('user name', isEqualTo: userName).get();
    var user = userSnapshot.docs;

    if(user.isNotEmpty) {
      final DocumentSnapshot document = user.first;
      await document.reference.update({
        'classrooms': {
          classcode: className
        }
      });
    } else {
      print('classroom not found');
    }
  }

  @override 
  void initState(){
    super.initState();
    if(userRole == 'Instructor') {
      classcode = generateClasscode();
      instructor = userName;
    }
  }

  @override 
  void dispose(){
    textController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(
        'Classroom Information',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            key: formKey,
            controller: textController,
            decoration: InputDecoration(
              labelText: userRole == 'Instructor'
              ? 'Enter classroom name'
              : 'Enter class code',
              errorText: errorMsg,
            ),
            validator: (value) {
              if(value == '' && submitted == true) {
                setState(() {
                  errorMsg = 'This field must not be empty';
                });
                return 'This field must not be empty';
              }
              return null;
            },
          ),
          userRole == 'Instructor'
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Classcode: $classcode')
          )
          : const SizedBox(),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text(
            userRole == 'Instructor'
            ? 'Create'
            : 'Join'
          ),
          onPressed: () {
            submitted = true;
            if(!formKey.currentState!.validate()) {
              return;
            }
            setState(() {
              fieldText = textController.text;
            });
            userRole == 'Instructor' 
            ? createClassroom()
            : joinClassroom();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}