import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'buku_page.dart';
import 'jadwal_page.dart';
import 'profile_page.dart';
import 'about_page.dart';
import 'riwayat_transaksi_page.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import '../widgets/floating_bottom_bar.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  int _currentIndex = 2; // index for bottom bar

  String _formatRupiah(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return 'Rp ' + buffer.toString().split('').reversed.join();
  }

  void _handleBottomTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BukuPage()),
        );
        break;
      case 2:
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JadwalPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutPage()),
        );
        break;
    }
  }

  Future<void> _postTransactionToServer() async {
    final items = CartService.instance.items;

    final List<Map<String, dynamic>> itemData = items.map((it) {
      return {
        'kode_buku': it.id, // asumsi id = kode_buku
        'jumlah': it.quantity,
      };
    }).toList();

    final payload = {'items': itemData};

    try {
      final url = Uri.parse(
        'https://k7193c3v-80.asse.devtunnels.ms/server/public/index.php/orders',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Order berhasil dikirim');
        print(response.body);

        // Tampilkan success dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('✅ Pembelian Berhasil!'),
              content: const Text(
                'Transaksi Anda telah berhasil disimpan. Silakan cek riwayat transaksi untuk melihat pembelian terbaru.',
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    // Bersihkan keranjang
                    CartService.instance.clear();
                    setState(() {});

                    // Tunggu sebentar agar data tersimpan
                    await Future.delayed(const Duration(seconds: 1));

                    // Import RiwayatTransaksiPage di atas file
                    // Navigasi ke riwayat transaksi
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RiwayatTransaksiPage(),
                      ),
                    );
                  },
                  child: const Text('Lihat Riwayat'),
                ),
              ],
            ),
          );
        }
      } else {
        print('Gagal mengirim order: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error saat mengirim order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2E6A58),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/polka.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.9),
                    BlendMode.modulate,
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0x33FFF0F6), Color(0x33E6F9F0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: CartService.instance,
            builder: (context, _) {
              final items = CartService.instance.items;

              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/cart.png',
                        width: 140,
                        height: 140,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.shopping_cart, size: 80),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Keranjang kosong',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text('Tambahkan buku dari halaman Buku'),
                    ],
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.only(bottom: 160),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final CartItem it = items[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF6FA).withOpacity(0.98),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    it.imagePath,
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.book, size: 48),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        it.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        it.author,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _formatRupiah(it.price),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2E6A58),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => CartService.instance
                                              .decrement(it.id),
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),
                                        Text(
                                          '${it.quantity}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => CartService.instance
                                              .increment(it.id),
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _formatRupiah(it.quantity * it.price),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => CartService.instance
                                          .removeItem(it.id),
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF6FA).withOpacity(0.98),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah buku',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${CartService.instance.totalItems} items',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total Harga',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatRupiah(CartService.instance.totalPrice),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF2E6A58),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          final total = CartService.instance.totalPrice;

                          if (total == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Keranjang masih kosong'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          if (saldoNotifier.value < total) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Saldo tidak mencukupi'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // ================= SALDO & CLEAR CART =================
                          saldoNotifier.value -= total;
                          CartService.instance.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pesanan berhasil 🎉'),
                              backgroundColor: Color(0xFF2E6A58),
                            ),
                          );

                          // ================= POST TRANSAKSI =================
                          _postTransactionToServer();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8FD3C7),
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 140),
                  ],
                ),
              );
            },
          ),
          FloatingBottomBar(
            currentIndex: _currentIndex,
            onTap: _handleBottomTap,
          ),
        ],
      ),
    );
  }
}
