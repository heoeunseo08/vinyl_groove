import 'package:flutter/material.dart';
import 'package:vinyl_groove/controller/favorite_controller.dart';
import 'package:vinyl_groove/model/product_model.dart';
import 'package:vinyl_groove/utils/info.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        automaticallyImplyLeading: false,
        title: Text(
          "관심 상품",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: FavoriteController.instance.ids.isEmpty
          ? noList()
          : Column(
              children: [

              ],
            ),
    );
  }

  Widget card(ProductModel model){
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            model.albumImage,
            width:90,
            height:90,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 90,
              height: 90,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget noList() => Column(
    spacing: 6,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(width: MediaQuery.widthOf(context)),
      Icon(Icons.favorite_border,color: subColor,size: 80,),
      Text(
        '관심 상품이 없습니다',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: subColor,
        ),
      ),
      Text(
        '마음에 드는 상품에 하트를 눌러보세요',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: subColor.withValues(alpha: 0.6),
        ),
      ),
    ],
  );
}
