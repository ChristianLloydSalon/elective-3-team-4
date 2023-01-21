import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ClassInfo {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> classroomsCollectionRef = _db.collection('classrooms');
  static CollectionReference<Map<String, dynamic>> usersCollectionRef = _db.collection('users');

  static bool classroomIsEmpty = true;
  
  static final StreamController<bool> controller = StreamController<bool>();
  static Stream<bool> get stream => controller.stream;

  static void addController() {
    controller.add(classroomIsEmpty);
  }
}