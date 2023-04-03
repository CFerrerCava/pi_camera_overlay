import 'package:flutter/material.dart';
import 'package:flutter_camera_overlay/model.dart';

class OverlayShape extends StatelessWidget {
  const OverlayShape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var size = media.size;
    double width = size.width * ratiowidth;

    double height = size.height * ratioheight;

    if (media.orientation == Orientation.portrait) {}
    return Stack(
      children: [
        Align(
            alignment: Alignment.center,
            child: Container(
              width: width,
              height: height,
              decoration: ShapeDecoration(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                      side: const BorderSide(width: 1, color: Colors.purple))),
            )),
        ColorFiltered(
          colorFilter: const ColorFilter.mode(
              Color.fromARGB(117, 13, 12, 10), BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(radius)),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
