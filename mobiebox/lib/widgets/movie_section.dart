import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_details_page.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final int? userId;
  final String? role;

  const MovieSection(
    this.title,
    this.movies,
    this.userId,
    this.role, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 0, 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false, // 🔥 IMPORTANT
            physics: const BouncingScrollPhysics(), // 🔥 IMPORTANT
            itemCount: movies.length,
            itemBuilder: (_, index) {
              final movie = movies[index];

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailsPage(
                      movie: movie,
                      userId: userId, // Pass directly
                      role: role, // Pass directly
                    ),
                  ),
                ),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        // 🎬 IMAGE
                        Positioned.fill(
                          child: Image.network(movie.cover, fit: BoxFit.cover),
                        ),

                        // 🌈 GRADIENT
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black87],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),

                        // ⭐ TITLE + RATING
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "⭐ ${movie.rating}",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
