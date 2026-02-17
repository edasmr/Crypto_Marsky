import 'package:crypto_marsky/features/price_chart.dart';
import 'package:flutter/material.dart';
import '../crypto/entity/crypto_entity.dart';

class DetailBottomSheet extends StatelessWidget {
  final Crypto crypto;

  const DetailBottomSheet({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Image.network(
                    crypto.iconUrl,
                    width: 60,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.monetization_on),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crypto.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${crypto.symbol} • Rank ${crypto.rank}'),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _infoRow('Price', '\$${crypto.price.toStringAsFixed(2)}'),
              _infoRow(
                'Change',
                '${crypto.change.toStringAsFixed(2)}%',
                valueColor: crypto.change >= 0 ? Colors.green : Colors.red,
              ),

              const SizedBox(height: 24),
              const Text(
                'Price History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(height: 200, child: PriceChart(cryptoUuid: crypto.uuid)),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }
}
