import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vinyl_groove_test7/model/product_model.dart';
import 'package:vinyl_groove_test7/utils/info.dart';
import 'package:vinyl_groove_test7/utils/utils.dart';

class ProductController {
  bool isLoading = false;
  bool isDetailLoading = false;

  List<ProductModel> product_list = [];
  DetailProductModel? detailProductModel;

  int totalCount = 0;
  bool hasNest = true;
  int page = 1;

  Future<void> load({
    bool reset = true,
    String? sort,
    int? size,
    int? limit,
    String? genre,
    String? condition,
    String? keyword,
    int? minPrice,
    int? maxPrice,
    String? tradeMethod,
    String? barcode,
  }) async {
    if (reset) {
      page = 1;
      hasNest = true;
      product_list = [];
    }
    isLoading = true;
    try {
      final url = Uri.parse("http://$baseUrl/products").replace(
        queryParameters: {
          if (sort != null)    'sort': sort,
          if (limit != null)  'limit': '$limit',
          if (genre != null)     'genre': genre,
          if (condition != null) 'condition': condition,
          if (keyword != null) 'keyword': keyword,
          if (minPrice != null) 'minPrice': '$minPrice',
          if (maxPrice != null) 'maxPrice': '$maxPrice',
          if (tradeMethod != null) 'tradeMethod': tradeMethod,
          if (barcode != null) 'barcode': barcode,
          if (size != null)       'size': '$size',
          if (size == null)      'page': '$page',
        },
      );
      final res = await http.get(url, headers: headers);

      print(url);
      print(res.statusCode);
      print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (data['data'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        product_list.addAll(list);

        final pagination = data['pagination'];
        if (pagination != null && limit == null) {
          print('asdf');
          hasNest = pagination['hasNest'] ??false;
          totalCount = pagination['totalCount'];
          page++;
        }
      }
    } catch (e) {
      print("$e");
      show_message(text: "$e");
    }
    isLoading = false;
  }

  Future<void> detail_load(int id) async {
    isDetailLoading = true;
    try {
      final url = Uri.parse("http://$baseUrl/products/1?userId=$userId");
      final res = await http.get(url, headers: headers);

      print(url);
      print(res.statusCode);
      print(res.body);

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        detailProductModel = DetailProductModel.fromJson(data['data']);
      }
    } catch (e) {
      show_message(text: "$e");
    }
    isDetailLoading = false;
  }
}
