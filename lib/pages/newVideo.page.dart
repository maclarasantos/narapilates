import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/cadastroNome.page.dart';
import 'package:narapilates/pages/admin.page.dart';
import 'package:intl/intl.dart';

class NovoVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: NewVideo(),
    );
  }
}

class NewVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController url = TextEditingController();
    TextEditingController nome = TextEditingController();
    CollectionReference video = FirebaseFirestore.instance.collection('videos');
    var now = DateTime.now();

    void telas() {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminPage()));
    }

    Future<void> _showMyDialog(String text) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alerta!', textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(text, textAlign: TextAlign.center),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> addVideo() async {
      // Call the user's CollectionReference to add a new user
      String urrl = url.text;
      String noome = nome.text;
      String daata = new DateFormat("dd/MM/yyyy").format(now);
      String data = "Data de postagem: " + daata;
      print('sem senha: ${data}');

      if (urrl.length > 5 && noome.length > 5) {
        video
            .doc()
            .set({'nome': noome, 'url': urrl, 'data': data})
            .then((value) =>
                {_showMyDialog("Vídeo adicionado com sucesso!"), telas()})
            .catchError((error) {
              _showMyDialog("Error");
            });
      } else {
        _showMyDialog("Cada campo deve ter no mínimo 5 caracteres");
      }
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 240, left: 40, right: 40),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Image.asset(
                'Images/logo.png',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
                controller: url,
                autofocus: false,
                readOnly: false,
                obscureText: false,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                  labelText: "Digite o url do video",
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                maxLength: 30,
                controller: nome,
                autofocus: false,
                readOnly: false,
                obscureText: false,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                  labelText: "Digite o nome do vídeo",
                )),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: addVideo,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Salvar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
