import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void signInWithGoogle() async {
    await Supabase.instance.client.auth.signInWithOAuth(
      Provider.google,
      redirectTo: Uri.base.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 40,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sign in to Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Google login button
              GestureDetector(
                onTap: signInWithGoogle,
                child: ClipOval(
                  child: Image(image: AssetImage('/Users/jawadulhassan/StudioProjects/upworkfiverrtools/assets/google-logo.png'),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text("∴ No Credit Card Required"),
              const SizedBox(height: 20),

              if (user != null) ...[
                const Divider(),
                Text("Logged in as: ${user.email}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
