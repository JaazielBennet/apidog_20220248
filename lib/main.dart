import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ApiDog_20220248',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'characteristics',
      ),
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
  late Future<Map<String, dynamic>> _futureCharacter;

  @override
  void initState() {
    super.initState();
    _futureCharacter = _fetchCharacter();
  }

  Future<Map<String, dynamic>> _fetchCharacter() async {
    final response = await http.get(
      Uri.parse('https://api.thedogapi.com/v1/breeds/11'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load character');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureCharacter,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/8/83/American_Bully..jpg'),
                  Text('Name: ${snapshot.data!['name']}'),
                  Text('Height: ${snapshot.data!['height']['imperial']}'),
                  Text('Mass: ${snapshot.data!['weight']['imperial']}'),
                  Text('Temperament: ${snapshot.data!['temperament']}'),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
