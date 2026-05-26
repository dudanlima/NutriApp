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

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.roseGold,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
      home: const LoginScreen(), 
    );
  }
}