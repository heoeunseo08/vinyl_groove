import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove/controller/method_controller.dart';
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  CameraController? cameraController;
  bool isReady = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (e) => e.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      setState(() {});
      cameraController!.startImageStream(
        (image) async {
          if (isProcessing) return;
          isProcessing = true;

          try {
            final plane = image.planes[0];
            final code = await MethodController.channel.invokeMethod<String>(
              'barcode',
              {
                'bytes': plane.bytes,
                'width': image.width,
                'height': image.height,
              },
            );

            if (code != null && code.isNotEmpty) {
              await cameraController?.stopImageStream();
              Navigator.pop(context, code.padLeft(13, '0'));
            }
          } catch (e) {
            print('$e');
          }
          isProcessing = false;
        },
      );
    } catch (e) {
      print('$e');
      showMessage('카메라 권한이 필요합니다.');
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, color: subColor, size: 35),
            ),
            Text(
              "바코드 검색",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(width: 35),
          ],
        ),
      ),
    );
  }
}
