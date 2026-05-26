import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AtividadeScreen extends StatefulWidget {
  const AtividadeScreen({super.key});

  @override
  State<AtividadeScreen> createState() => _AtividadeScreenState();
}

class _AtividadeScreenState extends State<AtividadeScreen> {
  final TextEditingController _atividadeController = TextEditingController();
  final TextEditingController _duracaoController = TextEditingController();
  String? _tipoSelecionado;
  String? _intensidadeSelecionada;
  String? _erro;
  bool _registroSalvo = false;

  final List<String> _tipos = [
    "Caminhada",
    "Corrida",
    "Musculacao",
    "Pilates",
    "Yoga",
    "Natacao",
    "Ciclismo",
    "Danca",
    "Outro",
  ];

  final List<String> _intensidades = ["Leve", "Moderada", "Intensa"];

  final List<Map<String, dynamic>> _registros = [
    {
      "atividade": "Caminhada",
      "tipo": "Caminhada",
      "duracao": 40,
      "intensidade": "Moderada",
      "data": "Ontem",
      "calorias": 180,
    },
    {
      "atividade": "Musculacao",
      "tipo": "Musculacao",
      "duracao": 60,
      "intensidade": "Intensa",
      "data": "Seg",
      "calorias": 320,
    },
    {
      "atividade": "Yoga",
      "tipo": "Yoga",
      "duracao": 45,
      "intensidade": "Leve",
      "data": "Dom",
      "calorias": 140,
    },
  ];

  // Meta semanal em minutos
  static const int _metaMinutos = 150;

  int get _minutosSemanais =>
      _registros.fold(0, (soma, r) => soma + (r['duracao'] as int));

  int get _caloriasSemanais =>
      _registros.fold(0, (soma, r) => soma + (r['calorias'] as int));

  @override
  void dispose() {
    _atividadeController.dispose();
    _duracaoController.dispose();
    super.dispose();
  }

  void _registrarAtividade() {
    setState(() {
      _erro = null;
      _registroSalvo = false;
    });

    if (_tipoSelecionado == null) {
      setState(() => _erro = "Selecione o tipo de atividade.");
      return;
    }

    final duracaoTexto = _duracaoController.text.trim();
    final duracao = int.tryParse(duracaoTexto);

    if (duracaoTexto.isEmpty || duracao == null || duracao < 1 || duracao > 600) {
      setState(() => _erro = "Digite uma duracao valida em minutos.");
      return;
    }

    if (_intensidadeSelecionada == null) {
      setState(() => _erro = "Selecione a intensidade.");
      return;
    }

    // Estimativa simples de calorias
    final Map<String, int> calPorMinuto = {
      "Leve": 4,
      "Moderada": 6,
      "Intensa": 9,
    };
    final calorias = duracao * (calPorMinuto[_intensidadeSelecionada] ?? 5);

    setState(() {
      _registros.insert(0, {
        "atividade": _tipoSelecionado,
        "tipo": _tipoSelecionado,
        "duracao": duracao,
        "intensidade": _intensidadeSelecionada,
        "data": "Hoje",
        "calorias": calorias,
      });
      _tipoSelecionado = null;
      _intensidadeSelecionada = null;
      _duracaoController.clear();
      _registroSalvo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progresso = (_minutosSemanais / _metaMinutos).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textoPrincipal),
        title: const Text(
          "ATIVIDADE FISICA",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            fontSize: 15,
            color: AppColors.textoPrincipal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Resumo semanal ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.roseGold, AppColors.roseEscuro],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "RESUMO DA SEMANA",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatCard("$_minutosSemanais min", "Ativo"),
                      const SizedBox(width: 12),
                      _buildStatCard("$_caloriasSemanais kcal", "Queimadas"),
                      const SizedBox(width: 12),
                      _buildStatCard("${_registros.length}", "Treinos"),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Barra de progresso da meta
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "META SEMANAL",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                letterSpacing: 1),
                          ),
                          Text(
                            "$_minutosSemanais / $_metaMinutos min",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progresso,
                          backgroundColor: Colors.white24,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        progresso >= 1.0
                            ? "Meta atingida! Parabens!"
                            : "${(_metaMinutos - _minutosSemanais)} min para atingir a meta",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Registrar atividade ──
            const Text(
              "REGISTRAR ATIVIDADE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.5,
                color: AppColors.roseEscuro,
              ),
            ),
            const SizedBox(height: 16),

