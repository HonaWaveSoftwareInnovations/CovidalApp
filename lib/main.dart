import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List usuarios = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("users");

    QuerySnapshot users = await collectionReference.get();

    if (users.docs.isNotEmpty) {
      List tempList = [];
      for (var doc in users.docs) {
        print(doc.data());
        tempList.add(doc.data());
      }
      setState(() {
        usuarios = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            usuarios.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    var user = usuarios[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text("Nombre: ${user['name']}"),
                        subtitle: Text("Trabajo: ${user['job']}"),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
