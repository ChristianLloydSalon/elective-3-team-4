import 'package:flutter/material.dart';
import 'package:classenger_frontend/widgets/drawer_custom.dart';
import 'package:classenger_frontend/widgets/post_box.dart';

class LectureMaterialsScreen extends StatelessWidget{
  const LectureMaterialsScreen({super.key});

  // still need to create function that fetches all posts
  // create function to validate if user is student or instructor
  // give instructors edit and create access
  // also create checker if naa bay attachment such as files or links

  // must add file box child property para butangan sa file
  

  @override 
  Widget build(BuildContext context){
    return DrawerCustom(
      title: 'Classenger',
      scaffoldBody: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PostBox(
              title: 'Course Syllabus',
              dateTime: '11/10/2022 10:00AM',
              hasFile: true,
              fileName: 'https://www.nku.edu/~foxr/CSC462/ch1-sample-problems.pdf',
              docType: 'docx',
              url: 'https://www.nku.edu/~foxr/CSC462/ch1-sample-problems.pdf',
            ),
          ),
          SliverToBoxAdapter(
            child: PostBox(
              title: 'Handout No. 1',
              dateTime: '11/12/2022 8:30AM',
              hasFile: true,
              fileName: 'https://www.nku.edu/~foxr/CSC462/ch1-sample-problems.pdf',
              docType: 'docx',
              url: 'https://www.nku.edu/~foxr/CSC462/ch1-sample-problems.pdf',
            ),
          ),
        ],
      ),
    );
  }
}