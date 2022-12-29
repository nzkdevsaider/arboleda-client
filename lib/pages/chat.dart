import 'package:arboledaapp/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class Chat extends StatefulWidget {
  final UserData user;

  const Chat({Key? key, required this.user}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8000/ws'),
  );
  final List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Chat'),
            Expanded(
              child: StreamBuilder(
                  stream: channel.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }

                    if (snapshot.hasData) {
                      var data = json.decode(snapshot.data);

                      if (data['event'] == 'send-message') {
                        // Agrega el mensaje recibido a la lista de mensajes
                        messages.add(snapshot.data);
                        // Crea un ListView que muestre cada mensaje en un ListTile
                        return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              var chatData = jsonDecode(messages[index]);

                              return ListTile(
                                  title: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          'https://www.w3schools.com/howto/img_avatar.png'),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(chatData["user"]["username"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            chatData["messageData"]["message"]),
                                      ],
                                    ),
                                  ],
                                ),
                              ));
                            });
                      }
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (text) {
                      channel.sink.add(jsonEncode({
                        'event': 'send-message',
                        'message': text,
                      }));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
