import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.usuari});
  final String usuari;

  @override
  _ChatScreenState createState() => _ChatScreenState(usuari: usuari);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState({required this.usuari});
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String usuari;

  TextEditingController textController = TextEditingController();

  void handleSubmitted(String text) {
    textController.clear();
    final chat = db.collection('chat');
    final data = {"nom": usuari, "text": text};
    chat.doc().set(data);
  }

  Future<List<Map<String, dynamic>>> showTextMessages() async {
    final List<Map<String, dynamic>> messages = [];
    final chat = db.collection('chat'); // indiquem el nom de la colecció
    // Retrieve data
    chat.get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          messages.add(docSnapshot.data());
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    print(messages);
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    showTextMessages();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Terra'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (_, int index) =>
                  buildMessage(messages[index]['text']),
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

//Metode que retorna un widget amb el text
  Widget buildMessage(String text) {
    return Card(
      child: ListTile(
        title: Text('$usuari: $text'),
      ),
      shadowColor: Colors.green,
      elevation: 3,
    );
  }

//Metode que retorna un widget amb el input de text
  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            //Es un flex
            child: TextField(
              controller: textController,
              onSubmitted:
                  handleSubmitted, //Event que borra el contingut del controller i reomple amb el text nou
              decoration: InputDecoration.collapsed(
                hintText: "Envia un missatge",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => handleSubmitted(textController.text),
          ),
        ],
      ),
    );
  }
}
