import 'package:flutter/material.dart';
import 'package:narapilates/pages/newUser.page.dart';
import 'package:narapilates/pages/verVideos.page.dart';
import 'package:narapilates/pages/newVideo.page.dart';
import 'package:narapilates/pages/verUsers.page.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Botoes(),
    );
  }
}

class Botoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 300, left: 40, right: 40),
        child: ListView(
          children: <Widget>[
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VerVideosAdmin()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Ver vídeos disponíveis",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerUsersAdmin()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Ver usuários cadastrados",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NovoVideo()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Adicionar novo vídeo",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NovoUser()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Adicionar novo usuário",
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
