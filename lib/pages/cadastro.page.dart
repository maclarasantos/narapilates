import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/cadastroNome.page.dart';
import 'package:url_launcher/url_launcher.dart';

class CadastroPage extends StatelessWidget {
  CadastroPage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Cadastro(),
    );
  }
}

class Cadastro extends StatelessWidget {
  Cadastro();

  @override
  TextEditingController user = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('User');

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

    Future<void> nextStep() {
      String usuario = user.text;
      String nome;
      String passFire;
      FirebaseFirestore.instance
          .collection('User')
          .doc(usuario)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          passFire = documentSnapshot.get('senha');
          print('Document data: ${passFire}');
          if (passFire == "aa") {
            nome = documentSnapshot.get('nome');
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CadastroCompletoPage(usuario, nome)));
          } else if (passFire != null) {
            print('senha certa');
            _showMyDialog("Usuário ja cadastrado");
          }
        } else {
          _showMyDialog("Usuário sem cadastro, falar com o administrador");
        }
      });
      return Future.value();
    }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 270, left: 40, right: 40),
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
              height: 40,
            ),
            TextField(
                controller: user,
                autofocus: true,
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
                  labelText: 'Informe o usuário',
                )),
            SizedBox(
              height: 20,
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: nextStep,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Continuar",
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
