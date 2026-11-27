import 'package:flutter/material.dart';

import '../config/nim_config.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../widgets/common.dart';
import 'user_detail_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<List<User>> _fetch() async {
    final raw = await ApiService.getUsers();
    return raw
        .map((e) => User.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  void _reload() => setState(() => _future = _fetch());

  Future<void> _openDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserDetailPage(userId: id)),
    );
    if (mounted) _reload();
  }

  Future<void> _searchById() async {
    final id = await askIdDialog(
      context,
      title: 'Cari User berdasarkan ID',
      initialId: NimConfig.userId,
    );
    if (id == null || !mounted) return;
    await _openDetail(id);
  }

  // POST: tambah user baru dengan ID dari NIM
  Future<void> _createUser() async {
    final data = await showNameEmailDialog(
      context,
      title: 'Tambah User (ID ${NimConfig.userId})',
      confirmLabel: 'Tambah',
    );
    if (data == null || !mounted) return;

    try {
      await ApiService.createUser(data.name, data.email, id: NimConfig.userId);
      if (!mounted) return;
      showSnack(context, 'User ID ${NimConfig.userId} berhasil ditambahkan');
      _reload();
    } catch (e) {
      if (!mounted) return;
      showSnack(context, 'Gagal menambah user: ${errorText(e)}', error: true);
    }
  }

  Future<void> _reset() async {
    final ok = await confirmDialog(
      context,
      title: 'Reset data User',
      message: 'Kembalikan data User ke kondisi awal?',
      confirmLabel: 'Reset',
    );
    if (!ok) return;
    await ApiService.resetToDefault();
    if (!mounted) return;
    showSnack(context, 'Data User dikembalikan ke awal');
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createUser,
        icon: const Icon(Icons.person_add),
        label: Text('Tambah (ID ${NimConfig.userId})'),
      ),
      body: FutureBuilder<List<User>>(
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
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('Tidak ada data User'));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              final isNim = u.id == NimConfig.userId;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${u.id}')),
                  title: Text(u.name),
                  subtitle: Text('${u.email}\n${u.city}'),
                  isThreeLine: true,
                  trailing: isNim
                      ? const Chip(label: Text('ID NIM'))
                      : const Icon(Icons.chevron_right),
                  onTap: () => _openDetail(u.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
