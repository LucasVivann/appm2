// lib/screens/capture_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/post.dart';
import '../providers/post_provider.dart';
import 'dart:convert';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureAndPostImage() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final imagebytes = await image.readAsBytes();
      final imagebase64 = base64.encode(imagebytes);
      final imageFile = File(image.path);

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final newPost = Post(
        usuario: 'Usuario',
        imagem:
            imagebase64, // A URL da imagem será obtida do servidor após o upload
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Chame addPost passando os dois argumentos necessários
      await Provider.of<PostProvider>(context, listen: false)
          .addPost(newPost, imageFile);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Image'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: _captureAndPostImage,
      ),
    );
  }
}
