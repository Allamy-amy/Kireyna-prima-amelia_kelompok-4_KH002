import 'package:flutter/material.dart';

/// Membersihkan teks error "Exception: ..." agar rapi ditampilkan.
String errorText(Object e) => e.toString().replaceFirst('Exception: ', '');

void showSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Hapus',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Dialog input ID (untuk "Cari berdasarkan ID").
Future<int?> askIdDialog(
  BuildContext context, {
  required String title,
  required int initialId,
}) {
  return showDialog<int>(
    context: context,
    builder: (_) => _IdDialog(title: title, initialId: initialId),
  );
}

class _IdDialog extends StatefulWidget {
  final String title;
  final int initialId;
  const _IdDialog({required this.title, required this.initialId});

  @override
  State<_IdDialog> createState() => _IdDialogState();
}

class _IdDialogState extends State<_IdDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialId.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'ID',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, int.tryParse(_controller.text.trim())),
          child: const Text('Cari'),
        ),
      ],
    );
  }
}

/// Hasil isian form nama + email.
class NameEmail {
  final String name;
  final String email;
  const NameEmail(this.name, this.email);
}

/// Dialog form nama & email (dipakai untuk POST dan PUT).
Future<NameEmail?> showNameEmailDialog(
  BuildContext context, {
  required String title,
  String initialName = '',
  String initialEmail = '',
  String confirmLabel = 'Simpan',
}) {
  return showDialog<NameEmail>(
    context: context,
    builder: (_) => _NameEmailDialog(
      title: title,
      initialName: initialName,
      initialEmail: initialEmail,
      confirmLabel: confirmLabel,
    ),
  );
}

class _NameEmailDialog extends StatefulWidget {
  final String title;
  final String initialName;
  final String initialEmail;
  final String confirmLabel;

  const _NameEmailDialog({
    required this.title,
    required this.initialName,
    required this.initialEmail,
    required this.confirmLabel,
  });

  @override
  State<_NameEmailDialog> createState() => _NameEmailDialogState();
}

class _NameEmailDialogState extends State<_NameEmailDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName);
    _email = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                if (!v.contains('@')) return 'Format email tidak valid';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
                NameEmail(_name.text.trim(), _email.text.trim()),
              );
            }
          },
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

/// Tampilan error + tombol coba lagi.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }
}

/// Satu baris label : nilai pada halaman detail.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: Theme.of(context).textTheme.labelMedium),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
