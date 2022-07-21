import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
    required this.title,
  });

  final CameraDescription camera;
  final String title;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: SpinKitRing(color: Colors.blue));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            // Attempt to take a picture and get the file `image` where it was saved.
            final image = await _controller.takePicture();
            if (!mounted) return;
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DisplayPictureScreen(imagePath: image.path,),),);
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Billede')),
      // The image is stored as a file on the device. Use the `Image.file` constructor with the given path to display the image.
      body: ListView(
        shrinkWrap: true,
        children: [
          Image.file(File(imagePath)),
          Container(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.add_a_photo), label: Text("Nyt billede"),),
                Padding(padding: EdgeInsets.only(right: 20)),
                ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.save), label: Text("Gem billede"),),
              ],
            ),
          ),
        ],
      )
    );
  }
}