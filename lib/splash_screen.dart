import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Splash screen tampil selama 5 detik
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Responsive values
    final double logoSize = size.width * 0.45; // logo menyesuaikan lebar layar
    final double titleFont = size.width * 0.07;
    final double nameFont = size.width * 0.045;
    final double nrpFont = size.width * 0.04;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE4EC), // pastel pink
              Color(0xFFDFF5EA), // pastel green
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nama Toko (atas logo)
                  Text(
                    'BANABANGSHOP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFont,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3A6B5C),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Logo di tengah — tampil sebagai foto tanpa card putih
                  SizedBox(
                    width: logoSize,
                    height: logoSize,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(logoSize * 0.12),
                      child: Opacity(
                        opacity: 0.95,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Nama Mahasiswa
                  Text(
                    'Listy Nuri S & Aulia Nur A',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: nameFont,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A4A4A),
                    ),
                  ),
                  SizedBox(height: size.height * 0.008),

                  // NRP
                  Text(
                    'NRP: 152022002 & 152022046',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: nrpFont,
                      color: const Color(0xFF6B6B6B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
