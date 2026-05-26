import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importação do banco de dados
import 'register_screen.dart'; 
import '../paciente/home_screen.dart';
import 'nutri_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _tentarLogin() async {
    String emailDigitado = _emailController.text.trim().toLowerCase();
    String senhaDigitada = _senhaController.text.trim();

    if (emailDigitado.isEmpty || senhaDigitada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha o e-mail e a senha."),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailDigitado,
        password: senhaDigitada,
      );

      if (mounted) {
        // Busca o nome real do paciente no banco de dados
        var userDoc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .get();

        String nomeReal = "Paciente";
        if (userDoc.exists && userDoc.data() != null) {
          nomeReal = userDoc.get('nome');
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              nomeCompleto: nomeReal, 
              email: emailDigitado,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String mensagemErro = "Ocorreu um erro ao acessar o plano.";

      if (e.code == 'user-not-found') {
        mensagemErro = "E-mail não cadastrado no sistema.";
      } else if (e.code == 'wrong-password') {
        mensagemErro = "Senha incorreta. Verifique e tente novamente.";
      } else if (e.code == 'invalid-email') {
        mensagemErro = "O formato do e-mail é inválido.";
      } else if (e.code == 'invalid-credential') {
        mensagemErro = "E-mail ou senha incorretos.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensagemErro),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro de conexão. Tente novamente."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
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
              const Icon(Icons.spa_outlined, size: 80, color: Color(0xFFB76E79)),
              const SizedBox(height: 20),
              const Text(
                "BEM-VINDA",
                style: TextStyle(letterSpacing: 3, fontSize: 10, color: Color(0xFF8D7A71)),
              ),
              const Text(
                "Acesso do Paciente",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Color(0xFF4A3B37)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "E-mail cadastrado"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Senha"),
              ),
              const SizedBox(height: 40),
              
              _carregando 
                ? const CircularProgressIndicator(color: Color(0xFFB76E79))
                : ElevatedButton(
                    onPressed: _tentarLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB76E79),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("ACESSAR MEU PLANO"),
                  ),
              
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  "Não tem uma conta? Cadastre-se aqui",
                  style: TextStyle(color: Color(0xFF8D7A71), fontSize: 14),
                ),
              ),

              const SizedBox(height: 10),
              
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NutriLoginScreen()));
                },
                child: const Text("Acesso Nutricionista", style: TextStyle(color: Color(0xFFB76E79), fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}