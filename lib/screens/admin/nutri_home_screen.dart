import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../auth/login_screen.dart';
import 'pacientes_screen.dart';
import 'exames_nutri_screen.dart';
import 'criar_dieta_screen.dart';
import 'perfil_paciente_detalhe_screen.dart';

class NutriHomeScreen extends StatelessWidget {
  const NutriHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      // O Drawer cria automaticamente o ícone de menu "hambúrguer" no AppBar
      drawer: Drawer(
        child: Container(
          color: AppColors.fundo,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.roseGold, AppColors.roseEscuro],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "NUTRI APP",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 3,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Painel da Nutricionista",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _buildMenuItem(
                context,
                icon: Icons.people_outline,
                title: "Meus Pacientes",
                tela: const PacientesScreen(),
              ),
              _buildMenuItem(
                context,
                icon: Icons.restaurant_menu,
                title: "Criar Dieta",
                tela: const CriarDietaScreen(),
              ),
              _buildMenuItem(
                context,
                icon: Icons.science_outlined,
                title: "Lançar Exames",
                tela: const ExamesNutriScreen(),
              ),
              _buildMenuItem(
                context,
                icon: Icons.person_search_outlined,
                title: "Perfil do Paciente",
                // Passando o paciente vazio para evitar o erro de parâmetro obrigatório
                tela: const PerfilPacienteDetalheScreen(paciente: {}),
              ),
              const Divider(color: AppColors.champanhe, indent: 20, endIndent: 20),
              _buildMenuItem(
                context,
                icon: Icons.logout,
                title: "Sair do Sistema",
                color: AppColors.erro,
                tela: const LoginScreen(),
                isReplacement: true,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // Ícone do menu aparece aqui automaticamente
        iconTheme: const IconThemeData(color: AppColors.textoPrincipal),
        title: const Text(
          "MEU CONSULTÓRIO",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            fontSize: 13,
            color: AppColors.textoPrincipal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho de Boas-vindas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.roseGold, AppColors.roseEscuro],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Olá, Eduarda!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Bem-vinda ao seu painel de controle.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStat("0", "Pacientes"),
                      const SizedBox(width: 12),
                      _buildStat("0", "Consultas hoje"),
                      const SizedBox(width: 12),
                      _buildStat("0", "Planos ativos"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "FERRAMENTAS CLÍNICAS",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.textoSuave,
              ),
            ),

            const SizedBox(height: 16),

            // Grid de ferramentas
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.2,
              children: [
                _buildCard(
                  context,
                  icone: Icons.people_outline,
                  titulo: "Meus Pacientes",
                  subtitulo: "Ver e gerenciar",
                  tela: const PacientesScreen(),
                ),
                _buildCard(
                  context,
                  icone: Icons.restaurant_menu,
                  titulo: "Criar Dieta",
                  subtitulo: "Montar plano",
                  tela: const CriarDietaScreen(),
                ),
                _buildCard(
                  context,
                  icone: Icons.science_outlined,
                  titulo: "Lançar Exames",
                  subtitulo: "Laboratorial",
                  tela: const ExamesNutriScreen(),
                ),
                _buildCard(
                  context,
                  icone: Icons.person_search_outlined,
                  titulo: "Perfil Paciente",
                  subtitulo: "Histórico",
                  tela: const PerfilPacienteDetalheScreen(paciente: {}),
                ),
              ],
            ),

            const SizedBox(height: 30),
            
            // Dicas rápidas
            const Text(
              "RESUMO DO DIA",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.textoSuave,
              ),
            ),
            const SizedBox(height: 16),
            _buildDica(
              Icons.lightbulb_outline,
              "Cadastre seus pacientes para habilitar a criação de dietas personalizadas.",
            ),
          ],
        ),
      ),
    );
  }

  // --- Funções Auxiliares de Construção ---

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required Widget tela,
      Color color = AppColors.textoPrincipal,
      bool isReplacement = false}) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        title,
        style: TextStyle(color: color, fontSize: 14),
      ),
      onTap: () {
        Navigator.pop(context); // Fecha o Drawer antes de navegar
        if (isReplacement) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => tela));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
        }
      },
    );
  }

  Widget _buildStat(String valor, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(valor,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required IconData icone,
      required String titulo,
      required String subtitulo,
      required Widget tela}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => tela)),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.champanhe),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, color: AppColors.roseGold, size: 24),
            const SizedBox(height: 12),
            Text(titulo,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textoPrincipal)),
            Text(subtitulo,
                style: const TextStyle(fontSize: 10, color: AppColors.textoSuave)),
          ],
        ),
      ),
    );
  }

  Widget _buildDica(IconData icone, String texto) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.champanhe),
      ),
      child: Row(
        children: [
          Icon(icone, color: AppColors.roseGold, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(texto,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textoPrincipal, height: 1.5)),
          ),
        ],
      ),
    );
  }
}