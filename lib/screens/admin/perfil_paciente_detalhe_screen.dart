import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'exames_nutri_screen.dart';
import 'criar_dieta_screen.dart';

class PerfilPacienteDetalheScreen extends StatelessWidget {
  final Map<String, dynamic> paciente;

  const PerfilPacienteDetalheScreen({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textoPrincipal),
        title: const Text(
          "PRONTUARIO",
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
            // Card do paciente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.champanhe),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        AppColors.roseGold.withValues(alpha: 0.15),
                    child: Text(
                      paciente['nome'].toString()[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.roseGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paciente['nome'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textoPrincipal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          paciente['email'],
                          style: const TextStyle(
                              color: AppColors.textoSuave, fontSize: 12),
                        ),
                        Text(
                          paciente['telefone'],
                          style: const TextStyle(
                              color: AppColors.textoSuave, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                AppColors.roseGold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            paciente['objetivo'].isNotEmpty
                                ? paciente['objetivo']
                                : "Sem objetivo",
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.roseEscuro,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "FERRAMENTAS CLINICAS",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.textoSuave,
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _buildAcao(
                  context,
                  icone: Icons.restaurant_menu,
                  titulo: "Plano\nAlimentar",
                  tela: CriarDietaScreen(paciente: paciente),
                ),
                _buildAcao(
                  context,
                  icone: Icons.science_outlined,
                  titulo: "Lancar\nExames",
                  tela: ExamesNutriScreen(paciente: paciente),
                ),
                _buildAcao(
                  context,
                  icone: Icons.show_chart,
                  titulo: "Evolucao\nCorporal",
                  tela: null,
                ),
                _buildAcao(
                  context,
                  icone: Icons.assignment_outlined,
                  titulo: "Ficha de\nAnamnese",
                  tela: null,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Info rapida
            const Text(
              "INFORMACOES",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.textoSuave,
              ),
            ),
            const SizedBox(height: 12),

            _buildInfo("Sexo", paciente['sexo']),
            _buildInfo("Cadastrado em", paciente['dataCadastro']),
            _buildInfo(
                "Planos alimentares",
                "${(paciente['dieta'] as List).length} criado(s)"),
          ],
        ),
      ),
    );
  }

  Widget _buildAcao(BuildContext context,
      {required IconData icone,
      required String titulo,
      required Widget? tela}) {
    return GestureDetector(
      onTap: tela != null
          ? () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => tela))
          : null,
      child: Container(
        width: 150,
        height: 130,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tela != null ? Colors.white : AppColors.fundo,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.champanhe),
          boxShadow: tela != null
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.roseGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icone,
                  color: tela != null
                      ? AppColors.roseGold
                      : AppColors.textoSuave,
                  size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: tela != null
                    ? AppColors.textoPrincipal
                    : AppColors.textoSuave,
              ),
            ),
            if (tela == null)
              const Text(
                "Em breve",
                style: TextStyle(fontSize: 10, color: AppColors.textoSuave),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String valor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.champanhe),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textoSuave, fontSize: 13)),
          Text(valor,
              style: const TextStyle(
                  color: AppColors.textoPrincipal,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}