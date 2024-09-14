import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/verVideoUser.dart';
import 'package:narapilates/pages/admin.page.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class DetalheVideo extends StatelessWidget {
  var id, url, data, nome;
  DetalheVideo(this.id, this.url, this.data, this.nome);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: DetailVideo(id, url, data, nome),
    );
  }
}

class DetailVideo extends StatelessWidget {
  late String videoID;
  var id, url, data, nome;
  DetailVideo(this.id, this.url, this.data, this.nome);

  @override
  Widget build(BuildContext context) {
    telas() {
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

    Future<void> deleteVideo() {
      CollectionReference vd = FirebaseFirestore.instance.collection('videos');
      return vd
          .doc(id)
          .delete()
          .then(
              (value) => {_showMyDialog("Vídeo deletado com sucesso"), telas()})
          .catchError((error) => {
                _showMyDialog("Error"),
              });
    }

    Future<void> deleteMenssageVideo() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alerta!', textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Você tem certeza que deseja excluir esse vídeo?",
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
                  deleteVideo();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 270, left: 40, right: 40),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextField(
                enabled: false,
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
                  labelText: nome,
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                enabled: false,
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
                  labelText: url,
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                enabled: false,
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
                  labelText: data,
                )),
            SizedBox(
              height: 20,
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                onPressed: deleteMenssageVideo,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Excluir",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ButtonTheme(
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color.fromARGB(255, 97, 127, 151),
                ),
                child: Text(
                  "Assistir vídeo",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  videoID = YoutubePlayerController.convertUrlToId(url)!;
                  print('passou $videoID');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => YoutubeViewer(videoID)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
