import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const int ddd = 9;

    const double cardPadding = 16 + 9;
    const double cardRadius = 8 + 9;
      const double buttonHeight = 40 + 9;
    const double buttonRadius = 4 + 9;
    const double avatarSize = 40 + (2 * 9);
    const double nameNimSpacing = 8 + 9;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Profile Card'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: avatarSize / 2,
                    child: Icon(
                      Icons.person,
                      size: avatarSize * 0.6,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text('Kireyna Prima Amelia'),

                  SizedBox(height: nameNimSpacing),

                  const Text('NIM: 20240801069'),

                  const SizedBox(height: 8),

                  const Text('Program Studi Teknik Informatika'),

                  const SizedBox(height: 16),

                  const Text(
                    'Saya adalah mahasiswa yang tertarik '
                        'mempelajari teknologi, pemrograman, '
                        'dan pengembangan aplikasi.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  AppButton(
                    label: 'Kunjungi GitHub Saya',
                    icon: Icons.code,
                    url: 'https://github.com/Allamy-amy',
                    height: buttonHeight,
                    borderRadius: buttonRadius,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}