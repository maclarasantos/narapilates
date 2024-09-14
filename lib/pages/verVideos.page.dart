import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/detalheVideo.page.dart';
import 'package:narapilates/pages/admin.page.dart';

class VerVideosAdmin extends StatelessWidget {
  final vd = FirebaseFirestore.instance.collection('videos');

  late Future<QuerySnapshot> querySnapshot;

  Future<QuerySnapshot> viewVideo() async {
    return await vd.get();
  }

  @override
  Widget build(BuildContext context) {
    void proximaTela(id) async {
      String data, nome, url;
      String iid = id.toString();
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(iid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          data = documentSnapshot.get('data').toString();
          nome = documentSnapshot.get('nome').toString();
          url = documentSnapshot.get('url').toString();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetalheVideo(iid, url, data, nome)));
        }
      });
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
              future: viewVideo(),
              builder: (context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
                if (querySnapshot.connectionState == ConnectionState.waiting) {
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: querySnapshot.data?.docs.length,
                    itemBuilder: (_, index) {
                      return Container(
                        height: 70,
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Card(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        // Use Expanded aqui também
                                        child: Text(
                                            (querySnapshot.data?.docs[index]
                                                .get('nome')),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            leading: ButtonTheme(
                              buttonColor: Colors.white,
                              child: ElevatedButton(
                                onPressed: () {
                                  proximaTela(
                                      querySnapshot.data?.docs[index].id);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 97, 127, 151),
                                ),
                                child: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
