import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narapilates/pages/detalheUser.page.dart';
import 'package:narapilates/pages/admin.page.dart';

class VerUsersAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    onWillPop:
    () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
      return false; // Bloqueia o comportamento padrão e navega para a página desejada
    };
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Usersss(),
    );
  }
}

class Usersss extends StatelessWidget {
  final vd = FirebaseFirestore.instance.collection('User');

  late Future<QuerySnapshot> querySnapshot;

  Future<QuerySnapshot> viewUser() async {
    // Call the user's CollectionReference to add a new user
    return await vd.get();
  }

  @override
  Widget build(BuildContext context) {
    void tela() {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminPage()));
    }

    void verDetalheUser(user) async {
      String usuario = user.toString();
      String senha, nome, email, telefone;
      await FirebaseFirestore.instance
          .collection('User')
          .doc(usuario)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;
          senha =
              data != null && data.containsKey('senha') && data['senha'] != null
                  ? data['senha'].toString()
                  : 'Senha não cadastrada';
          nome =
              data != null && data.containsKey('nome') && data['nome'] != null
                  ? data['nome'].toString()
                  : 'Nome não cadastrado';
          email =
              data != null && data.containsKey('email') && data['email'] != null
                  ? data['email'].toString()
                  : 'Email não cadastrado';

          // Verifica se o campo 'telefone' existe e não é nulo
          telefone = data != null &&
                  data.containsKey('telefone') &&
                  data['telefone'] != null
              ? data['telefone'].toString()
              : 'Número não cadastrado';
          if (telefone.isEmpty || telefone == "null") {
            telefone = "Número não cadastrado";
          }
          if (email.isEmpty || email == "null") {
            email = "Email não cadastrado";
          }
          if (senha == "aa") {
            senha = "Senha não cadastrada";
          } else {
            senha = "Senha cadastrada";
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetalheUser(usuario, email, telefone,
                      senha, nome, documentSnapshot)));
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
              future: viewUser(),
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
                            subtitle: Row(
                              children: [
                                Text(
                                    (querySnapshot.data?.docs[index]
                                            .get('user'))
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    )),
                              ],
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                        (querySnapshot.data?.docs[index]
                                            .get('nome')),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            leading: ButtonTheme(
                              buttonColor: Colors.white,
                              child: ElevatedButton(
                                onPressed: () {
                                  verDetalheUser(querySnapshot.data?.docs[index]
                                      .get('user'));
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
