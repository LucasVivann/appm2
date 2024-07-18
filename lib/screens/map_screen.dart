// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/post.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context)!.settings.arguments as Post;

    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('Map View'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(post.latitude, post.longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId(post.imagem),
            position: LatLng(post.latitude, post.longitude),
            infoWindow: InfoWindow(
              title: post.usuario,
              snippet: '${post.latitude}, ${post.longitude}',
            ),
          ),
        },
      ),
    );
  }
}
