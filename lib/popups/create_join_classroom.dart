import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';
import 'package:classenger_frontend/utils/classcode_generator.dart';
import 'package:classenger_frontend/utils/classrooms_info.dart';

class CreateJoinClassroom extends StatefulWidget{
  const CreateJoinClassroom({super.key});

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
  bool classroomExists = false;
  // late FirebaseFirestore _db;
  // late CollectionReference<Map<String, dynamic>> classroomsCollectionRef;
  // late CollectionReference<Map<String, dynamic>> usersCollectionRef;
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  // static Stream<bool> get stream => _controller.stream;

  void createClassroom() async {
    print('called create classroom');

    // adding classroom to classroom collection
    var classroom = await ClassInfo.classroomsCollectionRef.add({
      'classroom name': fieldText,
      'instructor': instructor,
      'classcode': classcode,
    });

    // adding classroom to (instructor) user's document
    var snapshot = await ClassInfo.usersCollectionRef.where('user name', isEqualTo: userName).get();
    var docs = snapshot.docs;

    if(docs.isNotEmpty) {
      final DocumentSnapshot document = docs.first;
      // final DocumentReference<Object?>  classroomsRef = document.reference;
      final CollectionReference<Map<String, dynamic>>  classroomsRef = document.reference.collection('classrooms');
      await classroomsRef.add({
        'class name': fieldText,
        'class code': classcode,
      });
      // ClassInfo.classroomIsEmpty = false;
      // ClassInfo.addController();
    } else {
      print('classroom not found');
    }
  }

  void joinClassroom() async{
    String? className;
    classcode = fieldText;

    // adding student to classroom document
    var classSnapshot= await ClassInfo.classroomsCollectionRef.where('classcode', isEqualTo: classcode).get();
    var classroom = classSnapshot.docs;

    print('called join classroom');
    
    if(classroom.isNotEmpty) {
      final DocumentSnapshot document = classroom.first;
      final CollectionReference<Map<String, dynamic>>  classroomsRef = document.reference.collection('students');
      await classroomsRef.add({
        'student name': userName,
        'student ID': userID,
      });
      var classObject = document.data() as Map<String, dynamic>;
      className = classObject['classroom name'];
    } else {
      print('classroom not found ln 70');
    }

    // adding classroom to student user's document
    var userSnapshot= await ClassInfo.usersCollectionRef.where('user name', isEqualTo: userName).get();
    var user = userSnapshot.docs;

    if(user.isNotEmpty) {
      final DocumentSnapshot document = user.first;
      final CollectionReference<Map<String, dynamic>>  classroomsRef = document.reference.collection('classrooms');
      await classroomsRef.add({
        'class name': className,
        'class code': classcode,
      });
      // ClassInfo.classroomIsEmpty = false;
      // ClassInfo.addController();
    } else {
      print('user not found ln 87...username: $userName');
    }
  }

  void doesClassroomExistAsync(String? value) async {
    var classSnapshot= await ClassInfo.classroomsCollectionRef.where('classcode', isEqualTo: classcode).get();
    var classroom = classSnapshot.docs;

    if (classroom.isNotEmpty) {
      classroomExists = classroom.first.exists;
    }
  }

  bool doesClassroomExist(String? value){
    doesClassroomExistAsync(value);
    return classroomExists;
  }

  @override 
  void initState(){
    super.initState();
    // _db = FirebaseFirestore.instance;
    // classroomsCollectionRef = _db.collection('classrooms');
    // usersCollectionRef = _db.collection('users');
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              if (userRole != 'Instructor') {
                if(!doesClassroomExist(value)) {
                  setState(() {
                    errorMsg = 'Classroom does not exist';
                  });
                  return 'Classroom does not exist';
                }
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
            if(userRole != 'Instructor') classcode = textController.text;
            if(!formKey.currentState!.validate()) {
              print('text in create or join form invalid');
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