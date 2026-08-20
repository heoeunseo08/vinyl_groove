import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vinyl_groove_test6/controller/product_controller.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';
import 'package:vinyl_groove_test6/uitls/widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  ProductController productController = ProductController();
  TextEditingController albumName_controller = TextEditingController();
  TextEditingController artist_controller = TextEditingController();
  TextEditingController price_controller = TextEditingController();
  TextEditingController barcode_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();

  String? select_genre = null;
  String? select_condition = null;
  String? select_tradeMethod = null;

  String? add_url;
  File? imagePath;
  bool is_load = false;
  bool testImage = false;

  Map<String, String> add_conditionCodes = {
    'SS': '미개봉 새상품',
    'M': 'Mint - 완벽한 상태',
    'NM': 'Near Mint - 거의 새것',
    'EX': 'Excellent - 약간의 사용감',
    'VG+': 'Very Good+ - 양호',
    'VG': 'Very Good - 사용감 있음',
    'G': 'Good - 재생 가능',
  };

  Future<void> imagePick(ImageSource source) async {
    if (testMode) {
      setState(() {
        testImage = true;
        is_load = true;
      });

      final byteData = await rootBundle.load('assets/images/vinyl_sample.png');
      final image = base64Encode(byteData.buffer.asUint8List());
      final url = await productController.iamge_add(image);
      setState(() {
        testImage = true;
        add_url = url;
        is_load = false;
      });
      return;
    }

    final picker = ImagePicker();
    final pick = await picker.pickImage(source: source);
    if (pick == null) return;

    setState(() {
      imagePath = File(pick.path);
      is_load = true;
    });

    final byteData = await imagePath!.readAsBytes();
    final image = base64Encode(byteData);
    final url = await productController.iamge_add(image);
    setState(() {
      add_url = url;
      is_load = false;
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    if (testMode) {
      select_genre = genreCodes().keys.first;
      select_condition = add_conditionCodes.keys.first;
      select_tradeMethod = tradeMethodCodes.keys.first;
    }
  }

  @override
  void dispose() {
    albumName_controller.dispose();
    artist_controller.dispose();
    price_controller.dispose();
    barcode_controller.dispose();
    description_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '상품 등록',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 30,
            children: [selectImage(), input(), addButton(),SizedBox()],
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
                imagePick(ImageSource.camera);
                Navigator.pop(context);
              },
              child: Text(
                "카메라로 촬영",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
            ),
            GestureDetector(
              onTap: () {
                imagePick(ImageSource.gallery);
                Navigator.pop(context);
              },
              child: Text(
                "갤러리에서 선택",
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

  Widget input() {
    return Column(
      crossAxisAlignment: .start,
      spacing: 16,
      children: [
        field(
          controller: albumName_controller,
          text: '앨범명',
          hint: '앨범명을 입력하세요',
        ),
        field(
          controller: artist_controller,
          text: '아티스트',
          hint: '아티스트명을 입력하세요',
        ),
        select_chips(
          codes: genreCodes(),
          text: '장르',
          select_text: select_genre,
          onTap: (value) => setState(() => select_genre = value),
        ),
        select_chips(
          codes: {for (var k in add_conditionCodes.keys) k: k},
          text: '음반 상태',
          select_text: select_condition,
          onTap: (value) => setState(() => select_condition = value),
          conditions: true,
        ),
        field(controller: price_controller, text: '가격', hint: '가격을 입력하세요'),
        select_chips(
          codes: tradeMethodCodes,
          text: '거래 방식',
          select_text: select_tradeMethod,
          onTap: (value) => setState(() => select_tradeMethod = value),
        ),
        field(
          controller: barcode_controller,
          text: '바코드 번호',
          hint: '바코드 번호 (선택)',
          required: false,
        ),
        field(
          controller: description_controller,
          text: '상품 설명',
          hint: '상품에 대한 상세 설명을 입력하세요',
          required: false,
        ),
      ],
    );
  }

  Widget select_chips({
    required Map<String, String> codes,
    required String text,
    required String? select_text,
    required Function(String value) onTap,
    bool conditions = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            '$text *',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
        chipWrap(
          add: true,
          codes: codes,
          select: (key) => select_text == key,
          onTap: (key) => onTap(key),
        ),
        if (conditions && select_condition != null)
          Text(
            add_conditionCodes[select_condition]!,
            style: TextStyle(
              color: subColor.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget field({
    required TextEditingController? controller,
    required String text,
    bool required = true,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              if (required)
                Text(
                  " *",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          minLines: text == '상품 설명' ? 3 : 1,
          maxLines: text == '상품 설명' ? 3 : 1,
          inputFormatters: [if(text =='가격')FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: border(subColor.withValues(alpha: 0.3)),
            focusedBorder: border(mainColor),
            focusedErrorBorder: border(mainColor),
            enabledBorder: border(subColor.withValues(alpha: 0.3)),
            disabledBorder: border(subColor.withValues(alpha: 0.3)),
            hint: Text(
              hint,
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
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
            albumImage: add_url!,
            barcode: barcode_controller.text.trim(),
            description: description_controller.text.trim(),
          );

          if (res) {
            Navigator.pop(context, true);
          }
        } else {
          showMessage(text: error);
          return;
        }
      },
    );
  }

  String? confirm() {
    if (add_url == null) return "상품 이미지를 등록해주세요.";
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
