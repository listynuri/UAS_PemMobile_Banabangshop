import 'package:flutter/material.dart';
import '../widgets/floating_bottom_bar.dart';
import 'home_page.dart';
import 'buku_page.dart';
import 'keranjang_page.dart';
import 'jadwal_page.dart';
import 'profile_page.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _currentIndex = 5;

  void _handleBottomTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BukuPage()),
        );
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
        // already on About
        break;
    }
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
          // ================= BACKGROUND POLKA =================
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/polka.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.85),
                    BlendMode.modulate,
                  ),
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
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
                width * 0.05,
                width * 0.05,
                width * 0.05,
                height * 0.16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= TEAM MEMBERS =================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          const Color(0xFFFFEEF4),
                          const Color(0xFFFFEEF4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
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
                          'Anggota Kelompok',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF71C6B7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _TeamMemberCard(
                              width: width,
                              name: 'Listy Nuri S',
                              nrp: '152022002',
                              icon: '',
                            ),
                            _TeamMemberCard(
                              width: width,
                              name: 'Aulia Nur A',
                              nrp: '152022046',
                              icon: '',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  // ================= HEADER =================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [const Color(0xFFFFEEF4), Color(0xFFFFE8F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
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
                          'About Banabangs',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF71C6B7),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aplikasi ini dirancang untuk membantu pemilik toko buku dalam mengelola data pelanggan, buku, dan transaksi penjualan dengan lebih efisien. Dengan antarmuka yang user-friendly dan fitur-fitur lengkap, Banabangs memudahkan proses administrasi toko buku Anda.',
                          style: TextStyle(
                            fontSize: width * 0.035,
                            color: const Color(0xFFB8537D),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  // ================= API 1 =================
                  _ApiCard(
                    icon: Icons.cloud,
                    title: 'API Cuaca (Open-Meteo)',
                    url:
                        'https://api.open-meteo.com/v1/forecast?latitude=-6.9175&longitude=107.6191&current_weather=true',
                    description:
                        'Digunakan untuk menampilkan suhu dan kecepatan angin secara real-time berdasarkan lokasi Bandung. API ini gratis dan tidak memerlukan API key.',
                  ),

                  SizedBox(height: height * 0.02),

                  // ================= API 2 =================
                  _ApiCard(
                    icon: Icons.map,
                    title: 'API Provinsi Indonesia',
                    url:
                        'https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json',
                    description:
                        'Menyediakan daftar provinsi di Indonesia yang digunakan untuk fitur pemilihan wilayah dalam aplikasi.',
                  ),

                  SizedBox(height: height * 0.02),

                  // ================= API 3 =================
                  _ApiCard(
                    icon: Icons.location_city,
                    title: 'API Kabupaten / Kota',
                    url:
                        'https://www.emsifa.com/api-wilayah-indonesia/api/regencies/{provinceId}.json',
                    description:
                        'Digunakan untuk menampilkan daftar kabupaten atau kota berdasarkan ID provinsi yang dipilih oleh pengguna.',
                  ),
                  SizedBox(height: height * 0.02),

                  // ================= API 4 =================
                  _ApiCard(
                    icon: Icons.location_on,
                    title: 'API Buku',
                    url:
                        'https://k7193c3v-80.asse.devtunnels.ms/server/public/index.php',
                    description:
                        'Digunakan untuk menampilkan data buku dari server.',
                  ),
                  SizedBox(height: height * 0.02),

                  // ================= API 5 =================
                  _ApiCard(
                    icon: Icons.location_on,
                    title: 'API Transaksi',
                    url:
                        'https://k7193c3v-80.asse.devtunnels.ms/server/public/index.php/orders',
                    description:
                        'Digunakan untuk memPOST transaksi yang akan masuk ke admin.',
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

// ================= TEAM MEMBER CARD =================

class _TeamMemberCard extends StatelessWidget {
  final double width;
  final String name;
  final String nrp;
  final String icon;

  const _TeamMemberCard({
    required this.width,
    required this.name,
    required this.nrp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.4,
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar Circle dengan Icon
          Container(
            width: width * 0.28,
            height: width * 0.28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF71C6B7),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.person, color: Colors.white, size: 50),
            ),
          ),
          SizedBox(height: width * 0.04),
          // Nama
          Text(
            name,
            style: TextStyle(
              fontSize: width * 0.042,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4FA699),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: width * 0.01),
          // Status
          Text(
            'Member Aktif',
            style: TextStyle(
              fontSize: width * 0.032,
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ================= API CARD =================

class _ApiCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String url;
  final String description;

  const _ApiCard({
    required this.icon,
    required this.title,
    required this.url,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEF4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF71C6B7)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E6A58),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            url,
            style: TextStyle(
              fontSize: width * 0.032,
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: width * 0.035, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
