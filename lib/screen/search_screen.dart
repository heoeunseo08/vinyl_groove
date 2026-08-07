import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinyl_groove/controller/product_controller.dart';
import 'package:vinyl_groove/utils/info.dart';
import 'package:vinyl_groove/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.genre});

  final String? genre;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ProductController productController = ProductController();
  TextEditingController keyword_controller = TextEditingController();
  Set<String> selectGenre = {};
  bool filterUpDown = false;

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) {
      selectGenre.add(widget.genre!);
    }
    load();
  }

  Future<void> load() async {
    await productController.loadList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              appbar(),
              SizedBox(height: 12),
              input(),
            ],
          ),
        ),
      ),
    );
  }

  Widget appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/simbol/logo_vertical.png",
          height: 50,
        ),
        GestureDetector(
          onTap: () => showMessage("준비 중입니다."),
          child: SvgPicture.asset(
            "assets/icons/notification.svg",
            color: Colors.white,
            height: 25,
          ),
        ),
      ],
    );
  }

  Widget input() {
    return Column(
      children: [
        TextFormField(
          controller: keyword_controller,
          onChanged: (value) => setState(() {}),
          decoration: InputDecoration(
            border: border(coverColor),
            disabledBorder: border(coverColor),
            focusedBorder: border(coverColor),
            enabledBorder: border(coverColor),
            prefixIcon: Icon(CupertinoIcons.search, color: subColor),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (keyword_controller.text.trim().isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => keyword_controller.text = ''),
                    child: Icon(
                      Icons.clear,
                      color: subColor,
                    ),
                  ),
                GestureDetector(
                  onTap: () => showMessage("준비 중입니다."),
                  child: SvgPicture.asset(
                    "assets/icons/barcode-scan.svg",
                    color: Colors.white,
                    height: 25,
                  ),
                ),
              ],
            ),
            hint: Text(
              "앨범명, 아티스트 검색",
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "필터",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                "필터 초기화",
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        if (filterUpDown)
          Column(
            children: [
              Container(color: Colors.white,width: 200,height:40,)
            ],
          ),
        GestureDetector(
          onTap: () => setState(() => filterUpDown = !filterUpDown),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                filterUpDown ? "접기" : "펼치기",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                filterUpDown
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: subColor,size: 16,
              ),
            ],
          ),
        ),
        Divider(color: subColor.withOpacity(0.2)),
      ],
    );
  }
}
