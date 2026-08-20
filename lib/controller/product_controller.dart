import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test6/model/product_model.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';

import '../uitls/utils.dart';

class ProductController {
  bool isListLoading = false;
  bool isMyListLoading = false;
  bool isDetailLoading = false;
  List<ProductModel> productList = [];
  List<My_ProductModel> myProductList = [];

  detail_ProductModel? detailModel;
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
        "http://$baseUrl/products/$_id?userId=$id",
      );
      final res = await http.get(url, headers: headers);

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        detailModel = detail_ProductModel.fromJson(data['data']);
      }
    } catch (e) {
      print("$e");
    }

    isDetailLoading = false;
  }

  Future<void> load_myList() async {
    isMyListLoading = true;

    try {
      final url = Uri.parse("http://$baseUrl/products/me?userId=$id");

      final res = await http.get(url, headers: headers);

      // print(res.statusCode);
      // print(url);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        myProductList.clear();
        final list = (data['data'] as List)
            .map((e) => My_ProductModel.fromJson(e))
            .toList();
        myProductList.addAll(list);
      }
    } catch (e) {
      print('$e');
    }

    isMyListLoading = false;
  }

  Future<bool> add({
    required String albumName,
    required String artist,
    required String genre,
    required String condition,
    required int price,
    required String tradeMethod,
    String? barcode,
    String? description,
    required String albumImage,
  }) async {
    try {
      final url = Uri.parse(
        "http://$baseUrl/products?userId=$id",
      );
      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'albumName': albumName,
          'artist': artist,
          'genre': genre,
          'condition': condition,
          'price': price,
          'tradeMethod': tradeMethod,
          'barcode': barcode,
          'description': description,
          'albumImage': albumImage,
        }),
      );

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 201) {
        showMessage(text: '상품이 등록되었습니다.');
        return true;
      } else {
        final error = (data['errors'] as List).toList().first['message'];
        showMessage(text: error!);
        return false;
      }
    } catch (e) {
      print("$e");
      return false;
    }
  }

  Future<bool> delete(int idd) async {
    try {
      final url = Uri.parse("http://$baseUrl/products/$idd?userId=$id");
      final res = await http.delete(url, headers: headers);

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        showMessage(text: '상품이 삭제되었습니다');
        return true;
      } else {
        final error = (data['errors'] as List).toList().first['message'];
        showMessage(text: error!);
        return false;
      }
    } catch (e) {
      print("$e");
      return false;
    }
  }

  Future<String?> iamge_add(String image) async {
    try {
      final url = Uri.parse(
        'http://$baseUrl/upload/image?userId=$id',
      );
      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "image": "data:image/png;base64,$image",
          "type": "ALBUM",
        }),
      );

      // print(url);
      // print(res.statusCode);
      // print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 201) {
        showMessage(text: '이미지가 등록되었습니다.');

        return data['data']['imageUrl'];
      } else {
        final error = (data['errors'] as List).toList().first['message'];
        showMessage(text: error!);
      }
    } catch (e) {
      print("$e");
    }
  }
}
