/// File: text_chat_screen.dart
/// Description: Tela de chat por texto com Perona.
///
/// Responsabilidades:
/// - Interface de chat por texto
/// - Integração com personalidades
/// - Design consistente com Metamorfose
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 29-05-2025
/// Last modified: 29-05-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/plant_personality_selector.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/components/mode_switcher.dart';
import 'package:metamorfose_flutter/blocs/text_chat_bloc.dart';
// Import removido pois não é mais usado diretamente
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart';

class TextChatScreen extends StatefulWidget {
  const TextChatScreen({super.key});

  @override
  State<TextChatScreen> createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  PersonalityType _currentPersonality = PersonalityType.padrao;
  ChatMode _currentMode = ChatMode.text;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    
    context.read<TextChatBloc>().add(SendMessageEvent(text, _currentPersonality));
    _textController.clear();
    
    // Scroll para baixo após enviar mensagem
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onPersonalityChanged(PersonalityType personality) {
    setState(() {
      _currentPersonality = personality;
    });
    debugPrint("🎭 Mudando personalidade para: ${personality.name}");
  }

  void _onModeChanged(ChatMode mode) {
    setState(() {
      _currentMode = mode;
    });
    
    if (mode == ChatMode.voice) {
      debugPrint("🎤 Mudando para modo de voz");
      // Aguarda a animação do ModeSwitcher concluir antes de navegar
      Future.delayed(const Duration(milliseconds: 330), () {
        if (!mounted) return;
        context.go(Routes.voiceChat);
      });
    } else {
      debugPrint("💬 Mantendo modo de texto");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background com ondas (similar ao onboarding)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/images/onboarding/bg_wave_2.svg',
                width: screenSize.width,
                height: screenSize.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
            
            // Conteúdo principal
            Column(
              children: [
                // Seletor de personalidade (exatamente igual à tela de voz)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 56,
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.purpleNormal,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: BlocBuilder<TextChatBloc, TextChatState>(
                    builder: (context, state) {
                      return PersonalitySelector(
                        currentPersonality: _currentPersonality,
                        onPersonalityChanged: _onPersonalityChanged,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Seletor de modo (Voz ↔️ Chat)
                ModeSwitcher(
                  currentMode: _currentMode,
                  onModeChanged: _onModeChanged,
                ),

                const SizedBox(height: 20),
                
                // Avatar da planta
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Avatar estático
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: MetamorfoseColors.greenNormal.withOpacity(0.3),
                              blurRadius: 40,
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: MetamorfoseColors.whiteLight,
                          child: SvgPicture.asset(
                            'assets/images/plantsetup/plantsetup.svg',
                            width: 90,
                            height: 90,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Nome da planta
                      Text(
                        'Perona',
                        style: TextStyle(
                          color: MetamorfoseColors.blackNormal,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DinNext',
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Status baseado no estado do BLoC
                      BlocBuilder<TextChatBloc, TextChatState>(
                        builder: (context, state) {
                          final isProcessing = state.isLoading;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isProcessing
                                  ? MetamorfoseColors.purpleLight.withOpacity(0.2)
                                  : MetamorfoseColors.greenLight.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isProcessing
                                    ? MetamorfoseColors.purpleNormal
                                    : MetamorfoseColors.greenNormal,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isProcessing
                                        ? MetamorfoseColors.purpleNormal
                                        : MetamorfoseColors.greenNormal,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isProcessing 
                                      ? '🤔 Pensando...'
                                      : '🌱 Pronta para conversar',
                                  style: TextStyle(
                                    color: MetamorfoseColors.blackNormal,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'DinNext',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Mensagens
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: BlocBuilder<TextChatBloc, TextChatState>(
                      builder: (context, state) {
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (message.isUser) 
                                    const Spacer()
                                  else
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: MetamorfoseColors.greenLight,
                                      child: SvgPicture.asset(
                                        'assets/images/plantsetup/plantsetup.svg',
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: message.isUser 
                                            ? MetamorfoseColors.purpleNormal
                                            : MetamorfoseColors.greenLight.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(16),
                                        border: message.isUser 
                                            ? null
                                            : Border.all(color: MetamorfoseColors.greenNormal.withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        message.content,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: message.isUser 
                                              ? MetamorfoseColors.whiteLight
                                              : MetamorfoseColors.blackNormal,
                                          fontFamily: 'DinNext',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  if (!message.isUser) 
                                    const Spacer()
                                  else
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: MetamorfoseColors.purpleNormal,
                                      child: const Icon(Icons.person, color: Colors.white, size: 18),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                
                // Indicador de erro
                BlocBuilder<TextChatBloc, TextChatState>(
                  builder: (context, state) {
                    if (state.error != null) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: MetamorfoseColors.redLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MetamorfoseColors.redNormal),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: MetamorfoseColors.redNormal, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Erro: ${state.error}',
                                style: TextStyle(
                                  color: MetamorfoseColors.redNormal,
                                  fontSize: 14,
                                  fontFamily: 'DinNext',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                // Campo de texto
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Campo de texto
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: BlocBuilder<TextChatBloc, TextChatState>(
                                builder: (context, chatState) {
                                  return TextField(
                                    controller: _textController,
                                    enabled: !chatState.isLoading,
                                    style: TextStyle(
                                      color: MetamorfoseColors.blackNormal,
                                      fontFamily: 'DinNext',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Digite sua mensagem...',
                                      hintStyle: TextStyle(
                                        color: MetamorfoseColors.greyMedium,
                                        fontFamily: 'DinNext',
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    onSubmitted: (_) => _sendMessage(),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          BlocBuilder<TextChatBloc, TextChatState>(
                            builder: (context, chatState) {
                              return GestureDetector(
                                onTap: chatState.isLoading ? null : _sendMessage,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: chatState.isLoading 
                                        ? LinearGradient(
                                            colors: [
                                              MetamorfoseColors.greyMedium,
                                              MetamorfoseColors.greyLight,
                                            ],
                                          )
                                        : LinearGradient(
                                            colors: [
                                              MetamorfoseColors.purpleLight,
                                              MetamorfoseColors.purpleNormal,
                                            ],
                                          ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    chatState.isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Instruções
                      BlocBuilder<TextChatBloc, TextChatState>(
                        builder: (context, chatState) {
                          return Text(
                            chatState.isLoading 
                                ? '🤔 Processando sua mensagem...'
                                : '🌱 Digite sua mensagem e toque em enviar',
                            style: TextStyle(
                              color: MetamorfoseColors.blackNormal,
                              fontSize: 14,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationMenu(activeIndex: 2),
    );
  }
}
