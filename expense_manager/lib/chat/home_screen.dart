import 'package:flutter/material.dart';
import 'message_model.dart';
import 'chat_screen.dart';
class HomeScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          final Message chat = chats[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  pp: chat.sender,
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue,
                      child: Text(chat.sender.name[0]),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  chat.sender.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                               Container(
                                        child: null,
                                      ),
                              ],
                            ),
                            Text(
                              chat.time,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            chat.text,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.group_add),),
    );
  }
}
