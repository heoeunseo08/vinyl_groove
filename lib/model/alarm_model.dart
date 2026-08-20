class AlarmModel {
  final int id;
  final String type;
  final String title;
  final int productId;
  final String albumName;
  final String artist;
  final String albumImage;
  final int previousPrice;
  final int currentPrice;
  bool isRead;
  final String createdAt;

  AlarmModel({
    required this.id,
    required this.type,
    required this.title,
    required this.productId,
    required this.albumName,
    required this.artist,
    required this.albumImage,
    required this.previousPrice,
    required this.currentPrice,
    required this.isRead,
    required this.createdAt,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
    id: json['id'],
    type: json['type'],
    title: json['title'],
    productId: json['productId'],
    albumName: json['albumName'],
    artist: json['artist'],
    albumImage: json['albumImage'],
    previousPrice: json['previousPrice'],
    currentPrice: json['currentPrice'],
    isRead: json['isRead'],
    createdAt: json['createdAt'],
  );
}
