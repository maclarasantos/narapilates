import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/login.page.dart';

class EsqueciSenha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Reset(),
    );
  }
}

class Reset extends StatelessWidget {
  @override
  TextEditingController senha = TextEditingController();
  TextEditingController usuario = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
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

    Future<void> resetar() async {
      String pass = senha.text;
      String user = usuario.text;
      users.doc(user).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          String email = documentSnapshot.get('email');
          String senhaAtual = documentSnapshot.get('senha');
          if (email.length > 5 && senhaAtual == "aa") {
            users
                .doc(user)
                .update({'senha': pass})
                .then((value) => {
                      _showMyDialog("Senha alterada com sucesso!"),
                      Navigator.pop(context),
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                    })
                .catchError((error) => {_showMyDialog("Error")});
          } else {
            _showMyDialog(
                "Este usuário não existe ou a senha não pode ser alterada!");
          }
        } else {
          _showMyDialog(
              "Este usuário não existe ou a senha não pode ser alterada!");
        }
      });
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
              height: 15,
            ),
            Text(
              "Antes de alterar a senha,\n favor solicitar ao administrador",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
                controller: usuario,
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
            TextField(
                controller: senha,
                autofocus: true,
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
                  labelText: 'Informe a nova senha',
                )),
            SizedBox(
              height: 20,
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: resetar,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Concluir",
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