            // Tipo de atividade
            const Text(
              "Tipo",
              style: TextStyle(fontSize: 11, color: AppColors.textoSuave, letterSpacing: 1),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tipos.map((tipo) {
                final selecionado = _tipoSelecionado == tipo;
                return GestureDetector(
                  onTap: () => setState(() {
                    _tipoSelecionado = tipo;
                    _erro = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selecionado ? AppColors.roseGold : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selecionado
                            ? AppColors.roseGold
                            : AppColors.champanhe,
                      ),
                    ),
                    child: Text(
                      tipo,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selecionado
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selecionado
                            ? Colors.white
                            : AppColors.textoPrincipal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Duracao
            const Text(
              "Duracao (minutos)",
              style: TextStyle(
                  fontSize: 11, color: AppColors.textoSuave, letterSpacing: 1),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _duracaoController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() => _erro = null),
              decoration: InputDecoration(
                hintText: "Ex: 45",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                suffixText: "min",
                suffixStyle: const TextStyle(
                    color: AppColors.roseGold, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.champanhe),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.roseGold, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Intensidade
            const Text(
              "Intensidade",
              style: TextStyle(
                  fontSize: 11, color: AppColors.textoSuave, letterSpacing: 1),
            ),
            const SizedBox(height: 10),
            Row(
              children: _intensidades.map((intensidade) {
                final selecionada = _intensidadeSelecionada == intensidade;
                final Map<String, Color> cores = {
                  "Leve": AppColors.sucesso,
                  "Moderada": AppColors.alerta,
                  "Intensa": AppColors.erro,
                };
                final cor = cores[intensidade] ?? AppColors.roseGold;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _intensidadeSelecionada = intensidade;
                      _erro = null;
                    }),
                    child: Container(
                      margin: EdgeInsets.only(
                          right: intensidade != "Intensa" ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selecionada
                            ? cor.withValues(alpha: 0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              selecionada ? cor : AppColors.champanhe,
                          width: selecionada ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            intensidade == "Leve"
                                ? Icons.directions_walk
                                : intensidade == "Moderada"
                                    ? Icons.directions_run
                                    : Icons.local_fire_department,
                            color: selecionada ? cor : AppColors.textoSuave,
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            intensidade,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: selecionada
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  selecionada ? cor : AppColors.textoSuave,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Erro
            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.erro.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.erro.withValues(alpha: 0.4)),
                  ),
                  child: Text(_erro!,
                      style: const TextStyle(
                          color: AppColors.roseEscuro, fontSize: 13)),
                ),
              ),

            // Sucesso
            if (_registroSalvo)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.sucesso.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.sucesso.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: AppColors.sucesso, size: 18),
                      SizedBox(width: 10),
                      Text(
                        "Atividade registrada!",
                        style: TextStyle(
                            color: AppColors.sucesso,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Botao registrar
            ElevatedButton.icon(
              onPressed: _registrarAtividade,
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text(
                "REGISTRAR TREINO",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.roseGold,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),

            const SizedBox(height: 30),

            // Historico
            const Text(
              "HISTORICO DE TREINOS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.5,
                color: AppColors.roseEscuro,
              ),
            ),
            const SizedBox(height: 14),

            ..._registros.map((r) => _buildItemTreino(r)),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String valor, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTreino(Map<String, dynamic> r) {
    final Map<String, IconData> icones = {
      "Caminhada": Icons.directions_walk,
      "Corrida": Icons.directions_run,
      "Musculacao": Icons.fitness_center,
      "Pilates": Icons.self_improvement,
      "Yoga": Icons.self_improvement,
      "Natacao": Icons.pool,
      "Ciclismo": Icons.directions_bike,
      "Danca": Icons.music_note_outlined,
      "Outro": Icons.sports_outlined,
    };

    final Map<String, Color> coresIntensidade = {
      "Leve": AppColors.sucesso,
      "Moderada": AppColors.alerta,
      "Intensa": AppColors.erro,
    };

    final icone = icones[r['tipo']] ?? Icons.sports_outlined;
    final corIntensidade =
        coresIntensidade[r['intensidade']] ?? AppColors.roseGold;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.champanhe),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.roseGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icone, color: AppColors.roseGold, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r['atividade'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textoPrincipal,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${r['duracao']} min",
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textoSuave),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: corIntensidade.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        r['intensidade'] as String,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: corIntensidade),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                r['data'] as String,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textoSuave),
              ),
              const SizedBox(height: 4),
              Text(
                "${r['calorias']} kcal",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.roseEscuro,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}