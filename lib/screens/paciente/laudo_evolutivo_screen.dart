import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_colors.dart';

class LaudoEvolutivoScreen extends StatefulWidget {
  const LaudoEvolutivoScreen({super.key});

  @override
  State<LaudoEvolutivoScreen> createState() => _LaudoEvolutivoScreenState();
}

class _LaudoEvolutivoScreenState extends State<LaudoEvolutivoScreen> {
  static const String _apiKey = 'AIzaSyCXjIWyFRqSwQomeHR60yl2qakb0KhOLwo';

  bool _processando = false;
  String _parecerTecnico =
      'O seu laudo evolutivo será preenchido pela nutricionista após a sua próxima avaliação física. Aqui você verá o resumo da sua progressão, composição corporal e metas atingidas.';

  Future<void> _gerarParecerIA() async {
    setState(() => _processando = true);

    try {
      // MUDANÇA: Usando gemini-pro (estável para texto)
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_apiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Aja como a nutricionista Eduarda Nogueira. Escreva um parecer técnico curto para um paciente focado em constância e composição corporal. Não use negritos.'
                }
              ]
            }
          ]
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final texto = data['candidates'][0]['content']['parts'][0]['text'] as String;
        setState(() {
          _parecerTecnico = texto.replaceAll('*', '').trim();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao gerar laudo.'), backgroundColor: AppColors.erro),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão.'), backgroundColor: AppColors.erro),
      );
    } finally {
      if (mounted) setState(() => _processando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text(
          "MEUS EXAMES",
          style: TextStyle(fontWeight: FontWeight.w300, letterSpacing: 2, fontSize: 13, color: AppColors.textoPrincipal),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.champanhe),
              ),
              child: Column(
                children: [
                  Text(_parecerTecnico, style: const TextStyle(color: AppColors.textoPrincipal, fontSize: 14, height: 1.5)),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: _processando ? null : _gerarParecerIA,
                    icon: const Icon(Icons.auto_awesome, color: AppColors.roseGold),
                    label: Text(_processando ? "ANALISANDO..." : "SOLICITAR ANÁLISE", style: const TextStyle(color: AppColors.roseGold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}