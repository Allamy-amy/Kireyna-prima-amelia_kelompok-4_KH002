import 'package:flutter_test/flutter_test.dart';
import 'package:praktikum8/config/nim_config.dart';
import 'package:praktikum8/models/admin.dart';

void main() {
  test('Angka berdasarkan NIM 20240801069 (N = 96)', () {
    expect(NimConfig.n, 96);
    expect(NimConfig.userId, 1499 + 96);
    expect(NimConfig.adminId, 792 + 96);
  });

  test('Admin.fromJson mengonversi JSON menjadi objek Admin', () {
    final admin = Admin.fromJson({
      'id': 888,
      'name': 'Admin Utama',
      'email': 'admin.utama@kampus.ac.id',
      'department': 'Teknologi Informasi',
    });
    expect(admin.id, 888);
    expect(admin.name, 'Admin Utama');
    expect(admin.department, 'Teknologi Informasi');
  });
}
