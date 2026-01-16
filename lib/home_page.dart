import 'dart:convert';
import 'package:customerbook/maps_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../widgets/floating_bottom_bar.dart';
import 'buku_page.dart';
import 'keranjang_page.dart';
import 'jadwal_page.dart';
import 'profile_page.dart';
import 'about_page.dart';
import 'login_page.dart';

// ================= SALDO GLOBAL =================
final ValueNotifier<int> saldoNotifier = ValueNotifier<int>(1000000);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // ================= WEATHER STATE =================
  bool isLoadingWeather = true;
  double? temperature;
  double? windSpeed;
  int? weatherCode;

  Future<void> fetchWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast'
          '?latitude=-6.9175'
          '&longitude=107.6191'
          '&current_weather=true',
        ),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final current = data['current_weather'];

        setState(() {
          temperature = current['temperature']?.toDouble();
          windSpeed = current['windspeed']?.toDouble();
          weatherCode = current['weathercode'];
          isLoadingWeather = false;
        });
      }
    } catch (e) {
      setState(() => isLoadingWeather = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void _handleBottomTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        // go to Home (clear stack and show Home)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => const HomePage()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const BukuPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const KeranjangPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const JadwalPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const ProfilePage()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const AboutPage()),
        );
        break;
      default:
        break;
    }
  }

  // ================= FORMAT RUPIAH (UNTUK SALDO) =================
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // polka background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/polka.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.85),
                    BlendMode.modulate,
                  ),
                ),
              ),
              child: Container(
                // gentle overlay gradient to enforce pastel pink + green theme
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0x55FFF0F6), Color(0x55E6F9F0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // ================= CONTENT =================
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                width * 0.04,
                width * 0.04,
                width * 0.04,
                height * 0.16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER =================
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.012,
                            horizontal: width * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.78),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, amara',
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E6A58),
                                ),
                              ),
                              SizedBox(height: height * 0.006),
                              Text(
                                'Welcome back',
                                style: TextStyle(
                                  fontSize: width * 0.036,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      // clickable star with logout menu
                      PopupMenuButton<int>(
                        onSelected: (v) {
                          if (v == 1) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Text('Logout'),
                          ),
                        ],
                        child: Container(
                          padding: EdgeInsets.all(width * 0.03),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0F6),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.star,
                            color: const Color(0xFFFF9BC1),
                            size: width * 0.06,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.025),

                  // ================= SEARCH =================
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6FA), // very light pink
                      borderRadius: BorderRadius.circular(width * 0.04),
                      border: Border.all(color: const Color(0xFFFFDDE8)),
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: width * 0.04),
                      decoration: const InputDecoration(
                        hintText: 'Cari buku...',
                        icon: Icon(Icons.search, color: Color(0xFF71C6B7)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  // ================= SALDO (redesigned pastel card) =================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8FD3C7), // single pastel green
                      borderRadius: BorderRadius.circular(width * 0.05),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // left: texts and actions
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saldo Member',
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  color: const Color(0xFF3A6B5C),
                                ),
                              ),
                              SizedBox(height: height * 0.008),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ValueListenableBuilder<int>(
                                    valueListenable: saldoNotifier,
                                    builder: (context, saldo, _) {
                                      return Text(
                                        _formatRupiah(saldo),
                                        style: TextStyle(
                                          fontSize: width * 0.065,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF224E42),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Member',
                                      style: TextStyle(
                                        fontSize: width * 0.028,
                                        color: const Color.fromARGB(
                                          255,
                                          241,
                                          157,
                                          157,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.012),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.add, size: 14),
                                    label: const Text('Top Up'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF2F6B58),
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.04,
                                        vertical: height * 0.01,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // right: show card image directly (no white card, no shadow), larger and clipped circular
                        Container(
                          width: width * 0.22,
                          height: width * 0.22,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/card.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                    child: Icon(
                                      Icons.credit_card,
                                      color: const Color(0xFF71C6B7),
                                      size: width * 0.09,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.035),

                  // ================= WEATHER CARD =================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEF4),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: isLoadingWeather
                        ? Row(
                            children: const [
                              CircularProgressIndicator(strokeWidth: 2),
                              SizedBox(width: 12),
                              Text('Mengambil data cuaca...'),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.cloud, color: Color(0xFF71C6B7)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Cuaca Hari Ini',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E6A58),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Bandung',
                                style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF3A6B5C),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                temperature != null
                                    ? '${temperature!.toStringAsFixed(1)}°C'
                                    : '-',
                                style: TextStyle(
                                  fontSize: width * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF224E42),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                windSpeed != null
                                    ? 'Kecepatan angin: ${windSpeed!.toStringAsFixed(1)} km/h'
                                    : '',
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: height * 0.035),

                  // ================= QUICK MENU (IMAGE) =================
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth / 4.5;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _QuickMenuImage(
                            imagePath: 'assets/buku.png',
                            size: itemWidth,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const BukuPage(),
                                ),
                              );
                            },
                          ),
                          _QuickMenuImage(
                            imagePath: 'assets/keranjang.png',
                            size: itemWidth,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const KeranjangPage(),
                                ),
                              );
                            },
                          ),
                          _QuickMenuImage(
                            imagePath: 'assets/jadwal.png',
                            size: itemWidth,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const MapsPage(),
                                ),
                              );
                            },
                          ),
                          _QuickMenuImage(
                            imagePath: 'assets/logo.png',
                            size: itemWidth,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const ProfilePage(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: height * 0.02),

                  // ================= BUKU =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Buku Terbaru',
                        style: TextStyle(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3A6B5C),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const BukuPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF3A6B5C),
                        ),
                        child: Text(
                          'View All',
                          style: TextStyle(fontSize: width * 0.035),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.02),

                  SizedBox(
                    height: height * 0.28,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _BookCard(title: 'Hello Cello'),
                        _BookCard(title: 'Hilmi Milan'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= FLOATING BOTTOM BAR =================
          FloatingBottomBar(
            currentIndex: _currentIndex,
            onTap: _handleBottomTap,
          ),
        ],
      ),
    );
  }
}

// ================= Helper widgets =================

class _QuickMenuImage extends StatelessWidget {
  final String imagePath;
  final double size;
  final VoidCallback? onTap;

  const _QuickMenuImage({
    required this.imagePath,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 252, 234, 241),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 252, 234, 241),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.16),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: const Color(0xFF3A6B5C),
                  size: size * 0.45,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final String title;

  const _BookCard({required this.title});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // mapping judul buku ke gambar
    final Map<String, String> bookImages = {
      'Hello Cello': 'assets/helcel.jpg',
      'Hilmi Milan': 'assets/hilmil.jpg',
    };

    return Container(
      width: width * 0.45,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar buku
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                bookImages[title]!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.book, size: 48, color: Colors.grey),
                ),
              ),
            ),
          ),
          // Judul buku
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
