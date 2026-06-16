import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zealwvqddgkttqvvpayg.supabase.co',
    anonKey: 'sb_publishable_Gd2r-wD5qYcSWrCinNTICA__09lmLD0',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucky Star Lottery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6C3BE8),
        scaffoldBackgroundColor: const Color(0xFFF5F5FF),
      ),
      home: const HomeScreen(),
    );
  }
}
