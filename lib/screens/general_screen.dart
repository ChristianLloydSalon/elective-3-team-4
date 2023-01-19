import 'package:classenger_frontend/popups/edit_general.dart';
import 'package:flutter/material.dart';
import 'package:classenger_frontend/widgets/drawer_custom.dart';
import 'package:classenger_frontend/widgets/section_header.dart';
import 'package:classenger_frontend/widgets/section_content.dart';
import 'package:classenger_frontend/popups/edit_general.dart';
import 'login_signup_screen.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';
import 'package:firebase_database/firebase_database.dart';

class GeneralScreen extends StatefulWidget{
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  late List<GeneralContent> generalContent;
  late String userRole;

  // create function to fetch data to be displayed in this screen
  // final databaseReference = FirebaseDatabase.instance.ref().child('generalContent');

  // void getContent(){
  //   // Get the data from the "people" node
  //   databaseReference.once().then((event) {
  //     // Use the data from the snapshot to create a list of Person objects
  //     final contents = event.snapshot.value as Map<dynamic, dynamic>;
  //     contents.forEach((key, value) {
  //       generalContent.add(GeneralContent(value['header'], value['content']));
  //     });
  //   });
  // }

  @override
  void initState(){
    super.initState();
    userRole = getUserRole();
  }

  @override 
  Widget build(BuildContext context){
    return DrawerCustom(
      title: 'Classenger', 
      scaffoldBody: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SectionHeader(text: 'Instructor'),
          ),
          SliverToBoxAdapter(
            child: SectionContent(text: 'Juan de la Cruz'),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(text: 'Course Description'),
          ),
          SliverToBoxAdapter(
            child: SectionContent(text: 'This course provides advanced topics in embedded systems using contemporary practice; interrupt-driven, reactive, real-time, object-oriented, and distributed client/server embedded systems.\nNumber of Units per Lecture: 3\nNumber of Contact Hours per week: 3 hours per week\nPrerequisites: Microprocessors'),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(text: 'Course Outline'),
          ),
          SliverToBoxAdapter(
            child: SectionContent(text: 'dummy data'),
          ),


          // dummy data starts here to check if scroll works
          // deleted dummy data
          // scroll does work properly

          // edit button for instructor user
          // if(userRole == 'Instructor')
          //   SliverToBoxAdapter(
          //     child: Container(
          //       constraints: BoxConstraints(
          //         maxWidth: MediaQuery.of(context).size.width * 0.1,
          //       ),
          //       margin: const EdgeInsets.all(15),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           showDialog(
          //             context: context, 
          //             builder: (BuildContext context){
          //               return EditGeneral();
          //             }
          //           );
          //         }, 
          //         child: const Text(
          //           'Edit',
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
      editButton: userRole == 'Instructor'
        ? FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (BuildContext context){
                  return EditGeneral();
                }
              );
            }, 
            child: const Icon(Icons.edit)
          )
      : null,
    );
  }
}

class GeneralContent{
  String header;
  String section;

  GeneralContent(this.header, this.section);
}
