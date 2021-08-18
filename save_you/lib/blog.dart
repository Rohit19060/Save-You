import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

final db = FirebaseFirestore.instance;
String? name, title, blog;
final formName = GlobalKey<FormState>();

Color wh = Colors.white, bl = Colors.blue;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    King(),
  );
}

class King extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Kn(),
    );
  }
}

class Kn extends StatefulWidget {
  @override
  _KnState createState() => _KnState();
}

class _KnState extends State<Kn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _nameFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 10,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(),
              accountName: Text(
                "Srishti Jain",
                style: TextStyle(
                  color: Colors.indigo,
                ),
              ),
              accountEmail: Text(
                "srishti1jain@gmail.com",
                style: TextStyle(
                  color: Colors.indigo,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Text(
                  "S",
                  style: TextStyle(fontSize: 40.0, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(
                Icons.star,
                color: Colors.indigoAccent,
              ),
              title: RichText(
                text: TextSpan(
                    text: "Visit Us",
                    style: TextStyle(color: Colors.indigo),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch(
                            'https://multi-chat-platform-ef4dc.firebaseapp.com');
                      }),
              ),
            ),
            InkWell(
              onTap: () {
                Share.share(
                    'https://multi-chat-platform-ef4dc.firebaseapp.com');
              },
              child: ListTile(
                  trailing: Icon(
                    Icons.share,
                    color: Colors.indigoAccent,
                  ),
                  title: Text(
                    "Share",
                    style: TextStyle(color: Colors.indigo),
                  )),
            ),
            InkWell(
              onTap: () {
                var router = MaterialPageRoute(
                  builder: (BuildContext context) => NextScreen(
                    name: _nameFieldController.text,
                  ),
                );
                Navigator.of(context).push(router);
              },
              child: ListTile(
                trailing: Icon(
                  Icons.account_box,
                  color: Colors.indigoAccent,
                ),
                title: Text(
                  "About",
                  style: TextStyle(color: Colors.indigo),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: Icon(Icons.menu, color: Colors.redAccent),
        ),
        actions: [
          Tooltip(
            child: Icon(
              Icons.help_outline,
              color: Colors.blueAccent,
            ),
            message: "Help",
          ),
          SizedBox(width: 20)
        ],
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Technology Blog",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: wh,
      ),
      body: Container(
        color: wh,
        child: StreamBuilder<QuerySnapshot>(
            stream: db.collection("blogs").snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final docData = doc.data() as Map;
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Card(
                        elevation: 0,
                        child: ListTile(
                          title: Text(
                            "Name : ${docData['Name']} \nTitle : ${docData['Title']}",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          subtitle: Text(
                            'Blog : ${docData['Blog']}',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 22),
                          ),
                          trailing: IconButton(
                            icon: Tooltip(
                              message: "Delete Blog",
                              child: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.redAccent,
                              ),
                            ),
                            onPressed: () {
                              db.collection("blogs").doc(doc.id).delete();
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return SizedBox();
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 4.0,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add a Blog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Form(
                key: formName,
                child: Container(
                  height: 290,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value2) {
                          if (value2 != null && value2.isEmpty) {
                            return "Please Enter a Name";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => name = value!,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value2) {
                          if (value2 != null && value2.isEmpty) {
                            return "Please Enter a Title";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value1) => title = value1!,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Blog",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value2) {
                          if (value2 != null && value2.isEmpty) {
                            return "Please Enter a Blog";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value2) => blog = value2!,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: bl,
                    ),
                    onPressed: () {
                      if (formName.currentState!.validate()) {
                        formName.currentState!.save();
                        db.collection("blogs").add({
                          'Blog': '$blog',
                          'Name': '$name',
                          'Title': '$title',
                          'data': "1"
                        });
                        Navigator.pop(context);
                      }
                    })
              ],
            ),
          );
        },
      ),
    );
  }
}

class NextScreen extends StatefulWidget {
  final String name;
  NextScreen({Key? key, required this.name}) : super(key: key);
  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.redAccent),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 18.0, right: 18.0),
          child: SizedBox(
            height: 220.0,
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                      size: 26.0,
                    ),
                    title: Text(
                      "BRCM-CET Bahal",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text("Software Developer"),
                  ),
                  Divider(
                    color: Colors.blue,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.blue,
                      size: 26.0,
                    ),
                    title: Text(
                      "srishti1jain@gmail.com",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.blue,
                      size: 26.0,
                    ),
                    title: Text(
                      "+919034874772",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
