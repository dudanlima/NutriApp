import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';

class AnaliseRotuloScreen extends StatefulWidget {
  const AnaliseRotuloScreen({super.key});

  @override
  State<AnaliseRotuloScreen> createState() => _AnaliseRotuloScreenState();
}

class _AnaliseRotuloScreenState extends State<AnaliseRotuloScreen> {
  static const String _apiKey = 'AIzaSyCXjIWyFRqSwQomeHR60yl2qakb0KhOLwo';

  bool _processando = false;
  String _resultado = "";
  Uint8List? _fotoBytes;

  Future<void> _escolherFoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _fotoBytes = bytes;
        _resultado = "";
      });
    }
  }

  Future<void> _executarAnalise() async {
    if (_fotoBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tire uma foto do rotulo primeiro.'),
          backgroundColor: AppColors.roseGold,
        ),
      );
      return;
    }

    setState(() {
      _processando = true;
      _resultado = "";
    });

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey',
      );

      final imagemBase64 = base64Encode(_fotoBytes!);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': 'Voce e uma nutricionista analisando um rotulo de produto. '
                      'Seja direta e curta. Responda neste formato exato:\n\n'
                      'Produto: [nome do produto identificado]\n\n'
                      'Veredicto: [Encaixa bem no plano / Encaixa com moderacao / Nao encaixa no plano]\n\n'
                      'Por que: [uma frase curta explicando o motivo]\n\n'
                      'Substituicao: [sugira um produto ou alternativa de marca especifica com melhor custo-beneficio e que se encaixe melhor no plano alimentar]'
                },
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': imagemBase64,
                  }
                }
              ]
            }
          ]
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final texto =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        setState(() {
          _resultado = texto.replaceAll('*', '').trim();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha na analise. Tente novamente.'),
            backgroundColor: AppColors.erro,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro de conexao. Verifique sua internet.'),
          backgroundColor: AppColors.erro,
        ),
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
          'ANALISE DE ROTULO',
          style: TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
              color: AppColors.textoPrincipal),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textoPrincipal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            GestureDetector(
              onTap: _escolherFoto,
              child: Container(
                height: 250,
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.champanhe),
                ),
                child: _fotoBytes != null
                    ? Image.memory(_fotoBytes!, fit: BoxFit.cover)
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              size: 60, color: AppColors.roseGold),
                          SizedBox(height: 15),
                          Text("Toque para fotografar o rotulo",
                              style: TextStyle(color: AppColors.textoSuave)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _processando ? null : _executarAnalise,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.roseGold,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: _processando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('ANALISAR ROTULO'),
            ),
            if (_resultado.isNotEmpty) ...[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.champanhe),
                ),
                child: Text(
                  _resultado,
                  style: const TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      color: AppColors.textoPrincipal),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}