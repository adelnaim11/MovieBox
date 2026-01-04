class Movie {
  final int id;
  final String title;
  final String description;
  final double rating;
  final int votes;
  final String category;
  final String cover;
  final List<String> images;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.votes,
    required this.category,
    required this.cover,
    required this.images,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      rating: (json['rating'] ?? 0.0 as num).toDouble(),
      votes: json['votes']?.toInt() ?? 0,
      category: json['category'],
      cover: json['cover'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}
