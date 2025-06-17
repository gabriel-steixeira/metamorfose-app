/**
 * File: home_screen_bloc.dart
 * Description: Tela inicial com BLoC implementada.
 *
 * Responsabilidades:
 * - Exibir interface de visualização do dia usando BLoC
 * - Exibir informações do personagem
 * - Gerenciar estado de clima e quotes via BLoC
 * - Interface reativa e responsiva
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/theme/text_styles.dart';
import 'package:conversao_flutter/components/speech_bubble.dart';
import 'package:conversao_flutter/components/bottom_navigation_menu.dart';
import 'package:conversao_flutter/blocs/home_bloc.dart';
import 'package:conversao_flutter/state/home/home_state.dart';

/// Tela inicial com BLoC de visualização do dia com o assistente.
class HomeScreenBloc extends StatefulWidget {
  const HomeScreenBloc({super.key});

  @override
  State<HomeScreenBloc> createState() => _HomeScreenBlocState();
}

class _HomeScreenBlocState extends State<HomeScreenBloc> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    
    // Carrega os dados iniciais
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(HomeLoadDataEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bubbleWidth = screenSize.width * 0.85;

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        // Pode adicionar listener para ações específicas se necessário
        // Por exemplo, mostrar toasts de erro específicos
      },
      child: Scaffold(
        backgroundColor: MetamorfoseColors.whiteLight,
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(HomeRefreshAllEvent());
            // Aguarda um pouco para garantir que o estado foi atualizado
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: Stack(
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.5 - 80,
                      bottom: 100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Seção Clima
                        _buildWeatherSection(bubbleWidth),
                        
                        // Seção Mensagem do dia
                        _buildQuoteSection(bubbleWidth),
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
                child: const BottomNavigationMenu(
                  activeIndex: 0, // Home icon ativo por padrão
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherSection(double bubbleWidth) {
    return Column(
      children: [
        // Título da seção clima
        Padding(
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width - bubbleWidth) / 2,
            bottom: 4,
            top: 8,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  'Clima',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: MetamorfoseColors.greyDark,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'DinNext',
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) => 
                      previous.weatherState.state != current.weatherState.state,
                  builder: (context, state) {
                    if (state.weatherState.isLoading) {
                      return const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: MetamorfoseColors.purpleNormal,
                        ),
                      );
                    } else if (state.weatherState.isError) {
                      return GestureDetector(
                        onTap: () {
                          context.read<HomeBloc>().add(HomeRefreshWeatherEvent());
                        },
                        child: const Icon(
                          Icons.refresh,
                          size: 20,
                          color: MetamorfoseColors.redNormal,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
        
        // Bubble do clima
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
              child: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) => 
                    previous.weatherState != current.weatherState,
                builder: (context, state) {
                  if (state.weatherState.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MetamorfoseColors.purpleNormal,
                      ),
                    );
                  } else if (state.weatherState.isSuccess && state.weatherState.hasWeather) {
                    final weather = state.weatherState.weather!;
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nome da cidade em negrito
                              Text(
                                weather.location,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: MetamorfoseColors.greyDark,
                                  fontFamily: 'DinNext',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Temperatura
                              Text(
                                'Temperatura: ${weather.temperature.toStringAsFixed(1)}°C',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: MetamorfoseColors.greyDark,
                                  fontFamily: 'DinNext',
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Mínima e Máxima
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
                        ),
                      ],
                    );
                  } else {
                    // Estado de erro
                    return Column(
                      children: [
                        Text(
                          state.weatherState.errorMessage ?? 'Erro ao carregar clima',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: MetamorfoseColors.redNormal,
                            fontFamily: 'DinNext',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            context.read<HomeBloc>().add(HomeRefreshWeatherEvent());
                          },
                          child: Text(
                            'Tentar novamente',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: MetamorfoseColors.purpleNormal,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteSection(double bubbleWidth) {
    return Column(
      children: [
        // Título da seção mensagem
        Padding(
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width - bubbleWidth) / 2,
            bottom: 4,
            top: 8,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  'Mensagem do dia',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: MetamorfoseColors.greyDark,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'DinNext',
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) => 
                      previous.quoteState.state != current.quoteState.state,
                  builder: (context, state) {
                    if (state.quoteState.isLoading) {
                      return const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: MetamorfoseColors.greenNormal,
                        ),
                      );
                    } else if (state.quoteState.isError) {
                      return GestureDetector(
                        onTap: () {
                          context.read<HomeBloc>().add(HomeRefreshQuoteEvent());
                        },
                        child: const Icon(
                          Icons.refresh,
                          size: 20,
                          color: MetamorfoseColors.redNormal,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
        
        // Bubble da mensagem
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
              child: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) => 
                    previous.quoteState != current.quoteState,
                builder: (context, state) {
                  if (state.quoteState.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MetamorfoseColors.greenNormal,
                      ),
                    );
                  } else if (state.quoteState.isSuccess && state.quoteState.hasQuote) {
                    return Text(
                      state.quoteState.quote!.text,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: MetamorfoseColors.greyDark,
                        fontFamily: 'DinNext',
                      ),
                      textAlign: TextAlign.left,
                    );
                  } else {
                    // Estado de erro
                    return Column(
                      children: [
                        Text(
                          state.quoteState.errorMessage ?? 'Erro ao carregar mensagem',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: MetamorfoseColors.redNormal,
                            fontFamily: 'DinNext',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            context.read<HomeBloc>().add(HomeRefreshQuoteEvent());
                          },
                          child: Text(
                            'Tentar novamente',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: MetamorfoseColors.greenNormal,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
} 