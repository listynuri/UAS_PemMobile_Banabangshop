import 'package:flutter/material.dart';
import '../widgets/floating_bottom_bar.dart';

import 'buku_page.dart';
import 'keranjang_page.dart';
import 'jadwal_page.dart';
import 'about_page.dart';
import 'login_page.dart';
import 'riwayat_transaksi_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3;

  void _handleBottomTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BukuPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const KeranjangPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const JadwalPage()),
        );
        break;
      case 3:
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AboutPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ================= BACKGROUND =================
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/polka.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ================= CONTENT =================
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.05,
                bottom: 90,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ================= PROFILE CARD =================
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8EE),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: size.width * 0.13,
                          backgroundColor: const Color(0xFF8ED1C6),
                          child: Icon(
                            Icons.person,
                            size: size.width * 0.18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Amara',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D6B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Member Aktif',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= MENU CARD =================
                  _menuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  _menuItem(
                    icon: Icons.lock_outline,
                    title: 'Ganti Password',
                    onTap: () {},
                  ),
                  _menuItem(
                    icon: Icons.history,
                    title: 'Riwayat Transaksi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RiwayatTransaksiPage(),
                        ),
                      );
                    },
                  ),

                  _menuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      );
                    },
                  ),
                  _menuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    isLogout: true,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ================= FLOATING BOTTOM BAR =================
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingBottomBar(
              currentIndex: _currentIndex,
              onTap: _handleBottomTap,
            ),
          ),
        ],
      ),
    );
  }

  // ================= MENU ITEM WIDGET =================
  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isLogout ? Colors.red[100] : const Color(0xFFFFE8EE),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : const Color(0xFF2E7D6B),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
