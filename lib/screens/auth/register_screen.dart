import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _cadastrar() async {
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty || _senhaController.text.isEmpty) {
      _mostrarErro("Preencha nome, e-mail e senha.");
      return;
    }

    setState(() => _carregando = true);

    try {
      // 1. Cria o login
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // 2. Salva os dados extras no Banco de Dados
      await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid).set({
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'telefone': _telefoneController.text.trim(),
        'tipo': 'paciente',
        'objetivo': 'Não definido',
        'fotoUrl': '',
      });

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      _mostrarErro("Erro: $e");
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
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
              const Icon(Icons.person_add_outlined, size: 60, color: Color(0xFFB76E79)),
              const SizedBox(height: 30),
              TextField(controller: _nomeController, decoration: const InputDecoration(labelText: "Nome Completo")),
              const SizedBox(height: 15),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: "E-mail")),
              const SizedBox(height: 15),
              TextField(controller: _telefoneController, decoration: const InputDecoration(labelText: "Telefone")),
              const SizedBox(height: 15),
              TextField(controller: _senhaController, obscureText: true, decoration: const InputDecoration(labelText: "Senha")),
              const SizedBox(height: 30),
              _carregando 
                ? const CircularProgressIndicator() 
                : ElevatedButton(
                    onPressed: _cadastrar,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB76E79), minimumSize: const Size(double.infinity, 50)),
                    child: const Text("CRIAR MINHA CONTA", style: TextStyle(color: Colors.white)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}