import 'package:flutter/material.dart';

class DrawerCustom extends StatefulWidget{
  DrawerCustom({required this.title, required this.scaffoldBody, super.key});

  String title;
  Widget scaffoldBody;

  @override
  State<DrawerCustom> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<DrawerCustom> {
  // List<String> getItems(){
  //   // add code to fetch data from firebase
  //   return ['hi', 'hello', 'hagdok'];
  // }

  bool isExpanded = false;

  List<String> items = [
    'CPE 411 - Mechanics of Deformable Bodies', 
    'CPE 416 - Artificial Intelligence', 
    'CPE 415 - Embedded Systems'
  ];

  List<String> defClassContent = [
    'General',
    'Lecture Materials',
    'Activities',
    'Quizzes',
    'Major Exams',
    'Projects',
    'Group Chat',
    '+ Add Channel',
  ];

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: AppBar().preferredSize.height,
          padding: const EdgeInsets.all(5.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'logo.png',
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(width: 10,),
              Text(widget.title),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      endDrawer: Drawer(
        backgroundColor: const Color(0xff4e5c72),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                const ListTile(
                  title: Text(
                    'Classrooms',
                    style: TextStyle(
                      // fontSize: MediaQuery.of(context).size.height * 0.03,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ),
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index){
                  return InkWell(
                    onTap: () {
                      // just a temporary print to see if drawer works
                      print('items on drawer tapped');
                    },
                    child: ExpansionTile(
                      title: Text(
                        items[index],
                        style: const TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
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
                              
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
                childCount: items.length,
              ),
            ),
          ],
        ),
      ),
      body: widget.scaffoldBody,
    );
  }
}