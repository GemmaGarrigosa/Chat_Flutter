import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.usuari});
  final String usuari;

  @override
  _ChatScreenState createState() => _ChatScreenState(usuari: usuari);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState({required this.usuari});
  final List<String> messages = [];
  final String usuari;

  TextEditingController textController = TextEditingController();

  void handleSubmitted(String text) {
    textController.clear();
    setState(() {
      messages.insert(0, text);
    });
    print(usuari);
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
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (_, int index) => buildMessage(messages[index]),
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
        title: Text('Usuari: $text'),
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
