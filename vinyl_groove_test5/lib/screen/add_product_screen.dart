import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vinyl_groove_test5/controller/product_controller.dart';
import 'package:vinyl_groove_test5/utils/info.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';
import 'package:vinyl_groove_test5/utils/widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductController productController = ProductController();

  TextEditingController albumName_controller = TextEditingController();
  TextEditingController artist_controller = TextEditingController();
  TextEditingController price_controller = TextEditingController();
  TextEditingController barcode_controller = TextEditingController();
  TextEditingController detail_controller = TextEditingController();

  String? select_genre;
  String? select_condition;
  String? select_tradeMethod;

  File? imagePath;
  String? uploadUrl;
  bool isUpload = false;

  bool testImage = false;

  Map<String, String> conditionText = {
    'SS': '미개봉 새상품',
    'M': 'Mint - 완벽한 상태',
    'NM': 'Near Mint - 거의 새것',
    'EX': 'Excellent - 약간의 사용감',
    'VG+': 'Very Good+ - 양호',
    'VG': 'Very Good - 사용감 있음',
    'G': 'Good - 재생 가능',
  };

  Future<void> pickImage(ImageSource source) async {
    if (testMode) {
      setState(() {
        imagePath = null;
        testImage = true;
        isUpload = true;
      });

      final byteData = await rootBundle.load('assets/images/vinyl_sample.png');
      final image =
          "data:image/png;base64,${base64Encode(byteData.buffer.asUint8List())}";
      final url = await productController.upload_image(image);

      setState(() {
        uploadUrl = url;
        isUpload = false;
      });
      return;
    }

    final picker = ImagePicker();
    final pick = await picker.pickImage(source: source);
    if (pick == null) return;

    setState(() {
      imagePath = File(pick.path);
      isUpload = true;
    });

    final bytes = await imagePath!.readAsBytes();
    final url = await productController.upload_image(
      "data:image/png;base64,${base64Encode(bytes)}",
    );

    setState(() {
      uploadUrl = url;
      isUpload = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (testMode) {
      select_genre = 'ROCK';
      select_condition = 'SS';
      select_tradeMethod = 'DIRECT';
    }
  }

  @override
  void dispose() {
    albumName_controller.dispose();
    artist_controller.dispose();
    price_controller.dispose();
    barcode_controller.dispose();
    detail_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Color(0xff211e15),
        title: Text(
          "상품 등록",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              selectImage(),
              textField(
                text: '앨범명',
                hintText: '앨범명을 입력하세요',
                controller: albumName_controller,
              ),
              textField(
                text: '아티스트',
                hintText: '아티스트을 입력하세요',
                controller: artist_controller,
              ),
              chips(
                text: '장르',
                codes: genreCodes,
                selectText: select_genre,
                onTap: (value) => setState(() => select_genre = value),
              ),
              chips(
                text: '음반 상태',
                codes: {for (var k in conditionText.keys) k: k},
                selectText: select_condition,
                onTap: (value) => setState(() => select_condition = value),
                isCondition: true,
              ),
              textField(
                text: '가격',
                hintText: '가격을 입력하세요',
                controller: price_controller,
              ),
              chips(
                text: '거래 방식',
                codes: tradeMethodCodes,
                selectText: select_tradeMethod,
                onTap: (value) => setState(() => select_tradeMethod = value),
              ),
              textField(
                text: '바코드 번호',
                hintText: '바코드 번호 (선택)',
                controller: barcode_controller,
                required: false,
              ),
              textField(
                text: '상품 설명',
                hintText: '상품에 대한 상세 설명을 입력하세요',
                controller: detail_controller,
                required: false,
                maxLine: 5,
              ),
              addButton(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void showImagePick() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            GestureDetector(
              onTap: () {
                pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
              child: Text(
                "카메라",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
            ),
            GestureDetector(
              onTap: () {
                pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              child: Text(
                "갤러리",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectImage() {
    return GestureDetector(
      key: ValueKey('imagepick'),
      onTap: () => showImagePick(),
      child: Container(
        height: 200,
        width: MediaQuery.widthOf(context),
        decoration: BoxDecoration(
          color: coverColor,
          borderRadius: BorderRadius.circular(12),
          image: imagePath != null
              ? DecorationImage(
                  image: FileImage(imagePath!),
                  fit: BoxFit.cover,
                )
              : testImage
              ? DecorationImage(
                  image: AssetImage("assets/images/vinyl_sample.png"),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imagePath != null
            ? null
            : testImage
            ? null
            : Column(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: subColor.withValues(alpha: 0.5),
                    size: 45,
                  ),
                  Text(
                    '상품 이미지를 등록하세요',
                    style: TextStyle(
                      color: subColor.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '터치하여 카메라/갤러리 선택',
                    style: TextStyle(
                      color: subColor.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget textField({
    required String text,
    required String hintText,
    required TextEditingController controller,
    int maxLine = 1,
    bool required = true,
  }) {
    return Column(
      spacing: 3,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$text ${required ? '*' : ''}',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        TextFormField(
          controller: controller,
          inputFormatters: [
            if (text == '가격') FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: border(subColor.withValues(alpha: 0.2)),
            focusedBorder: border(subColor.withValues(alpha: 0.2)),
            disabledBorder: border(subColor.withValues(alpha: 0.2)),
            enabledBorder: border(subColor.withValues(alpha: 0.2)),
            hint: Text(
              hintText,
              style: TextStyle(
                color: subColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            counterText: '',
          ),
          maxLines: maxLine,
          minLines: maxLine,
        ),
      ],
    );
  }

  Widget chips({
    required String text,
    required String? selectText,
    required Map<String, String> codes,
    required Function(String value) onTap,
    bool isCondition = false,
  }) {
    return Column(
      spacing: 3,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$text *',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        chipWrap(
          codes: codes,
          select: (key) => selectText == key,
          onTap: (key) => onTap(key),
          add: true,
        ),
        if (isCondition && select_condition != null)
          Text(
            conditionText[select_condition]!,
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
          ),
      ],
    );
  }

  Widget addButton() {
    return button(
      context: context,
      text: '등록하기',
      onTap: () async {
        String? error = confirm();

        if (error == null) {
          final res = await productController.add(
            albumName: albumName_controller.text.trim(),
            artist: artist_controller.text.trim(),
            genre: select_genre!,
            condition: select_condition!,
            price: int.parse(price_controller.text.trim()),
            tradeMethod: select_tradeMethod!,
            albumImage: uploadUrl!,
            barcode: barcode_controller.text.trim(),
            description: detail_controller.text.trim(),
          );

          if (res) {
            Navigator.pop(context, true);
          }
        } else {
          showMessage(error);
          return;
        }
      },
    );
  }

  String? confirm() {
    if (uploadUrl == null) return "상품 이미지를 등록해주세요.";
    if (albumName_controller.text.trim().isEmpty) return '앨범명을 입력해주세요.';
    if (artist_controller.text.trim().isEmpty) return '아티스트를 입력해주세요.';
    if (select_genre == null) return '장르를 선택해주세요.';
    if (select_condition == null) return '음반 상태를 선택해주세요.';
    if (price_controller.text.trim().isEmpty) return '가격을 입력해주세요.';
    final price = int.parse(price_controller.text.trim());
    if (price < 1000) return '가격은 1,000원 이상 입력해주세요.';
    if (select_tradeMethod == null) return '거래 방식을 선택해주세요.';

    return null;
  }
}
