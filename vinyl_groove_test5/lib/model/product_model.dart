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

class DetailProductModel {
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
  final SellerModel seller;
  final int likeCount;
  final String createdAt;

  DetailProductModel({
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

  factory DetailProductModel.fromJson(Map<String, dynamic> json) =>
      DetailProductModel(
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
        seller: SellerModel.fromJson(json['seller']),
        likeCount: json['likeCount'],
        createdAt: json['createdAt'],
      );
}

class SellerModel {
  final int id;
  final String name;
  final String email;
  final String? profileImage;

  SellerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) => SellerModel(
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
