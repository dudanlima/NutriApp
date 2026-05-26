import 'package:flutter/material.dart';

class AppColors {
  // Cores de Fundo e Base
  static const Color champanhe = Color(0xFFF5F5DC);   // Bege elegante
  static const Color fundo = Color(0xFFF1F3F5);       // Cinza gelo clarinho
  static const Color brancoPuro = Colors.white;

  // Cores de Destaque (O toque feminino e chique)
  static const Color roseGold = Color(0xFFE5B9B5);    // Rosé fosco sofisticado
  static const Color roseEscuro = Color(0xFFC18C87);  // Para textos sobre o Rosé
  
  // Cores de Texto e Contraste
  static const Color textoPrincipal = Color(0xFF4A4A4A); // Cinza grafite suave
  static const Color textoSuave = Color(0xFF8E8E8E);     // Para legendas

  // Cores de Status (Versões "pastéis" para não quebrar o visual)
  static const Color sucesso = Color(0xFFA2C4B1); // Verde menta suave
  static const Color erro = Color(0xFFD9A7A7);    // Vermelho pálido/Rosé forte
  static const Color alerta = Color(0xFFE6D5B8);  // Amarelo areia

  // Atalhos para facilitar o uso no código
  static const Color primaria = roseGold;
  static const Color secundaria = champanhe;
}