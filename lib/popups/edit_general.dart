import 'package:flutter/material.dart';

class EditGeneral extends StatefulWidget{
  EditGeneral({super.key});

  @override
  State<EditGeneral> createState() => _EditGeneralState();
}

class _EditGeneralState extends State<EditGeneral> {
  TextEditingController textController = TextEditingController();

  late String text;

  @override 
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(
        'Edit General Channel',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: TextField(
        controller: textController,
        autofocus: true,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Text',
          hintText: 'Enter some text here',
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            setState(() {
              text = textController.text;
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}