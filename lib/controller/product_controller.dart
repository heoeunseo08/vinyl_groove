import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test3/model/product_model.dart';
import 'package:vinyl_groove_test3/utils/info.dart';
import 'package:vinyl_groove_test3/utils/util.dart';

class ProductController {
  bool isListLoading = false;
  bool isMyListLoading = false;
  bool isDetailLoading = false;
  List<ProductModel> productList = [];
  List<MyProductModel> myProductList = [];
  ProductDetailModel? detailModel;
  bool hasNext = true;
  int page = 1;
  int total_items = 0;

  Future<void> loadList({
    String? sort,
    int? limit,
    int? size,
    String? keyword,
    String? genres,
    String? conditions,
    int? minPrice,
    int? maxPrice,
    String? tradeMethod,
    String? barcode,
    bool reset = true,
  }) async {
    if (isListLoading && !reset) return;
    if (reset) {
      page = 1;
      hasNext = true;
      productList = [];
    }
    if (!hasNext) return;
    isListLoading = true;

    try {
      final url = Uri.parse("http://$baseUrl/products").replace(
        queryParameters: {
          if (sort != null) 'sort': sort,
          if (limit != null) 'limit': "$limit",
          if (keyword != null) 'keyword': keyword,
          if (genres != null) 'genres': genres,
          if (conditions != null) 'conditions': conditions,
          if (minPrice != null) 'minPrice': '$minPrice',
          if (maxPrice != null) 'maxPrice': '$maxPrice',
          if (tradeMethod != null) 'tradeMethod': tradeMethod,
          if (barcode != null) 'barcode': barcode,
          if (size != null) 'page': '$page',
          if (size != null) 'size': "$size",
        },
      );

      final res = await http.get(url, headers: header);

      // print(res.statusCode);
      // print(url);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (data['data'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        productList.addAll(list);

        final pagination = data['pagination'];
        if (pagination != null) {
          hasNext = pagination['hasNext'];
          total_items = pagination['totalCount'];
          page++;
        } else {
          hasNext = false;
        }
      }
    } catch (e) {
      print('$e');
    }

    isListLoading = false;
  }

  Future<void> loadDetail(int product_id) async {
    isDetailLoading = true;

    try {
      final url = Uri.parse(
        "http://$baseUrl/products/$product_id?userId=$userId",
      );
      final res = await http.get(url, headers: header);

      // print(res.statusCode);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        detailModel = ProductDetailModel.fromJson(data['data']);
      }
    } catch (e) {
      print("$e");
    }

    isDetailLoading = false;
  }

  Future<String?> uploadImage(String image) async {
    try {
      final url = Uri.parse("http://$baseUrl/upload/image?userId=$userId");
      final res = await http.post(
        url,
        headers: header,
        body: jsonEncode({"image": image, "type": "ALBUM"}),
      );

      // print(res.statusCode);
      // print(url);
      // print(res.body);

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return data['data']['imageUrl'];
      }
    } catch (e) {
      print('$e');
      return null;
    }
  }

  Future<bool> add({
    required String? albumName,
    required String? artist,
    required String? genre,
    required String? condition,
    required int? price,
    required String? tradeMethod,
    required String? albumImage,
    String? barcode,
    String? description,
  }) async {
    try {
      final url = Uri.parse("http://$baseUrl/products?userId=$userId");
      final res = await http.post(
        url,
        headers: header,
        body: jsonEncode({
          "albumName": albumName,
          "artist": artist,
          "genre": genre,
          "condition": condition,
          "price": price,
          "tradeMethod": tradeMethod,
          "barcode": barcode,
          "description": description,
          "albumImage": albumImage,
        }),
      );

      // print(res.statusCode);
      // print(url);
      // print(res.body);

      if (res.statusCode == 201) {
        showMessage("상품이 등록되었습니다.");
        return true;
      }else{
        final data = jsonDecode(res.body);
        final error = (data['errors'] as List).first['message'];
        showMessage(error!);
      }
      return false;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Future<bool> remove(int id) async {
    try {
      final url = Uri.parse("http://$baseUrl/products/$id?userId=$userId");
      final res = await http.delete(url, headers: header);

      // print(res.statusCode);
      // print(url);
      // print(res.body);

      if (res.statusCode == 200) {
        showMessage("상품이 삭제되었습니다");
        return true;
      }
      return false;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Future<void> myLoadList() async {
    isMyListLoading = true;
    myProductList.clear();
    try {
      final url = Uri.parse("http://$baseUrl/products/me?userId=$userId");

      final res = await http.get(url, headers: header);

      // print(res.statusCode);
      // print(url);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (data['data'] as List)
            .map((e) => MyProductModel.fromJson(e))
            .toList();
        myProductList.addAll(list);
      }
    } catch (e) {
      print('$e');
    }

    isMyListLoading = false;
  }
}
