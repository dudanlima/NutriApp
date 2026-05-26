import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'perfil_paciente_detalhe_screen.dart';
class PacientesScreen extends StatefulWidget {
  const PacientesScreen({super.key});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final List<Map<String, dynamic>> _pacientes = [];
  final TextEditingController _buscaController = TextEditingController();
  String _busca = "";

  List<Map<String, dynamic>> get _pacientesFiltrados {
    if (_busca.isEmpty) return _pacientes;
    return _pacientes
        .where((p) =>
            p['nome'].toString().toLowerCase().contains(_busca.toLowerCase()))
        .toList();
  }

  void _abrirCadastroPaciente() {
    final nomeCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final telefoneCtrl = TextEditingController();
    final objetivoCtrl = TextEditingController();
    String sexo = "Feminino";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
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
                  "NOVO PACIENTE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: AppColors.roseEscuro,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                _campo("Nome completo", nomeCtrl),
                const SizedBox(height: 16),
                _campo("E-mail", emailCtrl,
                    tipo: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _campo("Telefone", telefoneCtrl,
                    tipo: TextInputType.phone),
                const SizedBox(height: 16),
                _campo("Objetivo principal", objetivoCtrl),
                const SizedBox(height: 16),
                const Text(
                  "Sexo",
                  style: TextStyle(
                      color: AppColors.textoSuave, fontSize: 12),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Feminino",
                            style: TextStyle(fontSize: 13)),
                        value: "Feminino",
                        groupValue: sexo,
                        activeColor: AppColors.roseGold,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) =>
                            setModalState(() => sexo = v!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Masculino",
                            style: TextStyle(fontSize: 13)),
                        value: "Masculino",
                        groupValue: sexo,
                        activeColor: AppColors.roseGold,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) =>
                            setModalState(() => sexo = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (nomeCtrl.text.isEmpty) return;
                    setState(() {
                      _pacientes.add({
                        "nome": nomeCtrl.text.trim(),
                        "email": emailCtrl.text.trim(),
                        "telefone": telefoneCtrl.text.trim(),
                        "objetivo": objetivoCtrl.text.trim(),
                        "sexo": sexo,
                        "dataCadastro": DateTime.now()
                            .toString()
                            .substring(0, 10),
                        "dieta": [],
                        "exames": [],
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Paciente cadastrado com sucesso!"),
                        backgroundColor: AppColors.sucesso,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.roseGold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "CADASTRAR PACIENTE",
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

  Widget _campo(String label, TextEditingController ctrl,
      {TextInputType tipo = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: tipo,
      style: const TextStyle(fontSize: 14, color: AppColors.textoPrincipal),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            const TextStyle(color: AppColors.textoSuave, fontSize: 13),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.champanhe)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.roseGold, width: 2)),
      ),
    );
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
          "MEUS PACIENTES",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            fontSize: 13,
            color: AppColors.textoPrincipal,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastroPaciente,
        backgroundColor: AppColors.roseGold,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text("Novo Paciente",
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _buscaController,
              onChanged: (v) => setState(() => _busca = v),
              decoration: InputDecoration(
                hintText: "Buscar paciente...",
                hintStyle:
                    const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.roseGold, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
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

          // Lista
          Expanded(
            child: _pacientesFiltrados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 60,
                            color: AppColors.champanhe
                                .withValues(alpha: 0.8)),
                        const SizedBox(height: 16),
                        const Text(
                          "Nenhum paciente cadastrado.",
                          style: TextStyle(
                              color: AppColors.textoSuave, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Toque no botao abaixo para adicionar.",
                          style: TextStyle(
                              color: AppColors.textoSuave, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: _pacientesFiltrados.length,
                    itemBuilder: (context, index) {
                      final p = _pacientesFiltrados[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.champanhe),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.roseGold.withValues(alpha: 0.15),
                            child: Text(
                              p['nome'].toString().isNotEmpty
                                  ? p['nome'].toString()[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                  color: AppColors.roseGold,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            p['nome'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppColors.textoPrincipal,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                p['objetivo'].isNotEmpty
                                    ? p['objetivo']
                                    : "Sem objetivo definido",
                                style: const TextStyle(
                                    color: AppColors.textoSuave,
                                    fontSize: 12),
                              ),
                              Text(
                                "Cadastrado em: ${p['dataCadastro']}",
                                style: const TextStyle(
                                    color: AppColors.textoSuave,
                                    fontSize: 11),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.roseGold,
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PerfilPacienteDetalheScreen(
                                paciente: p,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}