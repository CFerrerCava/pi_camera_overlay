import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Test",
      home: ExampleCameraOverlay(),
    );
  }
}

class ExampleCameraOverlay extends StatefulWidget {
  const ExampleCameraOverlay({Key? key}) : super(key: key);

  @override
  _ExampleCameraOverlayState createState() => _ExampleCameraOverlayState();
}

class _ExampleCameraOverlayState extends State<ExampleCameraOverlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CameraOverlay(
        onCapture: (XFile file) => showDialog(
          context: context,
          barrierColor: Colors.black,
          builder: (context) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              backgroundColor: Colors.black,
              title: const Text('Capture',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
              actions: [
                OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close))
              ],
              content: SizedBox(
                child: Image.file(File(file.path)),
              ),
            );
          },
        ),
      ),
    );
  }
}
