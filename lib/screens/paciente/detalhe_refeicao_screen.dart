import 'package:flutter/material.dart';

class DetalheRefeicaoScreen extends StatelessWidget {
  final String titulo;
  final List itens; // Espera uma lista de Maps ou Strings

  const DetalheRefeicaoScreen({
    super.key, 
    required this.titulo, 
    required this.itens
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de resumo/cabeçalho
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pink.withValues(alpha: 0.1), // Correção aplicada
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pink.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.restaurant, color: Colors.pink, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    "Plano para $titulo",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Alimentos Recomendados",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            
            // Lista dinâmica de itens
            Expanded(
              child: itens.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: itens.length,
                      itemBuilder: (context, index) {
                        final item = itens[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)), // Correção side
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                            title: Text(item.toString()),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.grey.withValues(alpha: 0.5), size: 50),
          const SizedBox(height: 10),
          const Text(
            "Nenhum item definido para esta refeição.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}