/// File: home.dart
/// Description: Tela principal do Metamorfose.
///
/// Responsabilidades:
/// - Exibir interface de visualização do dia
/// - Exibir informações do personagem
/// - Mostrar notificação de boas-vindas
/// - Usar BLoC pattern para gerenciamento de estado
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 30-05-2025
/// Last modified: 30-05-2025
/// Version: 2.0.0 (BLoC)
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/theme/text_styles.dart';
import 'package:conversao_flutter/components/speech_bubble.dart';
import 'package:conversao_flutter/components/bottom_navigation_menu.dart';
import 'package:conversao_flutter/blocs/home_bloc.dart';
import 'package:conversao_flutter/state/home/home_state.dart';

/// Tela principal de visualização do dia com o assistente usando BLoC.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Inicializar o BLoC
    context.read<HomeBloc>().add(InitializeHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bubbleWidth = screenSize.width * 0.85;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // Tratar erros se necessário
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
          // Limpar erro após mostrar
          context.read<HomeBloc>().add(ClearErrorEvent());
        }
      },
      builder: (context, state) {
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
                    padding: EdgeInsets.only(top: screenSize.height * 0.5 - 80, bottom: 100),
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
                                  if (state.weatherLoadingState == LoadingState.loading) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (state.weatherLoadingState == LoadingState.success && state.weather != null) {
                                    final weather = state.weather!;
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Emoticon à esquerda
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12, top: 2),
                                          child: Text(
                                            weather.getWeatherIcon(),
                                            style: const TextStyle(fontSize: 40),
                                          ),
                                        ),
                                        // Informações do clima
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Primeira linha: Nome da cidade em negrito
                                            Text(
                                              weather.location,
                                              style: AppTextStyles.bodyLarge.copyWith(
                                                color: MetamorfoseColors.greyDark,
                                                fontFamily: 'DinNext',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Segunda linha: Temperatura
                                            Text(
                                              'Temperatura: ${weather.temperature.toStringAsFixed(1)}°C',
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
                                                  'Mínima: ${weather.tempMin.toStringAsFixed(1)}°C',
                                                  style: AppTextStyles.bodyLarge.copyWith(
                                                    color: MetamorfoseColors.blueNormal,
                                                    fontFamily: 'DinNext',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Máxima: ${weather.tempMax.toStringAsFixed(1)}°C',
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
                                      'Erro ao carregar clima: ${state.weatherError ?? "Erro desconhecido"}',
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
                                  if (state.quoteLoadingState == LoadingState.loading) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (state.quoteLoadingState == LoadingState.success && state.quote != null) {
                                    return Text(
                                      state.quote!.text,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: MetamorfoseColors.greyDark,
                                        fontFamily: 'DinNext',
                                      ),
                                      textAlign: TextAlign.left,
                                    );
                                  } else {
                                    return Text(
                                      'Erro ao carregar mensagem: ${state.quoteError ?? "Erro desconhecido"}',
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
                child: SafeArea(
                  top: false, // Garante que o padding seja aplicado apenas na parte inferior
                  child: BottomNavigationMenu(
                    activeIndex: 0, // Home icon ativo por padrão
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 