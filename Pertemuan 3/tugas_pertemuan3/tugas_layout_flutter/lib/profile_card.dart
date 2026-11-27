import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String hobi;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.hobi,
  });

  @override
  Widget build(BuildContext context) {
    // Mengambil digit NIM sesuai rumus tugas
    final int digitTerakhir =
    int.parse(nim.substring(nim.length - 1));

    final int digitKeduaDariBelakang =
    int.parse(nim.substring(nim.length - 2, nim.length - 1));

    final int duaDigitTerakhir =
    int.parse(nim.substring(nim.length - 2));

    // Perhitungan atribut berdasarkan NIM
    final double lebarKartu =
        320.0 + (digitKeduaDariBelakang * 5);

    final double radiusKartu =
        12.0 + (digitTerakhir * 1.5);

    final double ukuranLogo =
        60.0 + (digitTerakhir * 2);

    final double jarakLogo =
        15.0 + digitTerakhir;

    final int skorAktivitas =
        duaDigitTerakhir + 50;

    return Container(
      width: lebarKartu,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radiusKartu),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
                child: FlutterLogo(
                  size: ukuranLogo,
                ),
              ),

              SizedBox(width: jarakLogo),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kartu Praktikan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(
            thickness: 1.5,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NIM: $nim',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Hobi: $hobi',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Skor Aktivitas: $skorAktivitas',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}