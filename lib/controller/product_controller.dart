import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove/model/product_model.dart';
import 'package:vinyl_groove/utils/info.dart';

class ProductController {
  bool isListLoading = false;
  bool isDetailLoading = false;
  List<ProductModel> productList = [];
  ProductDetailModel? detailModel;
  bool hasNext = true;
  int page = 1;
  int total_items = 0;

  Future<void> loadList({
    String? sort,
    int? limit,
    String? keyword,
    List<String>? genres,
    List<String>? conditions,
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
          if (genres != null) 'genres': genres.join(','),
          if (conditions != null) 'conditions': conditions.join(','),
          if (minPrice != null) 'minPrice': '$minPrice',
          if (maxPrice != null) 'maxPrice': '$maxPrice',
          if (tradeMethod != null) 'tradeMethod': tradeMethod,
          if (barcode != null) 'barcode': barcode,
          if (limit == null) 'page': '$page',
          if (limit != null) 'size': "$limit",
        },
      );

      final res = await http.get(url, headers: header);

      print(res.statusCode);
      print(url);
      print(res.body);

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
        "http://$baseUrl/products/$product_id?userId=$user_id",
      );
      final res = await http.get(url, headers: header);

      print(url);
      print(res.statusCode);
      print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        detailModel = ProductDetailModel.fromJson(data['data']);
      }
    } catch (e) {
      print("$e");
    }

    isDetailLoading = false;
  }
}
