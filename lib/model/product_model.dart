class ProductModel {
  final int id;
  final String albumName;
  final String artist;
  final String genre;
  final String condition;
  final int price;
  final String tradeMethod;
  final String albumImage;
  final int likeCount;
  final String createdAt;

  ProductModel({
    required this.id,
    required this.albumName,
    required this.artist,
    required this.genre,
    required this.condition,
    required this.price,
    required this.tradeMethod,
    required this.albumImage,
    required this.likeCount,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    albumName: json['albumName'],
    artist: json['artist'],
    genre: json['genre'],
    condition: json['condition'],
    price: json['price'],
    tradeMethod: json['tradeMethod'],
    albumImage: json['albumImage'],
    likeCount: json['likeCount'],
    createdAt: json['createdAt'],
  );
}

class ProductDetailModel {
  final int id;
  final String albumName;
  final String artist;
  final String genre;
  final String condition;
  final String conditionDescription;
  final int price;
  final String tradeMethod;
  final String barcode;
  final String description;
  final String albumImage;
  final seller_model seller;
  final int likeCount;
  final String createdAt;

  ProductDetailModel({
    required this.id,
    required this.albumName,
    required this.artist,
    required this.genre,
    required this.condition,
    required this.conditionDescription,
    required this.price,
    required this.tradeMethod,
    required this.barcode,
    required this.description,
    required this.albumImage,
    required this.seller,
    required this.likeCount,
    required this.createdAt,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        id: json['id'],
        albumName: json['albumName'],
        artist: json['artist'],
        genre: json['genre'],
        condition: json['condition'],
        conditionDescription: json['conditionDescription'],
        price: json['price'],
        tradeMethod: json['tradeMethod'],
        barcode: json['barcode'],
        description: json['description'],
        albumImage: json['albumImage'],
        seller: seller_model.fromJson(json['seller']),
        likeCount: json['likeCount'],
        createdAt: json['createdAt'],
      );
}

class seller_model {
  final int id;
  final String name;
  final String email;
  String? profileImage;

  seller_model({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

  factory seller_model.fromJson(Map<String, dynamic> json) => seller_model(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    profileImage: json['profileImage'],
  );
}

class MyProductModel {
  final int id;
  final String albumName;
  final String artist;
  final String genre;
  final String condition;
  final int price;
  final String tradeMethod;
  final String albumImage;
  final String createdAt;

  MyProductModel({
    required this.id,
    required this.albumName,
    required this.artist,
    required this.genre,
    required this.condition,
    required this.price,
    required this.tradeMethod,
    required this.albumImage,
    required this.createdAt,
  });

  factory MyProductModel.fromJson(Map<String, dynamic> json) => MyProductModel(
    id: json['id'],
    albumName: json['albumName'],
    artist: json['artist'],
    genre: json['genre'],
    condition: json['condition'],
    price: json['price'],
    tradeMethod: json['tradeMethod'],
    albumImage: json['albumImage'],
    createdAt: json['createdAt'],
  );
}
