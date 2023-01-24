import 'package:classenger_frontend/utils/user_credentials.dart';
import 'package:classenger_frontend/widgets/message_box.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String groupId;

  const ChatPage({super.key, required this.groupId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          const SizedBox(height: 8),
          StreamBuilder(
            stream: _firestore
              .collection('classrooms')
              .where('classcode', isEqualTo: widget.groupId)
              .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData) {
                var classroomSnap = snapshot.data!.docs.first;
                return Text(
                  classroomSnap['classroom name'],
                  style: Theme.of(context).textTheme.headlineSmall,
                  softWrap: true,
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          ),
          const SizedBox(height: 8),
          Text(
            'Class code: ${widget.groupId}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('groups')
                  .doc(widget.groupId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data?.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages!) {
                  final messageText = message['text'];
                  final messageSender = message['sender'];
                  final messageTimestamp = message['timestamp'].toDate().toString();
                  final messageWidget = MessageBox(text: messageText, sender: messageSender, timestamp: messageTimestamp);
                  messageWidgets.add(messageWidget);
                }
                return CustomScrollView(
                  slivers: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Send a message'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _firestore
                  .collection('groups')
                  .doc(widget.groupId)
                  .collection('messages')
                  .add({
                'text': _textController.text,
                'sender': userName,
                'timestamp': Timestamp.now(),
              });
              _textController.clear();
            },
            child: const Text('Send'),
          ),
          const SizedBox(height: 10,),
        ],
    );
  }
}