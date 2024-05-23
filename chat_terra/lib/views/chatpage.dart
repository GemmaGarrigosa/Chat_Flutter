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
  List<Map<String, dynamic>> messages = [];
  final String usuari;

  TextEditingController textController = TextEditingController();

  void handleSubmitted(String text) {
    textController.clear();
    final chat = db.collection('chat');
    final timestamp = FieldValue.serverTimestamp();
    final data = {"nom": usuari, "text": text, "hora": timestamp};
    chat.doc().set(data);
    messages.add(data);
    setState(() {}); // Torna a carregar la llista
  }

  Future<List<Map<String, dynamic>>> showTextMessages() async {
    messages = [];
    final chat = db
        .collection('chat')
        .orderBy('hora', descending: true); // indiquem el nom de la colecció
    final querySnapshot = await chat.get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        messages.add(doc.data());
      }
    } else {
      print("No data found in the chat collection.");
    }
    print(messages);
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Terra'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          // Embolcallem en un Future Builder per a que la llista sigui dinàmica
          FutureBuilder<List<Map<String, dynamic>>>(
            future:
                showTextMessages(), //cridem a la funció per a obtindre els missatges
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages =
                    snapshot.data!; // guardem la llista de missatges

                return Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (_, int index) => buildMessage(
                        messages[index]['text'], messages[index]['nom']),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
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
  Widget buildMessage(String text, String nom) {
    return Card(
      child: ListTile(
        title: Text('$nom: $text'),
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
