import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_colors.dart';

class CriarDietaScreen extends StatefulWidget {
  final Map<String, dynamic>? paciente;

  const CriarDietaScreen({super.key, this.paciente});

  @override
  State<CriarDietaScreen> createState() => _CriarDietaScreenState();
}

class _CriarDietaScreenState extends State<CriarDietaScreen> {
  static const String _apiKey = 'AIzaSyCXjIWyFRqSwQomeHR60yl2qakb0KhOLwo';

  final List<Map<String, dynamic>> _refeicoes = [];
  bool _calculandoMacros = false;

  // Controllers da nova refeicao
  final TextEditingController _nomeRefeicaoCtrl = TextEditingController();
  final TextEditingController _horaCtrl = TextEditingController();
  final TextEditingController _calCtrl = TextEditingController();
  final TextEditingController _protCtrl = TextEditingController();
  final TextEditingController _carbCtrl = TextEditingController();
  final TextEditingController _gordCtrl = TextEditingController();
  final List<TextEditingController> _alimentosCtrl = [];

  // Etiquetas disponiveis
  final List<String> _etiquetasDisponiveis = [
    "Sem Gluten",
    "Sem Lactose",
    "Vegetariano",
    "Vegano",
  ];
  final List<String> _etiquetasSelecionadas = [];

  // Icones por nome de refeicao
  IconData _iconeParaRefeicao(String nome) {
    final n = nome.toLowerCase();
    if (n.contains("cafe") || n.contains("manha")) return Icons.wb_sunny_outlined;
    if (n.contains("almoco")) return Icons.restaurant_outlined;
    if (n.contains("jantar")) return Icons.nights_stay_outlined;
    if (n.contains("lanche")) return Icons.coffee_outlined;
    return Icons.restaurant_menu_outlined;
  }

