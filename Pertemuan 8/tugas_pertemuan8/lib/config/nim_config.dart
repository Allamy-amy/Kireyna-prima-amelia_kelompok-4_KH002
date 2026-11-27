/// Konfigurasi angka berdasarkan NIM.
///
/// NIM        : 20240801069
/// Tiga digit terakhir : 069 -> angka tengah digeser ke belakang -> 096
/// N          : 96
class NimConfig {
  static const String nim = '20240801069';
  static const int n = 96;

  /// ID User  = 1499 + N
  static const int userId = 1499 + n;

  /// ID Admin = 792 + N
  static const int adminId = 792 + n;
}
