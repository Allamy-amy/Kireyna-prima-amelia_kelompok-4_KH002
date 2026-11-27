import 'package:flutter/material.dart';

import '../config/nim_config.dart';
import '../models/admin.dart';
import '../services/admin_service.dart';
import '../widgets/common.dart';
import 'admin_detail_page.dart';

class AdminListPage extends StatefulWidget {
  const AdminListPage({super.key});

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  late Future<List<Admin>> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminService.getAdmins();
  }

  void _reload() => setState(() => _future = AdminService.getAdmins());

  Future<void> _openDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminDetailPage(adminId: id)),
    );
    if (mounted) _reload();
  }

  Future<void> _searchById() async {
    final id = await askIdDialog(
      context,
      title: 'Cari Admin berdasarkan ID',
      initialId: NimConfig.adminId,
    );
    if (id == null || !mounted) return;
    await _openDetail(id);
  }

  // DELETE admin dari daftar
  Future<void> _delete(Admin admin) async {
    final ok = await confirmDialog(
      context,
      title: 'Hapus Admin',
      message: 'Hapus admin "${admin.name}" (ID ${admin.id})?',
    );
    if (!ok || !mounted) return;

    final deleted = await AdminService.deleteAdmin(admin.id);
    if (!mounted) return;
    if (deleted) {
      showSnack(context, 'Admin ID ${admin.id} berhasil dihapus');
      _reload();
    } else {
      showSnack(context, 'Admin tidak ditemukan', error: true);
    }
  }

  Future<void> _reset() async {
    final ok = await confirmDialog(
      context,
      title: 'Reset data Admin',
      message: 'Kembalikan data Admin ke kondisi awal?',
      confirmLabel: 'Reset',
    );
    if (!ok) return;
    await AdminService.resetToDefault();
    if (!mounted) return;
    showSnack(context, 'Data Admin dikembalikan ke awal');
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Admin'),
        actions: [
          IconButton(
            tooltip: 'Cari berdasarkan ID',
            icon: const Icon(Icons.search),
            onPressed: _searchById,
          ),
          IconButton(
            tooltip: 'Reset data',
            icon: const Icon(Icons.restore),
            onPressed: _reset,
          ),
        ],
      ),
      body: FutureBuilder<List<Admin>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: 'Gagal mengambil data: ${errorText(snapshot.error!)}',
              onRetry: _reload,
            );
          }
          final admins = snapshot.data ?? [];
          if (admins.isEmpty) {
            return const Center(child: Text('Tidak ada data Admin'));
          }
          return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, i) {
              final a = admins[i];
              final isNim = a.id == NimConfig.adminId;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${a.id}', style: const TextStyle(fontSize: 12)),
                  ),
                  title: Text(a.name),
                  subtitle: Text(
                    '${a.email}\n${a.department}${isNim ? '  •  ID NIM' : ''}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: 'Hapus admin',
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _delete(a),
                  ),
                  onTap: () => _openDetail(a.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
