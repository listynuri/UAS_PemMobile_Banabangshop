import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/floating_bottom_bar.dart';
import 'home_page.dart';
import 'buku_page.dart';
import 'keranjang_page.dart';
import 'profile_page.dart';
import 'about_page.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> cities = [];

  Map<String, dynamic>? selectedProvince;
  Map<String, dynamic>? selectedCity;

  int shippingCost = 0;
  int currentIndex = 3;

  @override
  void initState() {
    super.initState();
    fetchProvinces();
  }

  Future<void> fetchProvinces() async {
    final res = await http.get(
      Uri.parse(
        'https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json',
      ),
    );
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      setState(() {
        provinces = data.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> fetchCities(dynamic provinceId) async {
    final res = await http.get(
      Uri.parse(
        'https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json',
      ),
    );
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      setState(() {
        cities = data.cast<Map<String, dynamic>>();
        selectedCity = null;
        shippingCost = 0;
      });
    }
  }

  void calculateShipping() {
    final name = selectedProvince!['name'].toString().toLowerCase();
    shippingCost = name.contains('jawa') ? 10000 : 20000;
    setState(() {});
  }

  void onNavTap(int i) {
    setState(() => currentIndex = i);
    final pages = [
      const HomePage(),
      const BukuPage(),
      const KeranjangPage(),
      const JadwalPage(),
      const ProfilePage(),
      const AboutPage(),
    ];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => pages[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // === SCALE FACTOR ===
        final scale = (w / 390).clamp(0.85, 1.2);

        double sp(double v) => v * scale;
        double pad(double v) => v * scale;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Ongkir'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF2E6A58),
          ),

          // ✅ bottomNavigationBar, BUKAN Positioned
          bottomNavigationBar: SafeArea(
            child: FloatingBottomBar(
              currentIndex: currentIndex,
              onTap: onNavTap,
            ),
          ),

          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/polka.jpg'),
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.9),
                  BlendMode.modulate,
                ),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  pad(16),
                  pad(16),
                  pad(16),
                  pad(120), // aman dari bottom bar
                ),
                child: Column(
                  children: [
                    // TITLE
                    Container(
                      padding: EdgeInsets.all(pad(14)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Cek Ongkos Kirim',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: sp(22),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E6A58),
                        ),
                      ),
                    ),

                    SizedBox(height: pad(20)),

                    // FORM CARD
                    Container(
                      padding: EdgeInsets.all(pad(16)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.97),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Provinsi',
                            style: TextStyle(
                              fontSize: sp(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: pad(8)),
                          DropdownButtonFormField(
                            value: selectedProvince,
                            hint: const Text('Pilih Provinsi'),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFFFF6FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: provinces
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p['name']),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() => selectedProvince = val);
                              fetchCities(val!['id']);
                            },
                          ),

                          SizedBox(height: pad(16)),

                          Text(
                            'Kota / Kabupaten',
                            style: TextStyle(
                              fontSize: sp(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: pad(8)),
                          DropdownButtonFormField(
                            value: selectedCity,
                            hint: const Text('Pilih Kota'),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFE6FFF5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: cities
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c['name']),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => selectedCity = val),
                          ),

                          SizedBox(height: pad(20)),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: selectedCity == null
                                  ? null
                                  : calculateShipping,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9BC1),
                                padding: EdgeInsets.symmetric(
                                  vertical: pad(14),
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'Cek Harga Shipping',
                                style: TextStyle(fontSize: sp(14)),
                              ),
                            ),
                          ),

                          if (shippingCost > 0) ...[
                            SizedBox(height: pad(16)),
                            Center(
                              child: Chip(
                                label: Text(
                                  'Rp $shippingCost',
                                  style: TextStyle(
                                    fontSize: sp(14),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: pad(20)),

                    // NOTE
                    Container(
                      padding: EdgeInsets.all(pad(14)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'Tips: Pilih provinsi terlebih dahulu, lalu pilih kota.',
                        style: TextStyle(fontSize: sp(13)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
