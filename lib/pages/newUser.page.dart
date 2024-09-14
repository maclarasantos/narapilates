import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/admin.page.dart';

class NovoUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: NewUser(),
    );
  }
}

class NewUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController user = TextEditingController();
    TextEditingController nome = TextEditingController();
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

    void tela() {
      Navigator.pop(context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminPage()));
    }

    Future<void> addUser() async {
      // Call the user's CollectionReference to add a new user
      String noome = nome.text;
      String uuser = user.text;

      users.doc(uuser).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          _showMyDialog("Usuário ja existe!");
        } else if (uuser.length > 5 && noome.length > 5) {
          users
              .doc(uuser)
              .set({'nome': noome, 'senha': "aa", 'user': uuser})
              .then((value) =>
                  {_showMyDialog("Usuário adicionado com sucesso!"), tela()})
              .catchError((error) => {_showMyDialog("Error")});
        } else {
          _showMyDialog("Cada campo deve ter no mínimo 5 caracteres");
        }
      });
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 240, left: 40, right: 40),
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
                maxLength: 30,
                controller: user,
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
                  labelText: "Digite o usuário do aluno",
                )),
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
                  labelText: "Digite o nome do aluno",
                )),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  addUser();
                },
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
