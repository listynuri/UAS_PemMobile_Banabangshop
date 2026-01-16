import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_page.dart';
import 'keranjang_page.dart';
import 'jadwal_page.dart';
import 'profile_page.dart';
import 'about_page.dart';
import '../widgets/floating_bottom_bar.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

/// ================= API CONFIG =================

// API host selection via --dart-define
const String _apiPort = String.fromEnvironment('API_PORT', defaultValue: '80');

const String _apiScheme = String.fromEnvironment(
  'API_SCHEME',
  defaultValue: 'https',
);

const String _apiBasePath = String.fromEnvironment(
  'API_BASE_PATH',
  defaultValue: '/server/public/index.php',
);

// Base URL FIX ke server baru (hanya sampai index.php)
String _buildBaseUrl() {
  return "https://k7193c3v-80.asse.devtunnels.ms/server/public/index.php";
}

// Fallback URL (opsional)
String? _buildFallbackBaseUrl() {
  const String fallbackHost = String.fromEnvironment(
    'API_FALLBACK_HOST',
    defaultValue: '',
  );
  if (fallbackHost.isEmpty) return null;
  return "$_apiScheme://$fallbackHost:$_apiPort$_apiBasePath";
}

/// ================= PAGE =================

class BukuPage extends StatefulWidget {
  const BukuPage({super.key});

  @override
  State<BukuPage> createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<Map<String, String>> _allBooks = [];
  List<Map<String, String>> _filtered = [];

  bool _loading = true;
  String? _error;

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
    _fetchBooks();
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    super.dispose();
  }

  // ================= FETCH BOOKS =================
  Future<void> _fetchBooks() async {
    try {
      final url = Uri.parse("${_buildBaseUrl()}/books"); // endpoint buku
      print("Fetching from: $url");

      final res = await http.get(url);

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.body}");

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);

        // Support response: List langsung ATAU { data: [...] }
        final List list = decoded is List ? decoded : decoded['data'] ?? [];

        _allBooks = list.map<Map<String, String>>((e) {
          final harga = e['harga'] ?? 0;

          return {
            'title': e['judul']?.toString() ?? '',
            'author': e['penulis']?.toString() ?? '',
            'price': 'Rp $harga',
            'image': e['image']?.toString() ?? 'assets/logo.png', // fallback
          };
        }).toList();

        _filtered = List.from(_allBooks);
        _loading = false;
        setState(() {});
      } else {
        _error = 'HTTP ${res.statusCode}';
        _loading = false;
        setState(() {});
      }
    } catch (e) {
      _error = e.toString();
      _loading = false;
      setState(() {});
    }
  }

  // ================= SEARCH =================
  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List.from(_allBooks)
          : _allBooks
                .where(
                  (b) =>
                      b['title']!.toLowerCase().contains(q) ||
                      b['author']!.toLowerCase().contains(q),
                )
                .toList();
    });
  }

  // ================= BOTTOM BAR =================
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
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KeranjangPage()),
        );
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

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    int crossAxisCount;
    if (width >= 900) {
      crossAxisCount = 4;
    } else if (width >= 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Buku'),
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0x33FFF0F6), Color(0x33E6F9F0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6FA).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                      border: Border.all(color: const Color(0xFFFFE4EC)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF71C6B7)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Cari buku...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_searchCtrl.text.isNotEmpty)
                          GestureDetector(
                            onTap: () => _searchCtrl.clear(),
                            child: const Icon(Icons.clear, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : _error != null
                        ? Center(child: Text(_error!))
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: height * 0.18),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.68,
                                ),
                            itemCount: _filtered.length,
                            itemBuilder: (context, index) {
                              final book = _filtered[index];
                              return _BookTile(
                                title: book['title']!,
                                author: book['author']!,
                                price: book['price']!,
                                imagePath: book['image']!,
                                onAdd: () {
                                  final digits = book['price']!.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  );
                                  final intPrice = int.tryParse(digits) ?? 0;

                                  CartService.instance.addItem(
                                    CartItem(
                                      id: book['title']!,
                                      title: book['title']!,
                                      author: book['author']!,
                                      price: intPrice,
                                      imagePath: book['image']!,
                                      quantity: 1,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${book['title']} ditambahkan ke keranjang',
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
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

/// ================= BOOK TILE =================

class _BookTile extends StatelessWidget {
  final String title;
  final String author;
  final String price;
  final String imagePath;
  final VoidCallback? onAdd;

  const _BookTile({
    required this.title,
    required this.author,
    required this.price,
    required this.imagePath,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF6F6F6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.book, size: 50, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF8FD3C7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: width * 0.036,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: TextStyle(fontSize: width * 0.03, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: width * 0.036,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E6A58),
                      ),
                    ),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9BC1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
