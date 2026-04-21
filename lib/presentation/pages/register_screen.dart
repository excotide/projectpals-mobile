import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Tema Warna ProjectPals
  final Color primaryCyan = const Color(0xFF3CD7FF);
  final Color darkBlueBg = const Color(0xFF041329);
  final Color mintGreen = const Color(0xFF42E38D);
  final Color textGrey = const Color(0xFFC5C6CD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlueBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryCyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PROJECTPALS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            // Membatasi lebar agar tetap di tengah dan rapi
            constraints: const BoxConstraints(maxWidth: 400), 
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A).withValues(alpha: 0.8), 
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                
                _buildTextField("NICKNAME", "Ana Zumrotu"),
                const SizedBox(height: 20),
                _buildTextField("USERNAME", "ana"),
                const SizedBox(height: 20),
                _buildTextField("EMAIL ADDRESS", "anazumrotu@gmail.com"),
                const SizedBox(height: 20),
                _buildTextField("PASSWORD", "••••••••", isPassword: true),
                
                const SizedBox(height: 40),
                
                // Tombol Create Account
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppStrings.routeDashboard,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Create Account",
                          style: TextStyle(
                            color: Color(0xFF003642),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, color: Color(0xFF003642), size: 20),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 25),
                
                // Link ke Login Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", 
                      style: TextStyle(color: textGrey, fontSize: 13)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppStrings.routeLogin);
                      },
                      child: Text(
                        "Log In", 
                        style: TextStyle(
                          color: mintGreen, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk TextField agar kode lebih bersih
  Widget _buildTextField(String label, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: mintGreen,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: const Color(0xFF05101C), 
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryCyan.withValues(alpha: 0.6)),
            ),
          ),
        ),
      ],
    );
  }
}