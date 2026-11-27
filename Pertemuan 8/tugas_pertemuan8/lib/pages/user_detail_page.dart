import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../widgets/common.dart';

class UserDetailPage extends StatefulWidget {
  final int userId;
  const UserDetailPage({super.key, required this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Future<User> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  // GET by ID
  Future<User> _fetch() async {
    final json = await ApiService.getUser(widget.userId);
    return User.fromJson(json);
  }

  void _reload() => setState(() => _future = _fetch());

  // PUT: ubah nama & email
  Future<void> _put(User user) async {
    final data = await showNameEmailDialog(
      context,
      title: 'Ubah Nama & Email (PUT)',
      initialName: user.name,
      initialEmail: user.email,
    );
    if (data == null || !mounted) return;

    try {
      await ApiService.updateUser(user.id, data.name, data.email);
      if (!mounted) return;
      showSnack(context, 'Data user berhasil diperbarui (PUT)');
      _reload();
    } catch (e) {
      if (!mounted) return;
      showSnack(context, errorText(e), error: true);
    }
  }

  // PATCH: tambah teks " - Flutter Developer" pada nama
  Future<void> _patch(User user) async {
    try {
      await ApiService.patchUser(user.id);
      if (!mounted) return;
      showSnack(context, 'Nama berhasil diperbarui (PATCH)');
      _reload();
    } catch (e) {
      if (!mounted) return;
      showSnack(context, errorText(e), error: true);
    }
  }

  // DELETE
  Future<void> _delete(User user) async {
    final ok = await confirmDialog(
      context,
      title: 'Hapus User',
      message: 'Hapus user "${user.name}" (ID ${user.id})?',
    );
    if (!ok || !mounted) return;

    final deleted = await ApiService.deleteUser(user.id);
    if (!mounted) return;
    if (deleted) {
      showSnack(context, 'User ID ${user.id} berhasil dihapus');
      Navigator.pop(context);
    } else {
      showSnack(context, 'User tidak ditemukan', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail User ID ${widget.userId}')),
      body: FutureBuilder<User>(
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
          final user = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Column(
                  children: [
                    InfoRow(icon: Icons.tag, label: 'ID', value: '${user.id}'),
                    InfoRow(icon: Icons.person, label: 'Nama', value: user.name),
                    InfoRow(icon: Icons.email, label: 'Email', value: user.email),
                    InfoRow(
                      icon: Icons.location_city,
                      label: 'Kota',
                      value: user.city,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _put(user),
                icon: const Icon(Icons.edit),
                label: const Text('Ubah Nama & Email (PUT)'),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => _patch(user),
                icon: const Icon(Icons.code),
                label: const Text('Tambah " - Flutter Developer" (PATCH)'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _delete(user),
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Hapus User (DELETE)',
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
