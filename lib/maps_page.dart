import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'home_page.dart';
import 'buku_page.dart';
import 'keranjang_page.dart';
import 'jadwal_page.dart';
import 'profile_page.dart';
import 'about_page.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  int currentIndex = 3;

  static const double tokoLat = -6.9175;
  static const double tokoLng = 107.6191;

  // Lokasi toko
  static const List<Map<String, dynamic>> locations = [
    {
      'name': 'Toko Utama Bandung',
      'lat': -6.9175,
      'lng': 107.6191,
      'address': 'Jl. Merdeka No. 123, Bandung',
      'snippet': 'Lokasi pengambilan pesanan utama',
    },
    {
      'name': 'Toko Cabang Cimahi',
      'lat': -6.8891,
      'lng': 107.5447,
      'address': 'Jl. Raya Cimahi No. 45, Cimahi',
      'snippet': 'Cabang di area Cimahi',
    },
  ];

  Future<void> _openGoogleMaps(double lat, double lng) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    try {
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(
          Uri.parse(googleMapsUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Maps tidak tersedia')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
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
        final scale = (w / 390).clamp(0.85, 1.2);

        double sp(double v) => v * scale;
        double pad(double v) => v * scale;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Lokasi'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF2E6A58),
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
                  pad(20),
                ),
                child: Column(
                  children: [
                    // TITLE CARD
                    Container(
                      padding: EdgeInsets.all(pad(14)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Lokasi Toko',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: sp(22),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E6A58),
                        ),
                      ),
                    ),

                    SizedBox(height: pad(20)),

                    // MAP CARD - Flutter Map
                    GestureDetector(
                      onTap: () => _openGoogleMaps(tokoLat, tokoLng),
                      child: Container(
                        height: pad(340),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: IgnorePointer(
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(tokoLat, tokoLng),
                              initialZoom: 13,
                              interactionOptions: const InteractionOptions(
                                flags: ~InteractiveFlag.all,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(
                                markers: locations
                                    .map(
                                      (loc) => Marker(
                                        point: LatLng(loc['lat'], loc['lng']),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: pad(30),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: pad(20)),

                    // INFO CARD - Menampilkan semua lokasi
                    Container(
                      padding: EdgeInsets.all(pad(16)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📍 Lokasi Toko Kami',
                            style: TextStyle(
                              fontSize: sp(16),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2E6A58),
                            ),
                          ),
                          SizedBox(height: pad(12)),
                          ...locations.map(
                            (loc) => Padding(
                              padding: EdgeInsets.only(bottom: pad(12)),
                              child: GestureDetector(
                                onTap: () =>
                                    _openGoogleMaps(loc['lat'], loc['lng']),
                                child: Container(
                                  padding: EdgeInsets.all(pad(12)),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F8F5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF71C6B7),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: sp(16),
                                            color: const Color(0xFF71C6B7),
                                          ),
                                          SizedBox(width: pad(8)),
                                          Expanded(
                                            child: Text(
                                              loc['name'],
                                              style: TextStyle(
                                                fontSize: sp(14),
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF2E6A58),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_outward,
                                            size: sp(14),
                                            color: const Color(0xFF71C6B7),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: pad(6)),
                                      Text(
                                        loc['address'],
                                        style: TextStyle(
                                          fontSize: sp(12),
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: pad(4)),
                                      Text(
                                        loc['snippet'],
                                        style: TextStyle(
                                          fontSize: sp(11),
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: pad(20)),

                    // ACTION BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openGoogleMaps(tokoLat, tokoLng),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9BC1),
                          padding: EdgeInsets.symmetric(vertical: pad(14)),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          '🗺️ Buka di Google Maps',
                          style: TextStyle(
                            fontSize: sp(14),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
