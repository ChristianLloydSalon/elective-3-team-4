import 'package:flutter/material.dart';
import 'package:classenger_frontend/widgets/section_content.dart';
import 'package:classenger_frontend/widgets/file_box.dart';

// must add file box child property para butangan sa file

class PostBox extends StatelessWidget{
  PostBox({
    required this.title,
    required this.dateTime,
    required this.hasFile,
    this.fileName,
    this.docType,
    this.url,
    super.key
  });

  String title;
  String dateTime;
  String? fileName, docType, url;
  bool hasFile;

  @override 
  Widget build(BuildContext context){
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
        textDirection: TextDirection.ltr,
        children: [
          // header of the post
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostHeader(
                  title: title,
                  dateTime: dateTime,
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (value) {
                    print('popup button pressed');
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Option 1'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Option 2'),
                    ),
                  ]
                ),
              ],
            ),
          ),
          // contents of the post
          SectionContent(
            text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
          ),
          hasFile == true
          ? FileBox(
            fileName: fileName!,
            docType: docType!,
            url: url!,
          )
          : const SizedBox(),
        ],
      ),
    );
  }
}

class PostHeader extends StatelessWidget{
  PostHeader({
    required this.title,
    required this.dateTime,
    super.key
  });

  String title;
  String dateTime;

  @override 
  Widget build(BuildContext context){
    return Row(
      children: [
        Text(
          // replace this string with the header of this post
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(width: 20,),
        // posting date
        Text(
          // replace this string with the time this is posted
          dateTime,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}