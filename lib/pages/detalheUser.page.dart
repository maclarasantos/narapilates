import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/verUsers.page.dart';

class DetalheUser extends StatelessWidget {
  final String usuario, nome, senha, email, telefone;
  final dynamic doc;

  DetalheUser(
      this.usuario, this.email, this.telefone, this.senha, this.nome, this.doc);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: User(usuario, email, telefone, senha, nome, doc),
    );
  }
}

class User extends StatelessWidget {
  final String usuario, nome, senha, email, telefone;
  final dynamic doc;

  User(
      this.usuario, this.email, this.telefone, this.senha, this.nome, this.doc);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    // Função para navegação personalizada ao pressionar o botão de voltar
    Future<bool> _onWillPop() async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VerUsersAdmin()),
      );
      return false; // Bloqueia o comportamento padrão
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

    Future<void> deleteUser() {
      return users.doc(usuario).delete().then((value) {
        _showMyDialog("Usuário deletado com sucesso");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VerUsersAdmin()));
      }).catchError((error) {
        _showMyDialog("Error ao deletar usuário");
      });
    }

    Future<void> deleteMessage() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alerta!', textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Você tem certeza que deseja excluir esse usuário?",
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Sim'),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteUser();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> resetPassword() {
      return users.doc(usuario).update({'senha': "aa"}).then((value) {
        _showMyDialog("Senha resetada com sucesso!");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VerUsersAdmin()));
      }).catchError((error) => print("Failed to update user: $error"));
    }

    return WillPopScope(
      onWillPop: _onWillPop, // Intercepta o botão de voltar
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 150, left: 40, right: 40),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              TextField(
                enabled: false,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                  labelText: usuario,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                enabled: false,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                  labelText: nome,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                enabled: true,
                readOnly: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                  labelText: email,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                enabled: true,
                readOnly: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                  labelText: telefone,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                enabled: true,
                readOnly: false,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                  labelText: senha,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Resetar senha",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: deleteMessage,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Excluir usuário",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
