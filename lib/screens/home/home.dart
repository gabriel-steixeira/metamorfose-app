/// File: home.dart
/// Description: Tela principal do Metamorfose.
///
/// Responsabilidades:
/// - Exibir interface de visualização do dia
/// - Exibir informações do personagem
/// - Mostrar notificação de boas-vindas
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 30-05-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/theme/text_styles.dart';
import 'package:conversao_flutter/components/speech_bubble.dart';
import 'package:conversao_flutter/components/bottom_navigation_menu.dart';
import 'package:conversao_flutter/models/weather.dart';
import 'package:conversao_flutter/models/quote.dart';
import 'package:conversao_flutter/services/notification_service.dart';

/// Enum para estados da aplicação
enum AppState {
  loading,
  success,
  error,
}

/// Tela principal de visualização do dia com o assistente.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AppState weatherState = AppState.loading;
  AppState quoteState = AppState.loading;
  Weather? weather;
  Quote? quote;
  String weatherError = '';
  String quoteError = '';

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
    _loadQuoteData();
    _showWelcomeNotification();
  }

  Future<void> _loadWeatherData() async {
    setState(() => weatherState = AppState.loading);
    
    try {
      final weatherData = await Weather.fetchWeatherWithLocation();
      setState(() {
        weather = weatherData;
        weatherState = AppState.success;
      });
    } catch (e) {
      setState(() {
        weatherState = AppState.error;
        weatherError = e.toString();
      });
    }
  }

  Future<void> _loadQuoteData() async {
    setState(() => quoteState = AppState.loading);
    
    try {
      final quoteData = await Quote.fetchQuote();
      setState(() {
        quote = quoteData;
        quoteState = AppState.success;
      });
    } catch (e) {
      setState(() {
        quoteState = AppState.error;
        quoteError = e.toString();
      });
    }
  }

  /// Mostra notificação de boas-vindas
  Future<void> _showWelcomeNotification() async {
    try {
      // Aguardar um pouco para que a tela carregue completamente
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Mostrar notificação de boas-vindas
      await NotificationService().showWelcomeNotification();
    } catch (e) {
      debugPrint('❌ Erro ao mostrar notificação de boas-vindas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bubbleWidth = screenSize.width * 0.85;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      body: Stack(
        children: [
          // Background imagem decorativa
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/home/bg_home.png',
              width: screenSize.width,
              height: screenSize.height * 0.5,
              fit: BoxFit.cover,
            ),
          ),
          // Conteúdo principal com rolagem e espaçamento dinâmico
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: screenSize.height * 0.5 - 40, bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Seção Clima
                    Padding(
                      padding: EdgeInsets.only(left: (screenSize.width - bubbleWidth) / 2, bottom: 4, top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Clima',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: MetamorfoseColors.greyDark,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DinNext',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SpeechBubble(
                        width: bubbleWidth,
                        showTriangle: false,
                        showBorder: true,
                        borderColor: MetamorfoseColors.purpleNormal,
                        color: MetamorfoseColors.whiteLight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Builder(
                            builder: (_) {
                              if (weatherState == AppState.loading) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (weatherState == AppState.success && weather != null) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Emoticon à esquerda
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12, top: 2),
                                      child: Text(
                                        weather!.getWeatherIcon(),
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                    ),
                                    // Informações do clima
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Primeira linha: Nome da cidade em negrito
                                        Text(
                                          weather!.location,
                                          style: AppTextStyles.bodyLarge.copyWith(
                                            color: MetamorfoseColors.greyDark,
                                            fontFamily: 'DinNext',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Segunda linha: Temperatura
                                        Text(
                                          'Temperatura: ${weather!.temperature.toStringAsFixed(1)}°C',
                                          style: AppTextStyles.bodyLarge.copyWith(
                                            color: MetamorfoseColors.greyDark,
                                            fontFamily: 'DinNext',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Terceira linha: Mínima e Máxima
                                        Row(
                                          children: [
                                            Text(
                                              'Mínima: ${weather!.tempMin.toStringAsFixed(1)}°C',
                                              style: AppTextStyles.bodyLarge.copyWith(
                                                color: MetamorfoseColors.blueNormal,
                                                fontFamily: 'DinNext',
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Máxima: ${weather!.tempMax.toStringAsFixed(1)}°C',
                                              style: AppTextStyles.bodyLarge.copyWith(
                                                color: MetamorfoseColors.redNormal,
                                                fontFamily: 'DinNext',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Text(
                                  'Erro ao carregar clima: $weatherError',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: MetamorfoseColors.redNormal,
                                    fontFamily: 'DinNext',
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    // Seção Mensagem do dia
                    Padding(
                      padding: EdgeInsets.only(left: (screenSize.width - bubbleWidth) / 2, bottom: 4, top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mensagem do dia',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: MetamorfoseColors.greyDark,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DinNext',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SpeechBubble(
                        width: bubbleWidth,
                        showTriangle: false,
                        showBorder: true,
                        borderColor: MetamorfoseColors.greenLight,
                        color: MetamorfoseColors.whiteLight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Builder(
                            builder: (_) {
                              if (quoteState == AppState.loading) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (quoteState == AppState.success && quote != null) {
                                return Text(
                                  quote!.text,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: MetamorfoseColors.greyDark,
                                    fontFamily: 'DinNext',
                                  ),
                                  textAlign: TextAlign.left,
                                );
                              } else {
                                return Text(
                                  'Erro ao carregar mensagem: $quoteError',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: MetamorfoseColors.redNormal,
                                    fontFamily: 'DinNext',
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    // Seção de teste das notificações (pode ser removida em produção)
                    if (true) // Mantém apenas em desenvolvimento
                      Padding(
                        padding: EdgeInsets.only(left: (screenSize.width - bubbleWidth) / 2, bottom: 4, top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Teste de Notificações',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: MetamorfoseColors.greyDark,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'DinNext',
                            ),
                          ),
                        ),
                      ),
                    if (true) // Mantém apenas em desenvolvimento
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SpeechBubble(
                          width: bubbleWidth,
                          showTriangle: false,
                          showBorder: true,
                          borderColor: MetamorfoseColors.purpleLight,
                          color: MetamorfoseColors.whiteLight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Column(
                              children: [
                                Text(
                                  'Teste as notificações do app:',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: MetamorfoseColors.greyDark,
                                    fontFamily: 'DinNext',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => NotificationService().showWelcomeNotification(),
                                      icon: const Icon(Icons.waving_hand, size: 16),
                                      label: const Text('Boas-vindas'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MetamorfoseColors.greenNormal,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        textStyle: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => NotificationService().showMotivationNotification(),
                                      icon: const Icon(Icons.fitness_center, size: 16),
                                      label: const Text('Motivação'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MetamorfoseColors.purpleNormal,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        textStyle: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => NotificationService().showPlantCareNotification(),
                                      icon: const Icon(Icons.local_florist, size: 16),
                                      label: const Text('Cuidar da Planta'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MetamorfoseColors.greenLight,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        textStyle: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Menu de navegação fixo embaixo
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationMenu(
              activeIndex: 0, // Home icon ativo por padrão
            ),
          ),
        ],
      ),
    );
  }

} 