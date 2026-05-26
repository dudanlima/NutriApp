import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AnamneseScreen extends StatefulWidget {
  const AnamneseScreen({super.key});

  @override
  State<AnamneseScreen> createState() => _AnamneseScreenState();
}

class _AnamneseScreenState extends State<AnamneseScreen> {
  // 1. IDENTIFICAÇÃO E SOCIAL
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _profissaoController = TextEditingController();
  String _sexo = "Feminino";
  String? _freqCompras;

  // 2. ANTROPOMETRIA BÁSICA
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoIdealController = TextEditingController();

  // 3. CLÍNICO E FAMILIAR
  bool _fuma = false;
  bool _bebe = false;
  String? _habitoIntestinal;
  
  // Checkboxes Sintomas
  bool _sintomaNausea = false;
  bool _sintomaRefluxo = false;
  bool _sintomaInsonia = false;
  bool _sintomaAnsiedade = false;

  // Checkboxes Histórico Familiar
  bool _histDiabetes = false;
  bool _histHipertensao = false;
  bool _histObesidade = false;

  // 4. ALIMENTAÇÃO E HÁBITOS
  final TextEditingController _aguaController = TextEditingController();
  final TextEditingController _suplementosController = TextEditingController();
  bool _praticaAtividade = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _motivoController.dispose();
    _profissaoController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    _pesoIdealController.dispose();
    _aguaController.dispose();
    _suplementosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text(
          "FICHA DE ANAMNESE",
          style: TextStyle(fontWeight: FontWeight.w300, letterSpacing: 2, fontSize: 13, color: AppColors.textoPrincipal),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textoPrincipal),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // SECÇÃO 1: Identificação
          _buildSecao(
            titulo: "1. IDENTIFICAÇÃO E SOCIAL",
            icone: Icons.person_outline,
            conteudo: Column(
              children: [
                _buildTextField("Nome completo", _nomeController),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Idade", _idadeController, isNumber: true)),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Sexo", style: TextStyle(color: AppColors.textoSuave, fontSize: 12)),
                          Row(
                            children: [
                              _buildRadio("F", "Feminino", _sexo, (v) => setState(() => _sexo = v!)),
                              _buildRadio("M", "Masculino", _sexo, (v) => setState(() => _sexo = v!)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildTextField("Motivo da Consulta", _motivoController, maxLines: 2),
                const SizedBox(height: 15),
                _buildTextField("Profissão / Carga Horária", _profissaoController),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: _decoracaoCampo("Frequência das Compras"),
                  dropdownColor: Colors.white,
                  initialValue: _freqCompras,
                  icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.roseGold),
                  items: ["Diariamente", "Semanalmente", "Mensalmente"].map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (novoValor) => setState(() => _freqCompras = novoValor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // SECÇÃO 2: Antropometria
          _buildSecao(
            titulo: "2. DADOS ANTROPOMÉTRICOS",
            icone: Icons.monitor_weight_outlined,
            conteudo: Row(
              children: [
                Expanded(child: _buildTextField("Peso (kg)", _pesoController, isNumber: true)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField("Altura (cm)", _alturaController, isNumber: true)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField("Peso Ideal", _pesoIdealController, isNumber: true)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // SECÇÃO 3: Dados Clínicos
          _buildSecao(
            titulo: "3. DADOS CLÍNICOS E FAMILIARES",
            icone: Icons.medical_information_outlined,
            conteudo: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text("Fuma ou já fumou?", style: TextStyle(color: AppColors.textoPrincipal, fontSize: 14)),
                  activeThumbColor: AppColors.roseGold,
                  contentPadding: EdgeInsets.zero,
                  value: _fuma,
                  onChanged: (valor) => setState(() => _fuma = valor),
                ),
                SwitchListTile(
                  title: const Text("Faz uso de bebidas alcoólicas?", style: TextStyle(color: AppColors.textoPrincipal, fontSize: 14)),
                  activeThumbColor: AppColors.roseGold,
                  contentPadding: EdgeInsets.zero,
                  value: _bebe,
                  onChanged: (valor) => setState(() => _bebe = valor),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: _decoracaoCampo("Hábito Intestinal"),
                  dropdownColor: Colors.white,
                  initialValue: _habitoIntestinal,
                  items: ["Diário", "Até 3 dias", "Mais de 3 dias", "Outro"].map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (novoValor) => setState(() => _habitoIntestinal = novoValor),
                ),
                const SizedBox(height: 20),
                const Text("Sintomas Recorrentes:", style: TextStyle(color: AppColors.roseGold, fontWeight: FontWeight.bold, fontSize: 12)),
                _buildCheckbox("Náusea / Vómito", _sintomaNausea, (v) => setState(() => _sintomaNausea = v!)),
                _buildCheckbox("Pirose / Refluxo", _sintomaRefluxo, (v) => setState(() => _sintomaRefluxo = v!)),
                _buildCheckbox("Insónia", _sintomaInsonia, (v) => setState(() => _sintomaInsonia = v!)),
                _buildCheckbox("Stress / Ansiedade", _sintomaAnsiedade, (v) => setState(() => _sintomaAnsiedade = v!)),
                
                const SizedBox(height: 15),
                const Text("Antecedentes Familiares:", style: TextStyle(color: AppColors.roseGold, fontWeight: FontWeight.bold, fontSize: 12)),
                _buildCheckbox("Diabetes Mellitus", _histDiabetes, (v) => setState(() => _histDiabetes = v!)),
                _buildCheckbox("Hipertensão Arterial", _histHipertensao, (v) => setState(() => _histHipertensao = v!)),
                _buildCheckbox("Obesidade", _histObesidade, (v) => setState(() => _histObesidade = v!)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // SECÇÃO 4: Hábitos e Alimentação
          _buildSecao(
            titulo: "4. HISTÓRICO ALIMENTAR",
            icone: Icons.restaurant_menu_outlined,
            conteudo: Column(
              children: [
                SwitchListTile(
                  title: const Text("Pratica atividade física?", style: TextStyle(color: AppColors.textoPrincipal, fontSize: 14)),
                  activeThumbColor: AppColors.roseGold,
                  contentPadding: EdgeInsets.zero,
                  value: _praticaAtividade,
                  onChanged: (valor) => setState(() => _praticaAtividade = valor),
                ),
                const SizedBox(height: 10),
                _buildTextField("Consumo de Água (Litros/dia)", _aguaController, isNumber: true),
                const SizedBox(height: 15),
                _buildTextField("Faz uso de Suplementos? Quais?", _suplementosController, maxLines: 2),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // BOTÃO SALVAR
          ElevatedButton(
            onPressed: () {
              // Lógica para guardar os dados
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Anamnese guardada com sucesso!"), backgroundColor: AppColors.sucesso),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.roseGold,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            child: const Text("GUARDAR FICHA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // WIDGETS AUXILIARES PARA MANTER O CÓDIGO LIMPO
  Widget _buildSecao({required String titulo, required IconData icone, required Widget conteudo}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.champanhe),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        iconColor: AppColors.roseGold,
        collapsedIconColor: AppColors.textoSuave,
        shape: const Border(),
        title: Row(
          children: [
            Icon(icone, size: 20, color: AppColors.roseGold),
            const SizedBox(width: 10),
            Text(
              titulo, 
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.roseEscuro, letterSpacing: 1.2)
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: conteudo,
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: AppColors.textoPrincipal, fontSize: 14),
      decoration: _decoracaoCampo(label),
    );
  }

  Widget _buildRadio(String label, String value, String groupValue, Function(String?) onChanged) {
    return Expanded(
      child: RadioListTile<String>(
        title: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textoPrincipal)),
        value: value,
        groupValue: groupValue,
        activeColor: AppColors.roseGold,
        contentPadding: EdgeInsets.zero,
        dense: true,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCheckbox(String titulo, bool valor, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(titulo, style: const TextStyle(color: AppColors.textoSuave, fontSize: 13)),
      activeColor: AppColors.roseGold,
      checkColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      value: valor,
      onChanged: onChanged,
    );
  }

  InputDecoration _decoracaoCampo(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textoSuave, fontSize: 13),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.champanhe)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.roseGold, width: 2)),
    );
  }
}