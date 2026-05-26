import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../theme/app_colors.dart';

class DietaScreen extends StatefulWidget {
  const DietaScreen({super.key});

  @override
  State<DietaScreen> createState() => _DietaScreenState();
}

class _DietaScreenState extends State<DietaScreen> {
  // Lista limpa para novos cadastros
  final List<Map<String, dynamic>> _dieta = []; 

  final Map<String, String> _substituicoesItem = {};
  final Map<String, bool> _carregandoItem = {};
  final String _apiKey = 'AIzaSyB-f-RjrEHJgr_3B738ft0BbE7tgu3zRtU';

  Future<void> _buscarSubstituicaoItem(int refIndex, int itemIndex) async {
    if (_dieta.isEmpty) return;
    
    final refeicao = _dieta[refIndex];
    final itemAlvo = (refeicao['itens'] as List<String>)[itemIndex];
    final key = "${refIndex}_$itemIndex";

    setState(() => _carregandoItem[key] = true);

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );

      final prompt = '''
Você é uma nutricionista auxiliando seu paciente.
Sugira 2 opções de substituição para: "$itemAlvo".
Mantenha calorias e macronutrientes semelhantes.
Responda de forma direta:
Opção 1: [Alimento e quantidade]
Opção 2: [Alimento e quantidade]
Não use asteriscos nem formatação especial.
''';

      final response = await model.generateContent([Content.text(prompt)]);
      
      if (!mounted) return;

      setState(() {
        // Remove qualquer formatação indesejada que cause erro na tela
        _substituicoesItem[key] = response.text?.replaceAll('*', '').trim() ?? "Sugestão indisponível.";
        _carregandoItem[key] = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _substituicoesItem[key] = "Falha na conexão. Tente novamente.";
        _carregandoItem[key] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text(
          "MEU PLANO ALIMENTAR",
          style: TextStyle(fontWeight: FontWeight.w300, letterSpacing: 2, fontSize: 13, color: AppColors.textoPrincipal),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textoPrincipal),
      ),
      body: _dieta.isEmpty 
        ? const Center(child: Text("Nenhum plano alimentar cadastrado.", style: TextStyle(color: AppColors.textoSuave)))
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _dieta.length,
            itemBuilder: (context, index) => _buildCardRefeicao(index),
          ),
    );
  }

  Widget _buildCardRefeicao(int index) {
    final r = _dieta[index];
    final itens = r['itens'] as List<String>;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.champanhe),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(r['refeicao'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.roseGold, letterSpacing: 1.2)),
                Text(r['calorias'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.roseEscuro)),
              ],
            ),
            const SizedBox(height: 10),
            Text(r['prato'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            ...itens.asMap().entries.map((entry) {
              int itemIndex = entry.key;
              String key = "${index}_$itemIndex";
              bool estaCarregando = _carregandoItem[key] == true;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.check_circle_outline, size: 16, color: AppColors.roseGold),
                    title: Text(entry.value, style: const TextStyle(fontSize: 13)),
                    trailing: IconButton(
                      icon: estaCarregando 
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.autorenew_rounded, size: 18, color: AppColors.roseGold),
                      onPressed: estaCarregando ? null : () => _buscarSubstituicaoItem(index, itemIndex),
                    ),
                  ),
                  if (_substituicoesItem.containsKey(key))
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(color: AppColors.roseGold.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("SUGESTÕES DE SUBSTITUIÇÃO", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.roseEscuro)),
                          const SizedBox(height: 5),
                          Text(_substituicoesItem[key]!, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}