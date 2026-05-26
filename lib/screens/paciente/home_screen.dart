import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'dieta_screen.dart';
import 'compras_screen.dart';
import 'evolucao_paciente_screen.dart'; // tela correta do paciente
import '../clinico/analise_rotulo_screen.dart';
import '../clinico/analise_refeicao_screen.dart';
import 'perfil_screen.dart';
import 'laudo_evolutivo_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String nomeCompleto;
  final String email;

  const HomeScreen({
    super.key,
    required this.nomeCompleto,
    required this.email,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String get _primeiroNome {
    final partes = widget.nomeCompleto.trim().split(' ');
    return partes.isNotEmpty ? partes[0] : "Ola";
  }

  String get _saudacao {
    final hora = DateTime.now().hour;
    if (hora < 12) return "Bom dia";
    if (hora < 18) return "Boa tarde";
    return "Boa noite";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(""),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.roseEscuro),
      ),
      drawer: _buildMenuLateral(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kToolbarHeight + 40),

              Text(
                _saudacao.toUpperCase(),
                style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: AppColors.textoSuave),
              ),
              Text(
                _primeiroNome,
                style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w300,
                    color: AppColors.roseEscuro),
              ),

              const SizedBox(height: 40),

              const Text(
                "FERRAMENTAS E PLANO",
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: AppColors.textoSuave),
              ),
              const SizedBox(height: 20),

              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  _buildCard(context, "SCANNER REFEICAO",
                      Icons.camera_alt_outlined,
                      const AnaliseRefeicaoScreen()),
                  _buildCard(context, "SCANNER ROTULO",
                      Icons.qr_code_scanner,
                      const AnaliseRotuloScreen()),
                  _buildCard(context, "MEU PLANO",
                      Icons.restaurant_outlined,
                      const DietaScreen()),
                  _buildCard(context, "LISTA DE COMPRAS",
                      Icons.shopping_bag_outlined,
                      const ComprasScreen()),
                  _buildCard(context, "EVOLUCAO",
                      Icons.show_chart,
                      const EvolucaoPacienteScreen()), // tela correta
                  _buildCard(context, "EXAMES",
                      Icons.assignment_outlined,
                      const LaudoEvolutivoScreen()),
                  _buildCard(context, "PERFIL",
                      Icons.person_outline,
                      const PerfilScreen()),
                ],
              ),

              const SizedBox(height: 40),

              Center(
                child: Text(
                  "by Eduarda Nogueira",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.roseEscuro.withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String titulo, IconData icone,
      Widget tela) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (c) => tela)),
      child: Container(
        width: 150,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 28, color: AppColors.roseGold),
            const SizedBox(height: 10),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
                letterSpacing: 0.5,
                color: AppColors.textoPrincipal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuLateral(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.fundo,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.roseEscuro),
              accountName: Text(
                widget.nomeCompleto.toUpperCase(),
                style: const TextStyle(
                    letterSpacing: 1, fontWeight: FontWeight.w600),
              ),
              accountEmail: Text(widget.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white24,
                child: Text(
                  widget.nomeCompleto
                      .trim()
                      .split(' ')
                      .map((p) => p.isNotEmpty ? p[0] : '')
                      .take(2)
                      .join(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _itemMenu(context, Icons.home_outlined, "INICIO", null),
                  _itemMenu(context, Icons.camera_alt_outlined,
                      "SCANNER DE REFEICAO",
                      const AnaliseRefeicaoScreen()),
                  _itemMenu(context, Icons.qr_code_scanner,
                      "SCANNER DE ROTULO",
                      const AnaliseRotuloScreen()),
                  _itemMenu(context, Icons.restaurant_outlined, "MEU PLANO",
                      const DietaScreen()),
                  _itemMenu(context, Icons.shopping_bag_outlined,
                      "LISTA DE COMPRAS",
                      const ComprasScreen()),
                  _itemMenu(context, Icons.show_chart, "EVOLUCAO",
                      const EvolucaoPacienteScreen()),
                  _itemMenu(context, Icons.assignment_outlined, "EXAMES",
                      const LaudoEvolutivoScreen()),
                  _itemMenu(context, Icons.person_outline, "PERFIL",
                      const PerfilScreen()),
                ],
              ),
            ),
            const Divider(color: AppColors.champanhe),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.erro),
              title: const Text("SAIR",
                  style: TextStyle(
                      color: AppColors.erro, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => const LoginScreen()),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _itemMenu(BuildContext context, IconData icone, String titulo,
      Widget? tela) {
    return ListTile(
      leading: Icon(icone, color: AppColors.roseGold),
      title: Text(
        titulo,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textoPrincipal),
      ),
      onTap: () {
        Navigator.pop(context);
        if (tela != null)
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => tela));
      },
    );
  }
}