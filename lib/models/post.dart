// lib/models/post.dart
class Post {
  final String usuario;
  String imagem;
  final double latitude;
  final double longitude;

  Post({
    required this.usuario,
    required this.imagem,
    required this.latitude,
    required this.longitude,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      usuario: json['usuario'],
      imagem: json['imagem'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario,
      'imagem': imagem,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
