import 'package:flutter/material.dart';
import 'package:classenger_frontend/widgets/section_content.dart';
import 'package:classenger_frontend/widgets/section_header.dart';
import 'package:classenger_frontend/widgets/file_box.dart';

// must add file box child property para butangan sa file

class PostBox extends StatelessWidget{
  PostBox({
    required this.header,
    required this.body,
    required this.timestamp,
    // this.fileName,
    // this.docType,
    // this.url,
    super.key
  });

  String header;
  String body;
  String timestamp;
  // String? fileName, docType, url;
  // bool hasFile;

  @override 
  Widget build(BuildContext context){
    return Container(
      // height: MediaQuery.of(context).size.height * 0.3,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff4e5c72),
          width: 1.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.ltr,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header of the post
            PostHeader(
              header: header,
              timestamp: timestamp,
            ),
            const SizedBox(height: 8,),
            // PopupMenuButton(
            //   icon: const Icon(Icons.more_horiz),
            //   onSelected: (value) {
            //     print('popup button pressed');
            //   },
            //   itemBuilder: (context) => [
            //     const PopupMenuItem(
            //       value: 1,
            //       child: Text('Option 1'),
            //     ),
            //     const PopupMenuItem(
            //       value: 2,
            //       child: Text('Option 2'),
            //     ),
            //   ]
            // ),
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
        SectionHeader(
          // replace this string with the header of this post
          text: header,
          // style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(width: 20,),
        // posting date
        Text(
          // replace this string with the time this is posted
          timestamp,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:classenger_frontend/widgets/section_content.dart';
// import 'package:classenger_frontend/widgets/file_box.dart';

// // must add file box child property para butangan sa file

// class PostBox extends StatelessWidget{
//   PostBox({
//     required this.header,
//     required this.body,
//     required this.timestamp,
//     // this.fileName,
//     // this.docType,
//     // this.url,
//     super.key
//   });

//   String header;
//   String body;
//   String timestamp;
//   // String? fileName, docType, url;
//   // bool hasFile;

//   @override 
//   Widget build(BuildContext context){
//     return Container(
//       margin: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: const Color(0xff4e5c72),
//           width: 2.0,
//         ),
//         borderRadius: const BorderRadius.all(Radius.circular(8))
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         textDirection: TextDirection.ltr,
//         children: [
//           // header of the post
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 PostHeader(
//                   header: header,
//                   timestamp: timestamp,
//                 ),
//                 PopupMenuButton(
//                   icon: const Icon(Icons.more_horiz),
//                   onSelected: (value) {
//                     print('popup button pressed');
//                   },
//                   itemBuilder: (context) => [
//                     const PopupMenuItem(
//                       value: 1,
//                       child: Text('Option 1'),
//                     ),
//                     const PopupMenuItem(
//                       value: 2,
//                       child: Text('Option 2'),
//                     ),
//                   ]
//                 ),
//               ],
//             ),
//           ),
//           // contents of the post
//           SectionContent(
//             text: body,
//           ),
//           // hasFile == true
//           // ? FileBox(
//           //   fileName: fileName!,
//           //   docType: docType!,
//           //   url: url!,
//           // )
//           // : const SizedBox(),
//         ],
//       ),
//     );
//   }
// }

// class PostHeader extends StatelessWidget{
//   PostHeader({
//     required this.header,
//     required this.timestamp,
//     super.key
//   });

//   String header;
//   String timestamp;

//   @override 
//   Widget build(BuildContext context){
//     return Row(
//       children: [
//         Text(
//           // replace this string with the header of this post
//           header,
//           style: Theme.of(context).textTheme.headlineSmall,
//         ),
//         const SizedBox(width: 20,),
//         // posting date
//         Text(
//           // replace this string with the time this is posted
//           timestamp,
//           style: Theme.of(context).textTheme.labelSmall,
//         ),
//       ],
//     );
//   }
// }