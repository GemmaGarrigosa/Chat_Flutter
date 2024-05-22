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
  final List<Map<String, dynamic>> messages = [];
  final String usuari;

  TextEditingController textController = TextEditingController();

  void handleSubmitted(String text) {
    textController.clear();
    final chat = db.collection('chat');
    final data = {"nom": usuari, "text": text};
    chat.doc().set(data);
  }

  void showTextMessages() async {
    final chat = db.collection('chat'); // indiquem el nom de la colecció
    // Retrieve data
    final querySnapshot = await chat.get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        messages.add(doc.data()); //This will print each document's data
      }
    } else {
      print("No data found in the chat collection.");
    }

    print(messages);
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
