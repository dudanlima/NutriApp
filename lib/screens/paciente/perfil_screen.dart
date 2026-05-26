import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _objetivoController = TextEditingController();
  bool _carregando = true;
  Uint8List? _fotoBytes;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    User? usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuarioAtual.uid)
            .get();

        if (doc.exists) {
          setState(() {
            _nomeController.text = doc.get('nome') ?? '';
            _objetivoController.text = doc.get('objetivo') ?? '';
          });
        }
      } catch (e) {
        debugPrint("Erro ao carregar perfil: $e");
      }
    }
    setState(() => _carregando = false);
  }

  Future<void> _salvarDados() async {
    User? usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual != null) {
      setState(() => _carregando = true);
      try {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuarioAtual.uid)
            .update({
          'nome': _nomeController.text.trim(),
          'objetivo': _objetivoController.text.trim(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Perfil atualizado com sucesso!"), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro ao salvar."), backgroundColor: Colors.redAccent),
          );
        }
      }
      setState(() => _carregando = false);
    }
  }

  Future<void> _escolherFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _fotoBytes = bytes;
      });
      // Nota: Para a foto ficar salva permanentemente na nuvem, 
      // configuraremos o Firebase Storage no futuro.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text(
          "MEU PERFIL", 
          style: TextStyle(
            fontWeight: FontWeight.w300, 
            letterSpacing: 2, 
            fontSize: 13, 
            color: AppColors.textoPrincipal
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: AppColors.textoPrincipal),
      ),
      body: _carregando 
        ? const Center(child: CircularProgressIndicator(color: AppColors.roseGold))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                
                GestureDetector(
                  onTap: _escolherFoto,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.roseGold, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50, 
                      backgroundColor: AppColors.champanhe.withValues(alpha: 0.5),
                      backgroundImage: _fotoBytes != null ? MemoryImage(_fotoBytes!) : null,
                      child: _fotoBytes == null 
                          ? const Icon(Icons.camera_alt, size: 40, color: AppColors.roseGold)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Toque para alterar a foto", style: TextStyle(color: AppColors.textoSuave, fontSize: 12)),
                const SizedBox(height: 30),
                
                _buildSectionTitle("MINHAS INFORMAÇÕES"),
                _buildCardCampo(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nomeController, 
                        style: const TextStyle(color: AppColors.textoPrincipal),
                        decoration: const InputDecoration(
                          labelText: "Nome",
                          labelStyle: TextStyle(color: AppColors.textoSuave),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.champanhe)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.roseGold)),
                        )
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _objetivoController, 
                        style: const TextStyle(color: AppColors.textoPrincipal),
                        decoration: const InputDecoration(
                          labelText: "Meu Objetivo",
                          labelStyle: TextStyle(color: AppColors.textoSuave),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.champanhe)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.roseGold)),
                        )
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                ElevatedButton(
                  onPressed: _salvarDados,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.roseGold,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("SALVAR ALTERAÇÕES", style: TextStyle(letterSpacing: 1.5)),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 10),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, size: 14, color: AppColors.roseGold),
            const SizedBox(width: 8),
            Text(
              title, 
              style: const TextStyle(
                fontSize: 10, 
                fontWeight: FontWeight.w600, 
                color: AppColors.roseGold,
                letterSpacing: 1.2,
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardCampo({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.champanhe),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02), 
            blurRadius: 10, 
            offset: const Offset(0, 5)
          )
        ],
      ),
      child: child,
    );
  }
}