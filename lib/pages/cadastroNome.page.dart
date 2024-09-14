import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/login.page.dart';
import 'package:url_launcher/url_launcher.dart';

class CadastroCompletoPage extends StatelessWidget {
  String usuario, nome;

  CadastroCompletoPage(this.usuario, this.nome);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Name(usuario, nome),
    );
  }
}

class Name extends StatelessWidget {
  String usuario, nome;

  Name(this.usuario, this.nome);
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController telefone = TextEditingController();
    TextEditingController senha = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    void tela() {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alerta!', textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Alerta!', textAlign: TextAlign.center),
                  Text('Cada campo deve ter no mínimo 5 caracteres!',
                      textAlign: TextAlign.center),
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

    Future<void> addUser() async {
      // Call the user's CollectionReference to add a new user
      if (senha.text.length > 5 &&
          email.text.length > 5 &&
          telefone.text.length > 5) {
        users
            .doc(usuario)
            .set({
              'nome': nome,
              'senha': senha.text,
              'user': usuario,
              'email': email.text,
              'telefone': telefone.text
            })
            .then((value) => tela())
            .catchError((error) => print("Failed to add user: $error"));
      } else {
        _showMyDialog();
      }
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 150, left: 40, right: 40),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 110,
              height: 110,
              child: Image.asset(
                'Images/logo.png',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
                enabled: false,
                autofocus: false,
                readOnly: true,
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
                  labelText: usuario,
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                enabled: false,
                autofocus: false,
                readOnly: true,
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
                  labelText: nome,
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                controller: email,
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
                  labelText: "Digite seu e-mail",
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                controller: telefone,
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
                  labelText: "Digite seu telefone",
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                controller: senha,
                autofocus: false,
                readOnly: false,
                obscureText: true,
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
                  labelText: "Digite sua senha",
                )),
            SizedBox(
              height: 20,
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: addUser,
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
