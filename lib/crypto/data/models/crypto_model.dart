import '../../entity/crypto_entity.dart';

class CryptoModel extends Crypto {
  CryptoModel({
    required super.uuid,
    required super.name,
    required super.symbol,
    required super.iconUrl,
    required super.price,
    required super.change,
    required super.rank,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      uuid: json['uuid'],
      name: json['name'],
      symbol: json['symbol'],
      iconUrl: json['iconUrl'],
      price: double.parse(json['price']),
      change: double.parse(json['change']),
      rank: json['rank'],
    );
  }
}
