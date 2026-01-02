import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String baseUrl = "http://localhost/movies_backend/api";

  static Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movies.php'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  static Future<Movie> fetchMovieDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie_details.php?id=$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception("Movie not found");
    }
  }

  static Future<void> rateMovie(int userId, int movieId, double rating) async {
    final url = Uri.parse('$baseUrl/rate_movie.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'movie_id': movieId,
        'rating': rating,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to rate movie');
    }

    final data = jsonDecode(response.body);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to rate movie');
    }
  }
}
