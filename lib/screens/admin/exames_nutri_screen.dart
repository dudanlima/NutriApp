import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_colors.dart';

class ExamesNutriScreen extends StatefulWidget {
  final Map<String, dynamic>? paciente;

  const ExamesNutriScreen({super.key, this.paciente});

  @override
  State<ExamesNutriScreen> createState() => _ExamesNutriScreenState();
}

class _ExamesNutriScreenState extends State<ExamesNutriScreen> {
  static const String _apiKey = 'AIzaSyCXjIWyFRqSwQomeHR60yl2qakb0KhOLwo';
  bool _analisandoIA = false;

  final List<Map<String, dynamic>> _exames = [
    // HEMOGRAMA
    {"categoria": "HEMOGRAMA", "nome": "Hemoglobina", "unidade": "g/dL", "refMin": 12.0, "refMax": 16.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "HEMOGRAMA", "nome": "Hematocrito", "unidade": "%", "refMin": 36.0, "refMax": 46.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "HEMOGRAMA", "nome": "Leucocitos", "unidade": "mil/mm3", "refMin": 4.0, "refMax": 11.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "HEMOGRAMA", "nome": "Plaquetas", "unidade": "mil/mm3", "refMin": 150.0, "refMax": 400.0, "ctrl": TextEditingController(), "resultado": null},
    // GLICEMIA
    {"categoria": "GLICEMIA", "nome": "Glicose em Jejum", "unidade": "mg/dL", "refMin": 70.0, "refMax": 99.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "GLICEMIA", "nome": "Insulina em Jejum", "unidade": "uU/mL", "refMin": 2.0, "refMax": 25.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "GLICEMIA", "nome": "Hemoglobina Glicada HbA1c", "unidade": "%", "refMin": 4.0, "refMax": 5.7, "ctrl": TextEditingController(), "resultado": null},
    // LIPIDIOS
    {"categoria": "PERFIL LIPIDICO", "nome": "Colesterol Total", "unidade": "mg/dL", "refMin": 0.0, "refMax": 190.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "PERFIL LIPIDICO", "nome": "HDL", "unidade": "mg/dL", "refMin": 50.0, "refMax": 999.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "PERFIL LIPIDICO", "nome": "LDL", "unidade": "mg/dL", "refMin": 0.0, "refMax": 130.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "PERFIL LIPIDICO", "nome": "Triglicerideos", "unidade": "mg/dL", "refMin": 0.0, "refMax": 150.0, "ctrl": TextEditingController(), "resultado": null},
    // HEPATICOS
    {"categoria": "FUNCAO HEPATICA", "nome": "TGO (AST)", "unidade": "U/L", "refMin": 0.0, "refMax": 40.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "FUNCAO HEPATICA", "nome": "TGP (ALT)", "unidade": "U/L", "refMin": 0.0, "refMax": 41.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "FUNCAO HEPATICA", "nome": "Gama GT", "unidade": "U/L", "refMin": 0.0, "refMax": 38.0, "ctrl": TextEditingController(), "resultado": null},
    // RENAIS
    {"categoria": "FUNCAO RENAL", "nome": "Ureia", "unidade": "mg/dL", "refMin": 15.0, "refMax": 45.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "FUNCAO RENAL", "nome": "Creatinina", "unidade": "mg/dL", "refMin": 0.5, "refMax": 1.1, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "FUNCAO RENAL", "nome": "Acido Urico", "unidade": "mg/dL", "refMin": 2.4, "refMax": 6.0, "ctrl": TextEditingController(), "resultado": null},
    // VITAMINAS
    {"categoria": "VITAMINAS E MINERAIS", "nome": "Vitamina D", "unidade": "ng/mL", "refMin": 30.0, "refMax": 100.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "VITAMINAS E MINERAIS", "nome": "Vitamina B12", "unidade": "pg/mL", "refMin": 200.0, "refMax": 900.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "VITAMINAS E MINERAIS", "nome": "Acido Folico", "unidade": "ng/mL", "refMin": 3.0, "refMax": 17.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "VITAMINAS E MINERAIS", "nome": "Ferro Serico", "unidade": "ug/dL", "refMin": 50.0, "refMax": 170.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "VITAMINAS E MINERAIS", "nome": "Ferritina", "unidade": "ng/mL", "refMin": 12.0, "refMax": 150.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "VITAMINAS E MINERAIS", "nome": "Zinco", "unidade": "ug/dL", "refMin": 70.0, "refMax": 120.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "VITAMINAS E MINERAIS", "nome": "Magnesio", "unidade": "mg/dL", "refMin": 1.6, "refMax": 2.6, "ctrl": TextEditingController(), "resultado": null},
    // TIREOIDE
    {"categoria": "TIREOIDE", "nome": "TSH", "unidade": "uUI/mL", "refMin": 0.4, "refMax": 4.0, "ctrl": TextEditingController(), "resultado": null},
    {"categoria": "TIREOIDE", "nome": "T4 Livre", "unidade": "ng/dL", "refMin": 0.8, "refMax": 1.8, "ctrl": TextEditingController(), "resultado": null},
    // INFLAMACAO
    {"categoria": "INFLAMACAO", "nome": "PCR Ultrassensivel", "unidade": "mg/L", "refMin": 0.0, "refMax": 1.0, "ctrl": TextEditingController(), "resultado": null},
  ];

