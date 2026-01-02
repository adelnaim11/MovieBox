class Movie {
  final int id;
  final String title;
  final String description;
  final double rating;
  final String category;
  final String cover;
  final List<String> images;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.category,
    required this.cover,
    required this.images,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
      category: json['category'],
      cover: json['cover'],
      images: List<String>.from(json['images']),
    );
  }
}
