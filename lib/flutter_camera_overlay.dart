import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flutter_camera_overlay/overlay_shape.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';

class CameraOverlay extends StatefulWidget {
  const CameraOverlay({
    required this.onCapture,
    Key? key,
    this.flash = false,
    this.child,
    this.loadingWidget,
  }) : super(key: key);

  final bool flash;
  final Function(XFile file) onCapture;
  final Widget? child;
  final Widget? loadingWidget;

  @override
  _FlutterCameraOverlayState createState() => _FlutterCameraOverlayState();
}

class _FlutterCameraOverlayState extends State<CameraOverlay> {
  _FlutterCameraOverlayState();

  CameraController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>?>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            Widget loadingWidget = widget.loadingWidget ??
                Container(
                  color: Colors.white,
                  height: double.infinity,
                  width: double.infinity,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text('loading camera'),
                  ),
                );
            return loadingWidget;
          }
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No camera found',
                    style: TextStyle(color: Colors.black),
                  ));
            }
            controller =
                CameraController(snapshot.data!.first, ResolutionPreset.max);

            return FutureBuilder<void>(
                future: controller?.initialize(),
                builder: (context, snapshot) {
                  if (controller?.value.isInitialized == true) {
                    controller?.setFlashMode(
                        widget.flash == true ? FlashMode.auto : FlashMode.off);
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(controller!),
                        const OverlayShape(),
                        if (widget.child != null) widget.child!,
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle,
                              ),
                              margin: const EdgeInsets.all(25),
                              child: IconButton(
                                enableFeedback: true,
                                color: Colors.white,
                                onPressed: () {
                                  _onCapture();
                                },
                                iconSize: 50,
                                icon: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100)),
                                      border: Border.all(
                                          color: Colors.purpleAccent,
                                          width: 2)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                });
          }
          return Container();
        });
  }

  void _onCapture() async {
    for (int i = 10; i > 0; i--) {
      await HapticFeedback.vibrate();
    }
    XFile file = await controller!.takePicture();
    var decodedImage =
        await decodeImageFromList(File(file.path).readAsBytesSync());
    int newWith = (decodedImage.width * 0.6).toInt();
    int newHeight = (decodedImage.height * ratioheight).toInt();
    int offsetX = (decodedImage.width - newWith) ~/ 2;
    int offsetY = (decodedImage.height - newHeight) ~/ 2;

    final imageBytes = decodeImage(File(file.path).readAsBytesSync())!;

    img.Image cropOne = img.copyCrop(
      imageBytes,
      x: offsetX,
      y: offsetY,
      width: newWith,
      height: newHeight,
    );

    File(file.path).writeAsBytes(encodePng(cropOne)).then((value) {
      widget.onCapture(XFile(file.path));
    });
  }
}
