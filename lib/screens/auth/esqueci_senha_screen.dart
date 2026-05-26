import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class EsqueciSenhaScreen extends StatefulWidget {
  const EsqueciSenhaScreen({super.key});

  @override
  State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _enviado = false;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _emailValido(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email);
  }

  Future<void> _enviar() async {
    final email = _emailController.text.trim();

    setState(() => _erro = null);

    if (email.isEmpty) {
      setState(() => _erro = "Digite seu e-mail para continuar.");
      return;
    }

    if (!_emailValido(email)) {
      setState(() => _erro = "Digite um e-mail válido.");
      return;
    }

    setState(() => _carregando = true);

    // Simula envio (2 segundos)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _carregando = false;
      _enviado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.roseEscuro, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: _enviado ? _telaConfirmacao() : _telaFormulario(),
      ),
    );
  }

  // ── FORMULÁRIO ──────────────────────────────────────────────
  Widget _telaFormulario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // Ícone
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.roseGold.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.lock_reset_outlined, color: AppColors.roseGold, size: 30),
        ),

        const SizedBox(height: 28),

        Text(
          "Recuperar acesso",
          style: GoogleFonts.greatVibes(
            fontSize: 38,
            color: AppColors.roseEscuro,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          "Sem problema! Digite seu e-mail e\nenviamos um link para redefinir sua senha.",
          style: TextStyle(
            color: AppColors.textoSuave,
            fontSize: 14,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 40),

        // Campo e-mail
        const Text(
          "E-MAIL CADASTRADO",
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: AppColors.roseGold,
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => setState(() => _erro = null),
          decoration: InputDecoration(
            hintText: "seu@email.com",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            prefixIcon: const Icon(Icons.mail_outline, color: AppColors.roseGold, size: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.champanhe),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.roseGold, width: 1.5),
            ),
          ),
        ),

        // Erro
        if (_erro != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.erro.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.erro.withOpacity(0.4)),
              ),
              child: Text(
                _erro!,
                style: const TextStyle(color: AppColors.roseEscuro, fontSize: 13),
              ),
            ),
          ),

        const SizedBox(height: 35),

        // Botão enviar
        ElevatedButton(
          onPressed: _carregando ? null : _enviar,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.roseGold,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _carregando
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  "ENVIAR LINK DE ACESSO",
                  style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 12),
                ),
        ),

        const SizedBox(height: 20),

        // Voltar
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Voltar para o login",
              style: TextStyle(color: AppColors.textoSuave, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  // ── CONFIRMAÇÃO ─────────────────────────────────────────────
  Widget _telaConfirmacao() {
    return Column(
      children: [
        const SizedBox(height: 60),

        // Ícone de sucesso
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.sucesso.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mark_email_read_outlined, color: AppColors.sucesso, size: 42),
        ),

        const SizedBox(height: 32),

        Text(
          "E-mail enviado!",
          style: GoogleFonts.greatVibes(
            fontSize: 42,
            color: AppColors.roseEscuro,
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Enviamos um link de recuperação para\n${_emailController.text.trim()}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textoSuave,
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ),

        const SizedBox(height: 12),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Verifique sua caixa de entrada e a pasta de spam.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textoSuave,
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(height: 50),

        // Card dica
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.champanhe.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.champanhe),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.roseGold, size: 20),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  "O link expira em 30 minutos. Se não receber, tente novamente.",
                  style: TextStyle(
                    color: AppColors.textoPrincipal,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Botão voltar ao login
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.roseGold,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "VOLTAR AO LOGIN",
            style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),

        const SizedBox(height: 16),

        // Reenviar
        TextButton(
          onPressed: () => setState(() {
            _enviado = false;
            _emailController.clear();
          }),
          child: const Text(
            "Usar outro e-mail",
            style: TextStyle(color: AppColors.textoSuave, fontSize: 13),
          ),
        ),
      ],
    );
  }
}