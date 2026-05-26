import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importação necessária para os AutofillHints
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:nutri_app/theme/app_colors.dart'; 
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

      // AVISO DE AUTOFILL: Diz ao sistema que o login deu certo e as credenciais podem ser salvas/lembradas
      TextInput.finishAutofillContext();

      if (mounted) {
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
      backgroundColor: AppColors.fundo,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: AutofillGroup( // MUDANÇA: Agrupa os campos para o preenchimento automático trabalhar junto
            child: Column(
              children: [
                Icon(Icons.spa_outlined, size: 80, color: AppColors.roseGold),
                const SizedBox(height: 20),
                Text(
                  "BEM-VINDA",
                  style: TextStyle(letterSpacing: 3, fontSize: 10, color: AppColors.textoSuave),
                ),
                Text(
                  "Acesso do Paciente",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: AppColors.textoEscuro),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "E-mail cadastrado"),
                  textInputAction: TextInputAction.next,
                  
                  // MUDANÇAS: Ativa sugestões e avisa ao navegador que este campo é para E-mail
                  enableSuggestions: true,
                  autofillHints: const [AutofillHints.email], 
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Senha"),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    _tentarLogin();
                  },
                  
                  // MUDANÇA: Avisa ao navegador que este campo é a senha
                  autofillHints: const [AutofillHints.password], 
                ),
                const SizedBox(height: 40),
                
                _carregando 
                  ? CircularProgressIndicator(color: AppColors.roseGold)
                  : ElevatedButton(
                      onPressed: _tentarLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.roseGold,
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
                  child: Text(
                    "Não tem uma conta? Cadastre-se aqui",
                    style: TextStyle(color: AppColors.textoSuave, fontSize: 14),
                  ),
                ),

                const SizedBox(height: 10),
                
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NutriLoginScreen()));
                  },
                  child: Text(
                    "Acesso Nutricionista", 
                    style: TextStyle(color: AppColors.roseGold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}