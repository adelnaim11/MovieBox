import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiTestPage extends StatefulWidget {
  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String data = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.0.29/movies_backend/api/movies.php"),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          data = json.encode(jsonData, toEncodable: (e) => e.toString());
        });
        print(jsonData); // also print to console
      } else {
        setState(() {
          data = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        data = "Exception: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Test")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(data),
      ),
    );
  }
}
