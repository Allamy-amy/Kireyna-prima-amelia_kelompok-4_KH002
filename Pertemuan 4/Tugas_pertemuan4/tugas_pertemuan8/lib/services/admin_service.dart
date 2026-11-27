import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../config/nim_config.dart';
import '../models/admin.dart';

/// Service untuk data Admin (GET semua, GET satu, DELETE).
///
/// JSONPlaceholder tidak menyediakan resource admin, sehingga data admin
/// disimpan lokal (SharedPreferences) dengan data awal [_defaultAdmins].
/// Data awal memuat Admin dengan ID = 792 + N ([NimConfig.adminId]).
class AdminService {
  static const String storageKey = 'admins_json';

  static Future<List<dynamic>> _readJsonData() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(storageKey);

    if (cached != null && cached.isNotEmpty) {
      try {
        return jsonDecode(cached) as List<dynamic>;
      } catch (_) {
        // data rusak -> pakai data awal
      }
    }

    final seed = _defaultAdmins
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    await _writeJsonData(seed);
    return seed;
  }

  static Future<void> _writeJsonData(List<dynamic> admins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      storageKey,
      const JsonEncoder.withIndent('  ').convert(admins),
    );
  }

  /// GET: mengambil seluruh data Admin.
  static Future<List<Admin>> getAdmins() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final data = await _readJsonData();
    return data
        .map((e) => Admin.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// GET: mengambil satu Admin berdasarkan [id].
  static Future<Admin> getAdmin(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final data = await _readJsonData();

    for (final item in data) {
      final map = Map<String, dynamic>.from(item as Map);
      if (map['id'] == id) {
        return Admin.fromJson(map);
      }
    }
    throw Exception('Data admin dengan ID $id tidak ditemukan');
  }

  /// DELETE: menghapus Admin berdasarkan [id]. Mengembalikan true jika berhasil.
  static Future<bool> deleteAdmin(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final data = await _readJsonData();

    final index = data.indexWhere((e) => e['id'] == id);
    if (index == -1) return false;

    data.removeAt(index);
    await _writeJsonData(data);
    return true;
  }

  /// Mengembalikan data admin ke kondisi awal (untuk pengujian ulang).
  static Future<void> resetToDefault() async {
    final seed = _defaultAdmins
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    await _writeJsonData(seed);
  }

  static final List<Map<String, dynamic>> _defaultAdmins = [
    {
      'id': 1,
      'name': 'Budi Santoso',
      'email': 'budi.santoso@kampus.ac.id',
      'department': 'Akademik',
    },
    {
      'id': 2,
      'name': 'Siti Rahmawati',
      'email': 'siti.rahmawati@kampus.ac.id',
      'department': 'Keuangan',
    },
    {
      'id': 3,
      'name': 'Andi Wijaya',
      'email': 'andi.wijaya@kampus.ac.id',
      'department': 'IT Support',
    },
    {
      'id': 4,
      'name': 'Dewi Lestari',
      'email': 'dewi.lestari@kampus.ac.id',
      'department': 'Kemahasiswaan',
    },
    {
      'id': NimConfig.adminId,
      'name': 'Admin Utama',
      'email': 'admin.utama@kampus.ac.id',
      'department': 'Teknologi Informasi',
    },
  ];
}
