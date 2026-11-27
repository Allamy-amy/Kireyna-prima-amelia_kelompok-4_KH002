
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stok Barang',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const StokBarangPage(),
    );
  }
}

class StokBarangPage extends StatefulWidget {
  const StokBarangPage({super.key});

  @override
  State<StokBarangPage> createState() => _StokBarangPageState();
}

class _StokBarangPageState extends State<StokBarangPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final tanggalMasukController = TextEditingController();
  final tanggalKeluarController = TextEditingController();
  final kodeController = TextEditingController();
  final stokController = TextEditingController();

  bool sedangMenyimpan = false;

  @override
  void dispose() {
    namaController.dispose();
    tanggalMasukController.dispose();
    tanggalKeluarController.dispose();
    kodeController.dispose();
    stokController.dispose();
    super.dispose();
  }

  Future<void> simpanBarang() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String nama = namaController.text.trim();
    final String tanggalMasuk =
    tanggalMasukController.text.trim();
    final String tanggalKeluar =
    tanggalKeluarController.text.trim();

    // NIM ganjil: kode barang berupa angka desimal.
    final double? kode =
    double.tryParse(kodeController.text.trim());

    final int? jumlahStok =
    int.tryParse(stokController.text.trim());

    if (kode == null || jumlahStok == null) {
      return;
    }

    setState(() {
      sedangMenyimpan = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('stok_barang')
          .add({
        'nama_barang': nama,
        'tanggal_masuk': tanggalMasuk,
        'tanggal_keluar': tanggalKeluar,
        'kode_barang': kode,
        'jumlah_stok': jumlahStok,
        'waktu': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      namaController.clear();
      tanggalMasukController.clear();
      tanggalKeluarController.clear();
      kodeController.clear();
      stokController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barang berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan barang: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          sedangMenyimpan = false;
        });
      }
    }
  }

  Widget buatField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ??
                (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatatan Stok Barang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buatField(
                label: 'Nama Barang',
                controller: namaController,
                keyboardType: TextInputType.text,
              ),

              buatField(
                label: 'Tanggal Masuk Barang',
                controller: tanggalMasukController,
                keyboardType: TextInputType.datetime,
              ),

              buatField(
                label: 'Tanggal Keluar Barang',
                controller: tanggalKeluarController,
                keyboardType: TextInputType.datetime,
              ),

              buatField(
                label: 'Kode Barang (angka desimal)',
                controller: kodeController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode Barang wajib diisi';
                  }

                  final kode = double.tryParse(value.trim());

                  if (kode == null || !kode.isFinite) {
                    return 'Kode Barang harus berupa angka desimal';
                  }

                  return null;
                },
              ),

              buatField(
                label: 'Jumlah Stok',
                controller: stokController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah Stok wajib diisi';
                  }

                  final stok = int.tryParse(value.trim());

                  if (stok == null) {
                    return 'Jumlah Stok harus berupa bilangan bulat';
                  }

                  if (stok < 0) {
                    return 'Jumlah Stok tidak boleh negatif';
                  }

                  return null;
                },
              ),

              ElevatedButton(
                onPressed:
                sedangMenyimpan ? null : simpanBarang,
                child: sedangMenyimpan
                    ? const CircularProgressIndicator()
                    : const Text('Simpan Barang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
