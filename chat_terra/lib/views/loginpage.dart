import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String usuari = "";

  TextEditingController textController = TextEditingController();

  void handleSubmitted(String text) {
    setState(() {
      usuari = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Benvingut al Chat Terra'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Card(
          color: Colors.green,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  onSubmitted: handleSubmitted,
                  decoration: InputDecoration.collapsed(
                    hintText: "Introdueix un nom d'usuari",
                  ),
                ),
                SizedBox(height: 10.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => handleSubmitted(textController.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
