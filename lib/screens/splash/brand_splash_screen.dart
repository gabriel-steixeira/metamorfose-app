/**
 * File: brand_splash_screen.dart
 * Description: Tela de splash com a marca do aplicativo.
 *
 * Responsabilidades:
 * - Exibir logo e marca do aplicativo
 * - Fazer transição para próxima tela
 * - Carregamento inicial da aplicação
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:conversao_flutter/routes/routes.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Tela de splash inicial que exibe o logo da marca Metamorfose.
/// Esta é a primeira tela que o usuário vê ao iniciar o aplicativo.
class BrandSplashScreen extends StatefulWidget {
  const BrandSplashScreen({super.key});

  @override
  State<BrandSplashScreen> createState() => _BrandSplashScreenState();
}

class _BrandSplashScreenState extends State<BrandSplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  /// Inicia o temporizador para navegar para a próxima tela após 2 segundos
  void _startTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(Routes.mascotSplash);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtendo o tamanho da tela
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: MetamorfoseColors.purpleLight, // Cor de fundo roxo claro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Logo da borboleta (pode ser escalado para qualquer tamanho)
            SvgPicture.asset(
              'assets/images/splashscreen/simple_butterfly.svg',
              width: screenSize.width * 0.65, // 65% da largura da tela
              height: screenSize.height * 0.20, // 25% da altura da tela
            ),
            const SizedBox(height: 15), // Espaço entre o logo e o texto
            // Texto "metamorfose"
            const Text(
              'metamorfose',
              style: TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.bold,
                fontFamily: 'DinNext',
              ),
            ),
            const Spacer(),
            // Indicador na parte inferior
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
} 