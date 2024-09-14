import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/verVideoUser.dart';

class AlunoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void page() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VerVideosUser()));
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Scaffold(
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
              ButtonTheme(
                height: 45,
                child: ElevatedButton(
                  onPressed: page,
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
            ],
          ),
        ),
      ),
    );
  }
}
