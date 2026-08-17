import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove_test3/utils/info.dart';
import 'package:vinyl_groove_test3/utils/util.dart';

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

  Uint8List rotate90(Uint8List src, int width, int height, int bytesPerRow) {
    final rotated = Uint8List(width * height);
    for (int y = 0; y < height; y++) {
      final rowStart = y * bytesPerRow;
      for (int x = 0; x < width; x++) {
        final newX = height - y - 1;
        final newY = x;
        rotated[newX + newY * height] = src[rowStart + x];
      }
    }
    return rotated;
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
      setState(() => isReady = true);
      cameraController!.startImageStream(
            (image) async {
          if (isProcessing) return;
          isProcessing = true;

          try {
            final plane = image.planes[0];
            final rotated = rotate90(
              plane.bytes,
              image.width,
              image.height,
              plane.bytesPerRow,
            );

            final code = await channel.invokeMethod<String>(
              'barcode',
              {
                'bytes': rotated,
                'width': image.height,
                'height': image.width,
              },
            );

            if (code != null && code.isNotEmpty) {
              await cameraController?.stopImageStream();
              Navigator.pop(context, code.padLeft(13, '0'));
            }
          } catch (e) {
            print('[BARCODE] error: $e');
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
      appBar: appbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "상품의 바코드를 화면 중앙에 맞춰주세요",
            style: TextStyle(color: subColor, fontSize: 14),
          ),
          SizedBox(height: 16),
          Expanded(child: cameraView()),
          SizedBox(height: 20),
          input(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget cameraView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxW = constraints.maxWidth * 0.7;
        final boxH = boxW * 0.5;
        return ClipRect(
          child: SizedBox.expand(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isReady && cameraController != null)
                  Positioned.fill(
                    child: Builder(
                      builder: (context) {
                        final size = cameraController!.value.previewSize!;
                        return FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: min(size.width, size.height),
                            height: size.width > size.height
                                ? size.width
                                : size.height,
                            child: CameraPreview(cameraController!),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(color: bgColor),

                Positioned.fill(
                  child: CustomPaint(
                    painter: background(boxW: boxW, boxH: boxH),
                  ),
                ),
                SizedBox(
                  width: boxW,
                  height: boxH,
                  child: CustomPaint(painter: corner()),
                ),
                SizedBox(
                  width: boxW,
                  child: Container(
                    height: 2,
                    color: Colors.yellow.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget input() {
    return GestureDetector(
      onTap: () async {
        TextEditingController barcode_input = TextEditingController();
        final code = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("직접 입력"),
            content: TextFormField(
              controller: barcode_input,
            ),
            actions: [
              GestureDetector(
                onTap: () => Navigator.pop(context, barcode_input.text.trim()),
                child: Text('검색'),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text('취소'),
              ),
            ],
          ),
        );
        if (code != null && code.isNotEmpty) {
          Navigator.pop(context, code.padLeft(13, '0'));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          SvgPicture.asset(
            "assets/icons/barcode-scan.svg",
            height: 20,
            color: subColor,
          ),
          Text(
            "직접 입력",
            style: TextStyle(
              color: subColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? appbar() {
    return AppBar(
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
    );
  }
}

class background extends CustomPainter {
  background({super.repaint, required this.boxW, required this.boxH});

  final double boxW;
  final double boxH;

  @override
  void paint(Canvas canvas, Size size) {
    final outer = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Path()
      ..addRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: boxW,
          height: boxH,
        ),
      );

    final overlay = Path.combine(PathOperation.difference, outer, hole);
    canvas.drawPath(
      overlay,
      Paint()..color = Colors.black.withValues(alpha: 0.5),
    );
  }

  @override
  bool shouldRepaint(covariant background oldDelegate) {
    return oldDelegate.boxW != boxW || oldDelegate.boxH != boxH;
  }
}

class corner extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, 0), Offset(20, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, 20), paint);

    canvas.drawLine(Offset(size.width, 0), Offset(size.width - 20, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, 20), paint);

    canvas.drawLine(Offset(0, size.height), Offset(20, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - 20), paint);

    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - 20, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant corner oldDelegate) => false;
}