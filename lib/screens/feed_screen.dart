import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/post_provider.dart';
import '../models/post.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<PostProvider>(context, listen: false).fetchPosts();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      final String usuario = 'Lucas';
      final double latitude = 0.0;
      final double longitude = 0.0;

      final post = Post(
        usuario: usuario,
        imagem: '',
        latitude: latitude,
        longitude: longitude,
      );

      await Provider.of<PostProvider>(context, listen: false)
          .addPost(post, imageFile);
      Provider.of<PostProvider>(context, listen: false).fetchPosts();
    }
  }

  XFile newMethod(XFile pickedFile) => pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: Consumer<PostProvider>(
        builder: (ctx, postProvider, _) {
          return ListView.builder(
            itemCount: postProvider.posts.length,
            itemBuilder: (ctx, index) {
              final post = postProvider.posts[index];
              return ListTile(
                leading: post.imagem.isNotEmpty
                    ? Image.network(post.imagem)
                    : Icon(Icons.image),
                title: Text(post.usuario),
                subtitle:
                    Text('Lat: ${post.latitude}, Long: ${post.longitude}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
