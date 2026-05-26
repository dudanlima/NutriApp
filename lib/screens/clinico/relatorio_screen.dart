import 'package:flutter/material.dart';
import '../../theme/app_colors.dart'; // Importando sua paleta luxury

class RelatorioScreen extends StatelessWidget {
  const RelatorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text(
          "BUSINESS ANALYTICS", 
          style: TextStyle(fontWeight: FontWeight.w300, letterSpacing: 3, fontSize: 14)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textoPrincipal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "RESUMO DA SEMANA",
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold, 
                letterSpacing: 1.5,
                color: AppColors.roseEscuro
              ),
            ),
            const SizedBox(height: 20),
            
            // Cards de métricas em Rosé e Branco
            Row(
              children: [
                _buildStatCard("PACIENTES ATIVOS", "24", AppColors.roseGold),
                const SizedBox(width: 15),
                _buildStatCard("METAS GERAIS", "85%", AppColors.sucesso),
              ],
            ),
            
            const SizedBox(height: 40),
            
            const Text(
              "ADESÃO POR CATEGORIA",
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold, 
                letterSpacing: 1.5,
                color: AppColors.textoSuave
              ),
            ),
            const SizedBox(height: 25),

            // Lista de Desempenho com cores da paleta
            _buildReportItem("Hidratação Consciente", 0.8, AppColors.roseGold),
            _buildReportItem("Adesão ao Protocolo", 0.65, AppColors.alerta),
            _buildReportItem("Performance Física", 0.4, AppColors.erro),
            
            const SizedBox(height: 50),
            
            // Botão de Exportação Rosé Gold
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.roseGold,
                    content: Text("Relatório gerado com elegância."),
                  ),
                );
              },
              icon: const Icon(Icons.ios_share_rounded, size: 20),
              label: const Text("EXPORTAR PDF PREMIUM", style: TextStyle(letterSpacing: 1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.roseGold,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String valor, Color cor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02), 
              blurRadius: 20, 
              offset: const Offset(0, 10)
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              label, 
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textoSuave, fontSize: 10, letterSpacing: 1)
            ),
            const SizedBox(height: 10),
            Text(
              valor, 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: cor)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(String titulo, double progresso, Color cor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo, 
                style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.textoPrincipal, fontSize: 14)
              ),
              Text(
                "${(progresso * 100).toInt()}%", 
                style: TextStyle(color: cor, fontWeight: FontWeight.bold, fontSize: 14)
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progresso mais fina e elegante
          LinearProgressIndicator(
            value: progresso,
            backgroundColor: AppColors.champanhe,
            color: cor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}