import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_test4/controller/product_controller.dart';
import 'package:vinyl_groove_test4/model/product_model.dart';
import 'package:vinyl_groove_test4/utils/info.dart';
import 'package:vinyl_groove_test4/utils/utils.dart';
import 'package:vinyl_groove_test4/utils/widget.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.product_id});

  final int product_id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await productController.loadDetail(widget.product_id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model = productController.detailModel;

    return Scaffold(
      body: productController.isDetailLoading
          ? loadingWidget()
          : CustomScrollView(
              slivers: [
                headerWidget(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        infoWidget(model!),
                        sellerCard(model),
                        conditionWidget(model),
                        priceCard(model),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: PayButton(),
    );
  }

  Widget infoWidget(DetailProductModel model) {
    final infos = [
      ?genreCodes[model.genre],
      model.condition,
      ?tradeMethodCodes[model.tradeMethod],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.albumName,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        SizedBox(height: 8),
        Text(
          model.artist,
          style: TextStyle(
            color: subColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        Row(
          spacing: 12,
          children: List.generate(
            3,
            (index) {
              final info = infos[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: coverColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  info,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget sellerCard(DetailProductModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mainColor.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.person,
                  color: mainColor,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.seller.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    model.seller.email,
                    style: TextStyle(
                      color: subColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: subColor, size: 16),
        ],
      ),
    );
  }

  Widget conditionWidget(DetailProductModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Text(
              "상태 등급",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black,
              ),
              child: Text(
                model.condition,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          model.conditionDescription,
          style: TextStyle(
            color: subColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),

        SizedBox(height: 16),

        Text(
          "상품 설명",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          model.description,
          style: TextStyle(
            color: subColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget priceCard(DetailProductModel model) {
    final won = NumberFormat('#,###').format(model.price);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: coverColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "가격",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                "거래 방식",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₩ $won",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                  color: mainColor,
                ),
              ),
              Text(
                tradeMethodCodes[model.tradeMethod]!,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget PayButton() {
    return Container(
      color: coverColor,
      height: 110,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          button(
            context: context,
            text: '구매하기',
            onTap: () => showMessage('준비 중입니다.'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  headerWidget() {
    return SliverAppBar(
      backgroundColor: bgColor,
      expandedHeight: 350,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            top: 0,
            right: 0,
            left: 0,
            child: Image.network(
              productController.detailModel!.albumImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: MediaQuery.widthOf(context),
                height: 250,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              width: MediaQuery.widthOf(context),
              height: 410,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, bgColor],
                ),
              ),
            ),
          ),
          Positioned(
            top: 45,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bgColor.withOpacity(0.8),
                      ),
                      child: Icon(Icons.arrow_back_outlined, color: Colors.white, size: 25),
                    ),
                  ),
                  favorite_button(id: productController.detailModel!.id,size: 25)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
