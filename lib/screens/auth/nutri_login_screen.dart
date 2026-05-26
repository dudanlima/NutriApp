import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_colors.dart';
import '../admin/nutri_home_screen.dart';

class NutriLoginScreen extends StatefulWidget {
  const NutriLoginScreen({super.key});

  @override
  State<NutriLoginScreen> createState() => _NutriLoginScreenState();
}

class _NutriLoginScreenState extends State<NutriLoginScreen> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _loginNutri() async {
    setState(() => _carregando = true);

    // Limpa o CPF para o formato que você cadastrou no Firebase (apenas números)
    String cpfLimpo = _cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
    String emailNutri = "$cpfLimpo@nutri.com";

    try {
      // Faz a autenticação real no Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailNutri,
        password: _senhaController.text,
      );

      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NutriHomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      
      String mensagemErro = "Acesso negado. Verifique suas credenciais.";
      if (e.code == 'user-not-found') mensagemErro = "Profissional não cadastrada.";
      if (e.code == 'wrong-password') mensagemErro = "Senha incorreta.";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagemErro),
          backgroundColor: AppColors.erro,
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(Icons.verified_user_outlined, size: 70, color: AppColors.roseGold),
              const SizedBox(height: 30),
              const Text(
                "ÁREA PROFISSIONAL",
                style: TextStyle(
                  color: Color(0xFF8D7A71),
                  fontSize: 10,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Eduarda Nogueira",
                style: TextStyle(
                  color: Color(0xFF4A3B37),
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                style: const TextStyle(color: Color(0xFF4A3B37)),
                decoration: InputDecoration(
                  labelText: "CPF Profissional",
                  hintText: "000.000.000-00",
                  labelStyle: const TextStyle(color: Color(0xFF8D7A71), fontSize: 14),
                  prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.roseGold, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFFEBE8E2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.roseGold, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _senhaController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF4A3B37)),
                decoration: InputDecoration(
                  labelText: "Senha de Acesso",
                  labelStyle: const TextStyle(color: Color(0xFF8D7A71), fontSize: 14),
                  prefixIcon: const Icon(Icons.lock_open_outlined, color: AppColors.roseGold, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFFEBE8E2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.roseGold, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _carregando ? null : _loginNutri,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.roseGold,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: _carregando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        "ENTRAR NO CONSULTÓRIO",
                        style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.5),
                      ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Voltar ao acesso comum", style: TextStyle(color: Color(0xFF8D7A71), fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}