  Future<void> _calcularMacrosIA(StateSetter setModalState) async {
    final itens = _alimentosCtrl
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (itens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Adicione ao menos um alimento."),
          backgroundColor: AppColors.alerta,
        ),
      );
      return;
    }

    setModalState(() => _calculandoMacros = true);

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey',
      );

      final prompt =
          'Calcule os macros totais desta refeicao: ${itens.join(', ')}. '
          'Responda APENAS 4 numeros separados por virgula: kcal, proteina(g), carbo(g), gordura(g). '
          'Sem texto. Exemplo: 350, 25, 40, 10';

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final texto =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        final valores = texto.trim().split(',');

        if (valores.length >= 4) {
          setModalState(() {
            _calCtrl.text = valores[0].trim();
            _protCtrl.text = valores[1].trim();
            _carbCtrl.text = valores[2].trim();
            _gordCtrl.text = valores[3].trim();
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao calcular com IA."),
          backgroundColor: AppColors.erro,
        ),
      );
    } finally {
      setModalState(() => _calculandoMacros = false);
    }
  }

  void _abrirModalRefeicao() {
    _nomeRefeicaoCtrl.clear();
    _horaCtrl.clear();
    _calCtrl.clear();
    _protCtrl.clear();
    _carbCtrl.clear();
    _gordCtrl.clear();
    _alimentosCtrl.clear();
    _alimentosCtrl.add(TextEditingController());
    _etiquetasSelecionadas.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 22,
            right: 22,
            top: 22,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.champanhe,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "NOVA REFEICAO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: AppColors.roseEscuro,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),

                // Nome e hora
                Row(
                  children: [
                    Expanded(child: _campo("Nome (ex: Almoco)", _nomeRefeicaoCtrl)),
                    const SizedBox(width: 16),
                    Expanded(child: _campo("Hora (ex: 12:30)", _horaCtrl)),
                  ],
                ),
                const SizedBox(height: 20),

                // Alimentos
                const Text(
                  "ALIMENTOS",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: AppColors.textoSuave,
                  ),
                ),
                const SizedBox(height: 10),

                ...List.generate(_alimentosCtrl.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 16, color: AppColors.roseGold),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _alimentosCtrl[i],
                            style: const TextStyle(fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: "Ex: 150g de frango grelhado",
                              hintStyle: TextStyle(
                                  color: Colors.black26, fontSize: 12),
                              isDense: true,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.champanhe)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                TextButton.icon(
                  onPressed: () {
                    setModalState(() =>
                        _alimentosCtrl.add(TextEditingController()));
                  },
                  icon: const Icon(Icons.add_circle_outline,
                      color: AppColors.roseGold, size: 18),
                  label: const Text("Adicionar alimento",
                      style: TextStyle(color: AppColors.roseGold)),
                ),

                const SizedBox(height: 16),

                // Etiquetas
                const Text(
                  "ETIQUETAS",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: AppColors.textoSuave,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _etiquetasDisponiveis.map((e) {
                    final sel = _etiquetasSelecionadas.contains(e);
                    return GestureDetector(
                      onTap: () => setModalState(() {
                        sel
                            ? _etiquetasSelecionadas.remove(e)
                            : _etiquetasSelecionadas.add(e);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppColors.roseGold
                              : AppColors.champanhe.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : AppColors.textoSuave,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Botao calcular IA
                OutlinedButton.icon(
                  onPressed: _calculandoMacros
                      ? null
                      : () => _calcularMacrosIA(setModalState),
                  icon: _calculandoMacros
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.roseGold))
                      : const Icon(Icons.auto_awesome,
                          color: AppColors.roseGold),
                  label: Text(
                    _calculandoMacros
                        ? "Calculando..."
                        : "Calcular macros com IA",
                    style: const TextStyle(color: AppColors.roseGold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.roseGold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 16),

                // Macros
                Row(
                  children: [
                    Expanded(child: _campoNum("Kcal", _calCtrl)),
                    const SizedBox(width: 10),
                    Expanded(child: _campoNum("Prot g", _protCtrl)),
                    const SizedBox(width: 10),
                    Expanded(child: _campoNum("Carb g", _carbCtrl)),
                    const SizedBox(width: 10),
                    Expanded(child: _campoNum("Gord g", _gordCtrl)),
                  ],
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    if (_nomeRefeicaoCtrl.text.isEmpty) return;
                    setState(() {
                      _refeicoes.add({
                        "refeicao": _nomeRefeicaoCtrl.text.trim(),
                        "hora": _horaCtrl.text.trim(),
                        "icone": _iconeParaRefeicao(_nomeRefeicaoCtrl.text),
                        "prato": _alimentosCtrl
                            .map((c) => c.text.trim())
                            .where((t) => t.isNotEmpty)
                            .join(", "),
                        "descricao": _alimentosCtrl
                            .map((c) => c.text.trim())
                            .where((t) => t.isNotEmpty)
                            .join(", "),
                        "calorias": "${_calCtrl.text.isNotEmpty ? _calCtrl.text : '0'} kcal",
                        "proteina": "${_protCtrl.text.isNotEmpty ? _protCtrl.text : '0'}g",
                        "carbo": "${_carbCtrl.text.isNotEmpty ? _carbCtrl.text : '0'}g",
                        "gordura": "${_gordCtrl.text.isNotEmpty ? _gordCtrl.text : '0'}g",
                        "etiquetas": List<String>.from(_etiquetasSelecionadas),
                      });
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.roseEscuro,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "SALVAR REFEICAO",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style:
          const TextStyle(fontSize: 14, color: AppColors.textoPrincipal),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            const TextStyle(color: AppColors.textoSuave, fontSize: 12),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.champanhe)),
        focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.roseGold, width: 2)),
      ),
    );
  }

  Widget _campoNum(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      style:
          const TextStyle(fontSize: 13, color: AppColors.textoPrincipal),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            const TextStyle(color: AppColors.textoSuave, fontSize: 11),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.champanhe)),
        focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.roseGold, width: 2)),
      ),
    );
  }

  int get _totalCalorias {
    return _refeicoes.fold(0, (soma, r) {
      final cal =
          int.tryParse(r['calorias'].toString().replaceAll(' kcal', '')) ?? 0;
      return soma + cal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textoPrincipal),
        title: Text(
          widget.paciente != null
              ? "DIETA - ${widget.paciente!['nome'].toString().split(' ').first.toUpperCase()}"
              : "CRIAR DIETA",
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            fontSize: 12,
            color: AppColors.textoPrincipal,
          ),
        ),
      ),
      body: Column(
        children: [
          // Total de calorias
          if (_refeicoes.isNotEmpty)
            Container(
              width: double.infinity,
              color: AppColors.champanhe.withValues(alpha: 0.5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TOTAL DO DIA",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoSuave,
                    ),
                  ),
                  Text(
                    "$_totalCalorias kcal",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.roseEscuro,
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _refeicoes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 60,
                          color: AppColors.champanhe.withValues(alpha: 0.8),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Nenhuma refeicao adicionada.",
                          style: TextStyle(
                              color: AppColors.textoSuave, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Toque no + para comecar.",
                          style: TextStyle(
                              color: AppColors.textoSuave, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    itemCount: _refeicoes.length,
                    itemBuilder: (context, index) {
                      final r = _refeicoes[index];
                      final etiquetas =
                          (r['etiquetas'] as List<String>?) ?? [];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.champanhe),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.roseGold
                                        .withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    r['icone'] as IconData,
                                    color: AppColors.roseGold,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r['refeicao'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.roseGold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        r['hora'],
                                        style: const TextStyle(
                                            color: AppColors.textoSuave,
                                            fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.roseEscuro
                                        .withValues(alpha: 0.08),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    r['calorias'],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.roseEscuro,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: AppColors.erro, size: 18),
                                  onPressed: () => setState(
                                      () => _refeicoes.removeAt(index)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              r['descricao'],
                              style: const TextStyle(
                                  color: AppColors.textoSuave,
                                  fontSize: 12,
                                  height: 1.4),
                            ),
                            if (etiquetas.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                children: etiquetas
                                    .map((e) => Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.roseGold
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    20),
                                          ),
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.roseGold,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _macro("PROT", r['proteina'],
                                    AppColors.sucesso),
                                const SizedBox(width: 8),
                                _macro("CARB", r['carbo'],
                                    AppColors.alerta),
                                const SizedBox(width: 8),
                                _macro("GORD", r['gordura'],
                                    AppColors.roseGold),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Botoes de acao
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _abrirModalRefeicao,
                    icon: const Icon(Icons.add, color: AppColors.roseGold),
                    label: const Text("Adicionar",
                        style: TextStyle(color: AppColors.roseGold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.roseGold),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _refeicoes.isEmpty
                        ? null
                        : () {
                            // Aqui futuramente salva no Firebase e envia ao paciente
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Dieta salva e enviada ao paciente!"),
                                backgroundColor: AppColors.sucesso,
                              ),
                            );
                            Navigator.pop(context);
                          },
                    icon: const Icon(Icons.send_outlined),
                    label: const Text("Publicar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.roseGold,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macro(String label, String valor, Color cor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: cor,
                    letterSpacing: 1)),
            const SizedBox(height: 2),
            Text(valor,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, color: cor)),
          ],
        ),
      ),
    );
  }
}