// lib/providers/post_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import '../models/post.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    var parse = Uri.parse("https://m2.guilhermesperb.com.br/feed");
    final response = await http.get(parse);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _posts = data.map((json) => Post.fromJson(json)).toList();
      notifyListeners();
      print("Posts fetched successfully: ${_posts.length} posts");
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> addPost(Post post, File imageFile) async {
    final uri = Uri.parse('https://m2.guilhermesperb.com.br/new');

    final mimeTypeData =
        lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])?.split('/');

    final request = http.MultipartRequest('POST', uri)
      ..fields['usuario'] = post.usuario
      ..fields['latitude'] = post.latitude.toString()
      ..fields['longitude'] = post.longitude.toString()
      ..files.add(await http.MultipartFile.fromPath(
        'imagem',
        imageFile.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ));

    // Enviar a requisição
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final responseBody = json.decode(responseData.body);
      post.imagem = responseBody['imagem'];
      _posts.add(post);
      notifyListeners();
      print("Post added successfully: ${post.imagem}");
    } else {
      throw Exception('Failed to post image');
    }
  }
}
