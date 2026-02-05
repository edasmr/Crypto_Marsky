import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/network/dio_client.dart';

class PriceChart extends StatefulWidget {
  final String cryptoUuid;
  const PriceChart({super.key, required this.cryptoUuid});

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final dio = DioClient().dio;

      final response = await dio.get(
        '/coin/${widget.cryptoUuid}/history',
        queryParameters: {'timePeriod': '24h'},
      );

      final List history = response.data['data']['history'];

      final List<FlSpot> temp = [];

      for (int i = 0; i < history.length; i++) {
        final priceStr = history[i]['price'];
        final price = double.tryParse(priceStr ?? '');
        if (price != null) {
          temp.add(FlSpot(i.toDouble(), price));
        }
      }

      if (mounted) {
        setState(() => spots = temp);
      }
    } catch (e) {
      debugPrint('Chart error FULL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            dotData: FlDotData(show: false),
            color: Colors.blue,
            barWidth: 3,
          ),
        ],
      ),
    );
  }
}
