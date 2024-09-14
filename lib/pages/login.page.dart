import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:narapilates/pages/aluno.page.dart';
import 'package:narapilates/pages/admin.page.dart';
import 'package:narapilates/pages/cadastro.page.dart';
import 'package:narapilates/pages/loginResetSenha.page.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Login(),
    );
  }
}

class Login extends StatelessWidget {
  TextEditingController user = TextEditingController();
  TextEditingController senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('User');

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
                  Text('Usuário ou senha incorretos',
                      textAlign: TextAlign.center),
                  Text(
                      'Caso não possua usuário, fale com o administrador ou cadastre-se',
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

    Future<void> login(BuildContext context) async {
      String nome = user.text;
      String pass = senha.text;

      // Verifica se é o administrador
      if (nome == 'admin' && pass == 'admin2024') {
        // Garante que a navegação ocorra após o processo de construção
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        });
        return;
      }

      // Verifica se a senha tem o comprimento adequado
      if (pass.length > 2) {
        try {
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
              .collection('User')
              .doc(nome)
              .get();

          if (documentSnapshot.exists) {
            String passFire = documentSnapshot.get('senha');
            print('Document data: $passFire');

            if (passFire == pass) {
              // Senha correta, navega para a página do aluno
              print('senha certa');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AlunoPage()),
                );
              });
            } else {
              // Senha incorreta, mostra o diálogo de erro
              _showMyDialog();
            }
          } else {
            // Documento não existe, mostra o diálogo de erro
            _showMyDialog();
          }
        } catch (e) {
          print("Erro ao verificar usuário: $e");
          _showMyDialog();
        }
      } else {
        // Senha com menos de 2 caracteres, mostra o diálogo de erro
        _showMyDialog();
      }
    }

    Future<void> loading() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext contexxt) {
          login(contexxt);
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.1,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: new Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 260, left: 40, right: 40),
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
                  labelText: 'Usuário',
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                controller: senha,
                cursorRadius: Radius.circular(10),
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
                  labelText: 'Senha',
                )),
            SizedBox(
              height: 40,
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: loading,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Entrar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextButton(
              child: Text('Esqueci minha senha',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EsqueciSenha()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroPage()),
          );
        },
        tooltip: 'Increment',
        label: Text('Cadastre-se', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 97, 127, 151),
      ),
    );
  }
}
