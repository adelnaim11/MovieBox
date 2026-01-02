import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class AdminManageMoviesPage extends StatefulWidget {
  const AdminManageMoviesPage({super.key});

  @override
  State<AdminManageMoviesPage> createState() => _AdminManageMoviesPageState();
}

class _AdminManageMoviesPageState extends State<AdminManageMoviesPage> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    // Re-use your existing ApiService.fetchMovies()
    // _moviesFuture = ApiService.fetchMovies();
  }

  Future<void> _deleteMovie(int id) async {
    final url = Uri.parse(
      "http://10.0.2.2/movies_backend/api/delete_movie.php",
    );
    try {
      final response = await http.post(url, body: jsonEncode({"id": id}));
      final data = jsonDecode(response.body);
      if (data['success']) {
        setState(() => _loadMovies()); // Refresh list
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Movie Deleted")));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Manage Inventory"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final movie = snapshot.data![index];
              return Card(
                color: Colors.white10,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Image.network(
                    movie.cover,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    movie.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    movie.category,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => _confirmDelete(movie.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Movie?"),
        content: const Text(
          "This will permanently remove the movie and all its images.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMovie(id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