  List<String> get _categorias {
    final cats = <String>[];
    for (final e in _exames) {
      if (!cats.contains(e['categoria'])) cats.add(e['categoria'] as String);
    }
    return cats;
  }

  Future<void> _analisarComIA() async {
    final preenchidos = _exames
        .where((e) => (e['ctrl'] as TextEditingController).text.trim().isNotEmpty)
        .toList();

    if (preenchidos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha ao menos um exame para analisar."),
          backgroundColor: AppColors.alerta,
        ),
      );
      return;
    }

    setState(() => _analisandoIA = true);

    final dados = preenchidos.map((e) => {
      "nome": e['nome'],
      "valor": (e['ctrl'] as TextEditingController).text.trim(),
      "unidade": e['unidade'],
      "refMin": e['refMin'],
      "refMax": e['refMax'],
    }).toList();

    final prompt =
        'Voce e uma nutricionista clinica avaliando exames laboratoriais. '
        'Paciente: ${widget.paciente?['nome'] ?? 'Paciente'}. '
        'Exames: ${jsonEncode(dados)}. '
        'Para cada exame retorne um JSON com: nome, status (normal/alto/baixo/atencao), '
        'corStatus (verde/vermelho/amarelo), valorIdeal, causasPossiveis, solucoes. '
        'Retorne APENAS a lista JSON sem markdown. '
        'Formato: [{"nome":"...","status":"...","corStatus":"...","valorIdeal":"...","causasPossiveis":"...","solucoes":"..."}]';

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey',
      );

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

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String texto =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        texto = texto.replaceAll('```json', '').replaceAll('```', '').trim();

        final List<dynamic> avaliacoes = jsonDecode(texto);

        setState(() {
          for (var av in avaliacoes) {
            final exame = _exames.firstWhere(
              (e) => e['nome'] == av['nome'],
              orElse: () => {},
            );
            if (exame.isNotEmpty) {
              exame['resultado'] = av;
            }
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao consultar a IA."),
          backgroundColor: AppColors.erro,
        ),
      );
    } finally {
      if (mounted) setState(() => _analisandoIA = false);
    }
  }

  Color _corDoStatus(String? cor) {
    switch (cor) {
      case 'verde':
        return const Color(0xFFE8F5E9);
      case 'vermelho':
        return const Color(0xFFFFEBEE);
      case 'amarelo':
        return const Color(0xFFFFF9C4);
      default:
        return Colors.white;
    }
  }

  Color _corTextoStatus(String? status) {
    switch (status) {
      case 'normal':
        return AppColors.sucesso;
      case 'alto':
        return AppColors.erro;
      case 'baixo':
        return const Color(0xFF1976D2);
      case 'atencao':
        return AppColors.alerta;
      default:
        return AppColors.textoSuave;
    }
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
              ? widget.paciente!['nome'].toString().split(' ').first.toUpperCase()
              : "EXAMES LABORATORIAIS",
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            fontSize: 13,
            color: AppColors.textoPrincipal,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ElevatedButton.icon(
              onPressed: _analisandoIA ? null : _analisarComIA,
              icon: _analisandoIA
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome),
              label: Text(
                  _analisandoIA ? "ANALISANDO..." : "ANALISAR COM IA"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.roseGold,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: _categorias.map((cat) {
                final examesDaCat =
                    _exames.where((e) => e['categoria'] == cat).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 6),
                      child: Text(
                        cat,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: AppColors.roseEscuro,
                        ),
                      ),
                    ),
                    ...examesDaCat.map((exame) {
                      final resultado = exame['resultado'] as Map?;
                      final ctrl = exame['ctrl'] as TextEditingController;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: resultado != null
                              ? _corDoStatus(resultado['corStatus'])
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.champanhe),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    exame['nome'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.textoPrincipal,
                                    ),
                                  ),
                                ),
                                if (resultado != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _corTextoStatus(
                                              resultado['status'])
                                          .withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      resultado['status']
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: _corTextoStatus(
                                            resultado['status']),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: ctrl,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: "Resultado",
                                      hintStyle: const TextStyle(
                                          color: Colors.black26,
                                          fontSize: 12),
                                      isDense: true,
                                      enabledBorder:
                                          const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black12)),
                                      focusedBorder:
                                          const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      AppColors.roseGold)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  exame['unidade'],
                                  style: const TextStyle(
                                      color: AppColors.textoSuave,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              "Ref: ${exame['refMin']} - ${exame['refMax'] == 999.0 ? '+' : exame['refMax']} ${exame['unidade']}",
                              style: const TextStyle(
                                  color: AppColors.textoSuave, fontSize: 10),
                            ),
                            if (resultado != null) ...[
                              const SizedBox(height: 10),
                              const Divider(height: 1, color: Colors.black12),
                              const SizedBox(height: 8),
                              Text(
                                "Ideal: ${resultado['valorIdeal']}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textoPrincipal,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Possiveis causas: ${resultado['causasPossiveis']}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textoPrincipal,
                                    height: 1.4),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Solucoes: ${resultado['solucoes']}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textoPrincipal,
                                    height: 1.4),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}