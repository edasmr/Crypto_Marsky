class Crypto {
  final String uuid;
  final String name;
  final String symbol;
  final String iconUrl;
  final double price;
  final double change;
  final int rank;

  Crypto({
    required this.uuid,
    required this.name,
    required this.symbol,
    required this.iconUrl,
    required this.price,
    required this.change,
    required this.rank,
  });
}
