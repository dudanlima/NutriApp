import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'package:nutri_app/theme/app_colors.dart'; 
import 'package:nutri_app/screens/auth/login_screen.dart'; 
import 'package:google_fonts/google_fonts.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NutriApp());
}

class NutriApp extends StatelessWidget {
  const NutriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriApp Pro',
      debugShowCheckedModeBanner: false,
      
      // Força o aplicativo a ignorar o modo escuro do celular
      themeMode: ThemeMode.light, 

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        
        // 1. CONFIGURAÇÃO DOS TEXTOS DO CORPO (Fundo Vanilla)
        // Todos os textos normais do app vão usar a fonte Inter e serão escuros
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textoEscuro),
          displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textoEscuro),
          headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textoEscuro),
          titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textoEscuro),
          titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textoEscuro),
          titleSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textoEscuro),
        ),

        // 2. CONFIGURAÇÃO DOS TEXTOS DO CABEÇALHO (Fundo Amarelo/Dourado)
        // Aqui nós forçamos qualquer texto que fique dentro do topo/appbar a usar Poppins Branca
        primaryTextTheme: GoogleFonts.poppinsTextTheme().copyWith(
          headlineMedium: const TextStyle(color: Colors.white),
          titleLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          bodyLarge: const TextStyle(color: Colors.white70),
          bodyMedium: const TextStyle(color: Colors.white70),
        ),

        // Garante que a barra superior e os ícones dela fiquem brancos puro
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.roseGold,
          foregroundColor: Colors.white, 
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white, 
          ),
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.roseGold,
          primary: AppColors.roseGold,
          surface: AppColors.fundo,
          brightness: Brightness.light,
        ),
        
        scaffoldBackgroundColor: AppColors.fundo, 
        
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.champanhe,
          surfaceTintColor: Colors.transparent,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.roseGold,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
      home: const LoginScreen(), 
    );
  }
}