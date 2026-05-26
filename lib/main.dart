import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importação necessária para o Firebase
import 'firebase_options.dart'; // Importação do arquivo de configuração que geramos
import 'package:nutri_app/theme/app_colors.dart'; 
import 'package:nutri_app/screens/auth/login_screen.dart'; 

void main() async {
  // Garante que os plugins do Flutter estejam prontos antes de iniciar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase com as configurações oficiais do seu projeto
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
      theme: ThemeData(
        useMaterial3: true,
        
        // Define a Nice Paper como a fonte padrão para todos os textos comuns, inputs e botões
        fontFamily: 'NicePaper',

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.roseGold,
          primary: AppColors.roseGold,
          surface: AppColors.fundo,
        ),
        scaffoldBackgroundColor: AppColors.fundo,
        
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.champanhe,
          surfaceTintColor: Colors.transparent,
        ),

        // Configuração detalhada das três fontes novas do DaFont por tamanhos
        textTheme: const TextTheme(
          // Títulos grandes e principais de destaque (Boas-vindas, títulos de páginas)
          displayLarge: TextStyle(fontFamily: 'FunkyGlitz'),
          displayMedium: TextStyle(fontFamily: 'FunkyGlitz'),
          headlineLarge: TextStyle(fontFamily: 'FunkyGlitz'),
          
          // Títulos médios de seções e cartões principais
          titleLarge: TextStyle(fontFamily: 'BrightMiracle', fontSize: 24, fontWeight: FontWeight.normal),
          titleMedium: TextStyle(fontFamily: 'BrightMiracle', fontSize: 20, fontWeight: FontWeight.normal),
          titleSmall: TextStyle(fontFamily: 'BrightMiracle', fontSize: 16, fontWeight: FontWeight.normal),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.roseGold,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            // Garante a fonte NicePaper no texto de dentro de todos os botões
            textStyle: const TextStyle(fontFamily: 'NicePaper', fontSize: 16),
          ),
        ),
      ),
      home: const LoginScreen(), 
    );
  }
}