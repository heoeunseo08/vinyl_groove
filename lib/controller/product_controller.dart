import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove2/model/product_model.dart';
import 'package:vinyl_groove2/urils/info.dart';

class ProductController {
  bool isListLoading = false;
  bool isDetailLoading = false;

  List<ProductModel> model_list = [];
  ProductDetailModel? detailModel;

  bool hasNext = true;
  int page = 1;
  int totalCount = 0;

  String? error;

  Future<void> listLoad({
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
    isListLoading = true;

    if (reset) {
      page = 1;
      model_list.clear();
    }

    try {
      final url = Uri.parse("http://$baseUrl/products").replace(
        queryParameters: {
          if (sort != null) "sort": sort,
          if (limit != null) "limit": "$limit",
          if (keyword != null) "keyword": keyword,
          if (genres != null) "genres": "$genres",
          if (conditions != null) "conditions": "$conditions",
          if (minPrice != null) "minPrice": "$minPrice",
          if (maxPrice != null) "maxPrice": "$maxPrice",
          if (tradeMethod != null) "tradeMethod": tradeMethod,
          if (limit == null) 'page': "$page",
          if (limit != null) 'size': "$limit",
          "userId":"$userId"
        },
      );
      final res = await http.get(url, headers: header);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        model_list.addAll(
          (data['data'] as List).map((e) => ProductModel.fromJson(e)).toList(),
        );

        final pagination = data['pagination'];
        if (pagination != null) {
          totalCount = pagination['totalCount'];
          hasNext = pagination['hasNext'];
          page++;
        }
      }
    } catch (e) {
      print("$e");
    }

    isListLoading = false;
  }

  Future<void> detailLoad({required dynamic id}) async {
    isDetailLoading = true;

    try {
      final url = Uri.parse("http://$baseUrl/products/$id?userId=$userId");
      final res = await http.get(url, headers: header);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        detailModel = ProductDetailModel.fromJson(data['data']);
      }
    } catch (e) {
      print("$e");
    }

    isDetailLoading = false;
  }
}
