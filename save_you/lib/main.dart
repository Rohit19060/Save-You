import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save You',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          canvasColor: Colors.white),
      home: MyHomePage(title: 'Save You'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 10,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(),
              accountName: Text(
                "Rohit Jain",
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              accountEmail: Text(
                "rohitjain19060@gmail.com",
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  "R",
                  style: TextStyle(fontSize: 40.0, color: Colors.white),
                ),
              ),
            ),
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(),
              accountName: Text(
                "Garima methi",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              accountEmail: Text(
                "gmethi123@gmail.com",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Text(
                  "G",
                  style: TextStyle(fontSize: 40.0, color: Colors.white),
                ),
              ),
            ),
            InkWell(
              child: ListTile(
                  trailing: Icon(
                    Icons.star,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    "Visit Us",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    launch('https://kingtechnologies.in');
                  }),
            ),
            InkWell(
                child: ListTile(
                    trailing: Icon(
                      Icons.share,
                      color: Colors.redAccent,
                    ),
                    title: Text(
                      "Share",
                      style: TextStyle(color: Colors.blueAccent),
                    ),),
                onTap: () {
                  Share.share('https://kingtechnologies.in');
                }),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shape: CircleBorder(),
                padding: EdgeInsets.all(60),
              ),
              child: Text(
                'Guide',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Kn(),
                  ),),
            ),
            SizedBox(
              height: 60,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shape: CircleBorder(),
                padding: EdgeInsets.all(60),
              ),
              child: Text(
                'Air Tracer',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AirTrack(),
                  ),),
            )
          ],
        ),
      ),
    );
  }
}

class Kn extends StatefulWidget {
  @override
  _KnState createState() => _KnState();
}

class _KnState extends State<Kn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Guide",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: wh,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.linearToSrgbGamma(),
            image: AssetImage("images/1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: db.collection("Notes").snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map;
                    return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Data(
                              title: data["Note"],
                              data: data["Data"],
                            ),
                          ),),
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: wh,
                          border: Border.all(color: bl),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          title: Text(
                            data["Note"].toString(),
                            style: TextStyle(fontSize: 22),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Form(
                key: formName,
                child: Container(
                  color: Colors.white,
                  height: 155,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Please Enter a Title";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => title = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Data",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Please Enter a Data";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => blog = value,
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
                        db.collection("Notes").add({
                          'Note': '$title',
                          'Data': '$blog',
                          'TimeStamp': DateTime.now(),
                        });
                        Navigator.pop(context);
                      }
                    })
              ],
            ),
          );
        },
        child: Icon(Icons.add_circle_outline),
        backgroundColor: wh,
        foregroundColor: bl,
      ),
    );
  }
}

class AirTrack extends StatefulWidget {
  @override
  _AirTrackState createState() => _AirTrackState();
}

class _AirTrackState extends State<AirTrack> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            mapType: MapType.hybrid,
            compassEnabled: true,
            initialCameraPosition: CameraPosition(
              target: const LatLng(28.6375729, 75.3657894),
              zoom: 2,
            ),
          ),
          Center(
            child: Text(
              'Air Pollution Level: Good(0-50)',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class Data extends StatefulWidget {
  Data({Key? key, required this.title, required this.data}) : super(key: key);
  final String title;
  final String data;

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: EdgeInsets.all(17.0),
          child: Text(
            widget.data,
            style: TextStyle(fontSize: 25),
          ),),
    );
  }
}
