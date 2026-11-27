import 'package:flutter/material.dart';

import '../models/admin.dart';
import '../services/admin_service.dart';
import '../widgets/common.dart';

class AdminDetailPage extends StatefulWidget {
  final int adminId;
  const AdminDetailPage({super.key, required this.adminId});

  @override
  State<AdminDetailPage> createState() => _AdminDetailPageState();
}

class _AdminDetailPageState extends State<AdminDetailPage> {
  late Future<Admin> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminService.getAdmin(widget.adminId);
  }

  void _reload() =>
      setState(() => _future = AdminService.getAdmin(widget.adminId));

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
      Navigator.pop(context);
    } else {
      showSnack(context, 'Admin tidak ditemukan', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Admin ID ${widget.adminId}')),
      body: FutureBuilder<Admin>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: errorText(snapshot.error!),
              onRetry: _reload,
            );
          }
          final admin = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Column(
                  children: [
                    InfoRow(icon: Icons.tag, label: 'ID', value: '${admin.id}'),
                    InfoRow(icon: Icons.person, label: 'Nama', value: admin.name),
                    InfoRow(icon: Icons.email, label: 'Email', value: admin.email),
                    InfoRow(
                      icon: Icons.apartment,
                      label: 'Department',
                      value: admin.department,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _delete(admin),
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Hapus Admin (DELETE)',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
