import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test5/model/product_model.dart';
import 'package:vinyl_groove_test5/utils/info.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';

class ProductController {
  bool isListLoading = false;
  bool isMyListLoading = false;
  bool isDetailLoading = false;
  List<ProductModel> productList = [];
  List<MyProductModel> my_productList = [];
  DetailProductModel? detailModel;
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

      final res = await http.get(url, headers: headers);

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

  Future<void> loadDetail(int _id) async {
    isDetailLoading = true;

    try {
      final url = Uri.parse(
        "http://$baseUrl/products/$_id?userId=$userId",
      );
      final res = await http.get(url, headers: headers);

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        detailModel = DetailProductModel.fromJson(data['data']);
      }
    } catch (e) {
      print("$e");
    }

    isDetailLoading = false;
  }

  Future<void> loadMyList() async {
    isMyListLoading = true;

    try {
      final url = Uri.parse("http://$baseUrl/products/me?userId=$userId");

      final res = await http.get(url, headers: headers);

      // print(res.statusCode);
      // print(url);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        my_productList.clear();
        final list = (data['data'] as List)
            .map((e) => MyProductModel.fromJson(e))
            .toList();
        my_productList.addAll(list);
      }
    } catch (e) {
      print('$e');
    }

    isMyListLoading = false;
  }

  Future<bool> remove(int id) async {
    try {
      final url = Uri.parse("http://$baseUrl/products/$id?userId=$userId");

      final res = await http.delete(url, headers: headers);

      // print(res.statusCode);
      // print(url);
      // print(res.body);

      final data = jsonDecode(res.body);
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

  Future<bool> add({
    required String albumImage,
    required String albumName,
    required String artist,
    required String genre,
    required String condition,
    required int price,
    required String tradeMethod,
    String? barcode,
    String? description,
  }) async {
    try {
      final url = Uri.parse("http://$baseUrl/products?userId=$userId");

      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "albumImage": albumImage,
          "albumName": albumName,
          "artist": artist,
          "genre": genre,
          "condition": condition,
          "price": price,
          "tradeMethod": tradeMethod,
          "barcode": barcode,
          "description": description,
        }),
      );

      // print(res.statusCode);
      // print(url);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 201) {
        showMessage('상품이 등록되었습니다.');
        return true;
      } else {
        final error = (data['errors'] as List).first['message'];
        showMessage(error!);
        return false;
      }
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Future<String?> upload_image(String image) async {
    try {
      final url = Uri.parse("http://$baseUrl/upload/image?userId=$userId");

      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode({"image": image, "type": "ALBUM"}),
      );

      // print(res.statusCode);
      // print(url);
      // print(res.body);
      //
      final data = jsonDecode(res.body);
      if (res.statusCode == 201) {
        return data['data']['imageUrl'];
      }
    } catch (e) {
      print('$e');
    }
  }
}
