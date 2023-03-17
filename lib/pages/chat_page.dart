import 'package:chat_app/constant.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  CollectionReference messages = FirebaseFirestore.instance.collection(kMessagesCollections);
  TextEditingController controller= TextEditingController();
  ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt , descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  kLogo,
                  height: 50,
                ),
                Text('Chat'),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                  return messagesList[index].id == email ? ChatBubble(message: messagesList[index],
                  ): ChatBubbleForFriend(message: messagesList[index]);
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: controller,
                  onSubmitted: (data) {
                    messages.add({
                      kMessage :data,
                      kCreatedAt : DateTime.now(),
                      'id' : email,
                    });
                    controller.clear();
                        _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                      },
                  decoration: InputDecoration(
                    hintText: 'Send message',
                    suffixIcon: Icon(
                      Icons.send,
                      color: kPrimaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        } else {
          return Text('is loading..');
        }
      }
    );
  }
}
