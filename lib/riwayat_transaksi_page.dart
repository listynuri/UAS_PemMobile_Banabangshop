import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  List<dynamic> transactions = [];
  Map<int, double> monthlyData = {};
  bool isLoading = true;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    // Auto refresh setiap 5 detik
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        _fetchTransactions();
      }
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchTransactions() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://k7193c3v-80.asse.devtunnels.ms/server/public/index.php/orders',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data');

        List<dynamic> orders = [];

        // Handle berbagai format respons
        if (data is List) {
          orders = data;
        } else if (data is Map) {
          if (data['data'] != null && data['data'] is List) {
            orders = data['data'];
          } else if (data['orders'] != null && data['orders'] is List) {
            orders = data['orders'];
          }
        }

        // Proses data untuk chart per bulan
        Map<int, double> tempMonthly = {};
        for (int i = 0; i < 12; i++) {
          tempMonthly[i] = 0;
        }

        print('Total orders: ${orders.length}');

        for (var order in orders) {
          try {
            // Coba berbagai format date
            String dateStr =
                order['order_date'] ??
                order['created_at'] ??
                order['date'] ??
                DateTime.now().toIso8601String();

            if (dateStr.isEmpty) dateStr = DateTime.now().toIso8601String();

            DateTime date = DateTime.parse(dateStr);
            int month = date.month - 1; // 0-indexed

            // Ambil total harga (coba berbagai key)
            double price = 0;
            if (order['total_price'] != null) {
              price = double.parse(order['total_price'].toString());
            } else if (order['total'] != null) {
              price = double.parse(order['total'].toString());
            } else if (order['amount'] != null) {
              price = double.parse(order['amount'].toString());
            } else if (order['price'] != null) {
              price = double.parse(order['price'].toString());
            }

            print('Order: ${order['book_title']} - $price - $month');

            tempMonthly[month] = (tempMonthly[month] ?? 0) + price;
          } catch (e) {
            print('Error processing order: $e');
          }
        }

        setState(() {
          transactions = orders;
          monthlyData = tempMonthly;
          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Fetch error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<FlSpot> _generateChartSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < 12; i++) {
      spots.add(FlSpot(i.toDouble(), monthlyData[i] ?? 0));
    }
    return spots;
  }

  double _getMaxY() {
    double max = monthlyData.values.isEmpty
        ? 500000
        : monthlyData.values.reduce((a, b) => a > b ? a : b);
    return max > 0 ? (max * 1.2).ceilToDouble() : 500000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2E7D6B),
      ),
      body: Stack(
        children: [
          // background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/polka.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // content dengan pull-to-refresh
          RefreshIndicator(
            onRefresh: () async {
              await _fetchTransactions();
            },
            color: const Color(0xFF71C6B7),
            backgroundColor: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // CHART CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistik Pembelian Buku',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D6B),
                        ),
                      ),
                      Text(
                        'Pembelian per bulan dalam Rp',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 280,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 100000,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey[300],
                                  strokeWidth: 1,
                                  dashArray: [5, 5],
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    const months = [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Aug',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dec',
                                    ];
                                    return Text(
                                      months[value.toInt() % 12],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 11,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 100000,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${(value / 100000).toStringAsFixed(0)}K',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _generateChartSpots(),
                                isCurved: true,
                                color: const Color(0xFF71C6B7),
                                barWidth: 3,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 4,
                                          color: const Color(0xFF71C6B7),
                                          strokeWidth: 2,
                                          strokeColor: Colors.white,
                                        );
                                      },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: const Color(
                                    0xFF71C6B7,
                                  ).withOpacity(0.15),
                                ),
                              ),
                            ],
                            minX: 0,
                            maxX: 11,
                            minY: 0,
                            maxY: _getMaxY(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // RIWAYAT TITLE
                const Text(
                  'Riwayat Transaksi Terbaru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D6B),
                  ),
                ),

                const SizedBox(height: 12),

                ...(transactions.isEmpty
                    ? [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                            'Belum ada transaksi',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ]
                    : transactions.map((order) {
                        String title = order['book_title'] ?? 'Buku';
                        String date = order['order_date'] ?? '';
                        double price = double.parse(
                          order['total_price'].toString(),
                        );

                        // Format tanggal
                        try {
                          DateTime dt = DateTime.parse(date);
                          date =
                              '${dt.day} ${_getMonthName(dt.month)} ${dt.year}';
                        } catch (e) {
                          // keep original format
                        }

                        return _item(
                          title: title,
                          date: date,
                          price: 'Rp ${price.toStringAsFixed(0)}',
                        );
                      }).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }
}

Widget _item({
  required String title,
  required String date,
  required String price,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.receipt_long, color: Color(0xFF2E7D6B)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D6B),
          ),
        ),
      ],
    ),
  );
}
