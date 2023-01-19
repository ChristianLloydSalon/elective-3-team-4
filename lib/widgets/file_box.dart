import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FileBox extends StatelessWidget{
  FileBox({
    required this.fileName,
    required this.docType, 
    required this.url,
    super.key
  });

  String fileName, docType, url;

  @override 
  Widget build(BuildContext context){
    return InkWell(
      hoverColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xff5e9d8d),
            width: 1,
          ),
        ),
        child: Text(
          fileName,
        ),
      ),
      onTap: () async {
        Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not launch $uri';
        }
      },
    );
  }
}