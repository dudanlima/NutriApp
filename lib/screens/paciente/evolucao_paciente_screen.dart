import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class EvolucaoPacienteScreen extends StatefulWidget {
  const EvolucaoPacienteScreen({super.key});

  @override
  State<EvolucaoPacienteScreen> createState() => _EvolucaoPacienteScreenState();
}

class _EvolucaoPacienteScreenState extends State<EvolucaoPacienteScreen> {
  final TextEditingController _pesoController = TextEditingController();

  final List<Map<String, dynamic>> _registros = [];

  String? _erro;
  bool _registroSalvo = false;

  double get _pesoInicial => _registros.first['peso'] as double;
  double get _pesoAtual => _registros.last['peso'] as double;
  double get _totalPerdido => _pesoInicial - _pesoAtual;

  @override
  void dispose() {
    _pesoController.dispose();
    super.dispose();
  }

  void _salvarPeso() {
    final texto = _pesoController.text.trim().replaceAll(',', '.');
    final peso = double.tryParse(texto);

    setState(() {
      _erro = null;
      _registroSalvo = false;
    });

    if (texto.isEmpty) {
      setState(() => _erro = "Digite seu peso para registrar.");
      return;
    }

    if (peso == null || peso < 30 || peso > 300) {
      setState(() => _erro = "Digite um peso valido (entre 30 e 300 kg).");
      return;
    }

    final hoje = DateTime.now();
    final dataFormatada =
        "${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}";

    setState(() {
      _registros.add({"data": dataFormatada, "peso": peso});
      _pesoController.clear();
      _registroSalvo = true;
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
        title: const Text(
          "MINHA EVOLUCAO",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            fontSize: 15,
            color: AppColors.textoPrincipal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cards de resumo
            Row(
              children: [
                _buildCardResumo("PESO INICIAL",
                    "${_pesoInicial.toStringAsFixed(1)} kg",
                    Icons.flag_outlined, AppColors.textoSuave),
                const SizedBox(width: 12),
                _buildCardResumo("PESO ATUAL",
                    "${_pesoAtual.toStringAsFixed(1)} kg",
                    Icons.monitor_weight_outlined, AppColors.roseGold),
                const SizedBox(width: 12),
                _buildCardResumo("TOTAL",
                    "-${_totalPerdido.toStringAsFixed(1)} kg",
                    Icons.trending_down, AppColors.sucesso),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "PROGRESSO DE PESO",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.5,
                color: AppColors.roseEscuro,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              height: 220,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.champanhe),
              ),
              child: _buildGrafico(),
            ),

            const SizedBox(height: 30),

            const Text(
              "REGISTRAR PESO DE HOJE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.5,
                color: AppColors.roseEscuro,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pesoController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {
                      _erro = null;
                      _registroSalvo = false;
                    }),
                    decoration: InputDecoration(
                      hintText: "Ex: 72.5",
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                      suffixText: "kg",
                      suffixStyle: const TextStyle(
                          color: AppColors.roseGold,
                          fontWeight: FontWeight.bold),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: AppColors.champanhe),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.roseGold, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _salvarPeso,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.roseGold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    "SALVAR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 12),
                  ),
                ),
              ],
            ),

            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
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

            if (_registroSalvo)
              Padding(
                padding: const EdgeInsets.only(top: 10),
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
                        "Peso registrado com sucesso!",
                        style: TextStyle(
                            color: AppColors.sucesso,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            const Text(
              "HISTORICO DE REGISTROS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.5,
                color: AppColors.roseEscuro,
              ),
            ),
            const SizedBox(height: 14),

            ..._registros.reversed.take(6).map((r) => _buildItemHistorico(r)),

            const SizedBox(height: 20),

            // Card motivacional
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
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Voce ja eliminou ${_totalPerdido.toStringAsFixed(1)}kg desde o inicio do seu protocolo. Continue brilhando!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildGrafico() {
    final visiveis = _registros.length > 6
        ? _registros.sublist(_registros.length - 6)
        : _registros;

    final pesos = visiveis.map((r) => r['peso'] as double).toList();
    final maxPeso = pesos.reduce((a, b) => a > b ? a : b);
    final minPeso = pesos.reduce((a, b) => a < b ? a : b);
    final range = (maxPeso - minPeso).clamp(1.0, double.infinity);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: visiveis.map((r) {
        final peso = r['peso'] as double;
        final proporcao = (peso - minPeso) / range;
        const alturaMaxima = 140.0;
        const alturaMinima = 30.0;
        final altura =
            alturaMinima + proporcao * (alturaMaxima - alturaMinima);
        final ehUltimo = r == visiveis.last;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              peso.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: ehUltimo
                    ? AppColors.roseEscuro
                    : AppColors.textoSuave,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 36,
              height: altura,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: ehUltimo
                      ? [AppColors.roseGold, AppColors.roseEscuro]
                      : [
                          AppColors.roseGold.withValues(alpha: 0.4),
                          AppColors.roseGold.withValues(alpha: 0.2),
                        ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              r['data'] as String,
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 0.5,
                color: ehUltimo
                    ? AppColors.roseEscuro
                    : AppColors.textoSuave,
                fontWeight:
                    ehUltimo ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCardResumo(
      String label, String valor, IconData icone, Color cor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.champanhe),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: cor, size: 18),
            const SizedBox(height: 8),
            Text(
              valor,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: cor),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 9,
                  letterSpacing: 0.8,
                  color: AppColors.textoSuave),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemHistorico(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.champanhe),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: AppColors.textoSuave),
              const SizedBox(width: 10),
              Text(r['data'] as String,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textoPrincipal)),
            ],
          ),
          Text(
            "${(r['peso'] as double).toStringAsFixed(1)} kg",
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.roseEscuro),
          ),
        ],
      ),
    );
  }
}