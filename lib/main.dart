import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login.dart';
import 'screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vkefqqsjvxwokbiemfdq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrZWZxcXNqdnh3b2tiaWVtZmRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2NTY3NjUsImV4cCI6MjA2ODIzMjc2NX0.IoVL--ve0MnSLCN18eoeqr0RD-NqbHbNK7Cn9o1rh-s',
  );

  // ✅ Web OAuth redirect handling (manual fallback if recoverSessionFromUrl is missing)
  final uri = Uri.base;
  if (uri.fragment.contains('access_token')) {
    await Supabase.instance.client.auth.getSessionFromUrl(uri);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Upwork Tool',
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    // Listen for auth changes and rebuild
    Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      return const DashboardPage(); // ✅ User is logged in
    } else {
      return const LoginPage(); // 🔒 Show login screen
    }
  }
}
