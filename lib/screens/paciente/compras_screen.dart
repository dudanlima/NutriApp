import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ComprasScreen extends StatefulWidget {
  const ComprasScreen({super.key});

  @override
  State<ComprasScreen> createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
  // Lista agora começa vazia, sem dados de exemplo
  final List<Map<String, dynamic>> _itens = [];

  final TextEditingController _novoItemController = TextEditingController();

  void _adicionarItem() {
    if (_novoItemController.text.isNotEmpty) {
      setState(() {
        _itens.add({
          "nome": _novoItemController.text,
          "tipo": "Adicionado por você",
          "comprado": false
        });
        _novoItemController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text(
          "LISTA DE COMPRAS", 
          style: TextStyle(fontWeight: FontWeight.w300, letterSpacing: 2, fontSize: 13, color: AppColors.textoPrincipal)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textoPrincipal),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _novoItemController,
                    style: const TextStyle(color: AppColors.textoPrincipal),
                    decoration: InputDecoration(
                      hintText: "Ex: Sabonete, Papel Toalha...",
                      hintStyle: const TextStyle(color: AppColors.textoSuave),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.champanhe),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.champanhe),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.roseGold),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.roseGold,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    onPressed: _adicionarItem,
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          
          Expanded(
            child: _itens.isEmpty 
              ? const Center(
                  child: Text(
                    "Sua lista está vazia.\nAdicione os itens acima.", 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textoSuave)
                  )
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _itens.length,
                  itemBuilder: (context, index) {
                    final item = _itens[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: AppColors.champanhe)
                      ),
                      elevation: 0,
                      color: Colors.white,
                      child: CheckboxListTile(
                        title: Text(
                          item["nome"],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: item["comprado"] ? TextDecoration.lineThrough : null,
                            color: item["comprado"] ? AppColors.textoSuave : AppColors.textoPrincipal,
                          ),
                        ),
                        subtitle: Text(
                          item["tipo"],
                          style: TextStyle(
                            color: item["tipo"] == "Do seu Plano" ? AppColors.roseGold : AppColors.textoSuave,
                            fontSize: 12,
                          ),
                        ),
                        value: item["comprado"],
                        activeColor: AppColors.roseGold,
                        checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        onChanged: (val) {
                          setState(() {
                            item["comprado"] = val;
                          });
                        },
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