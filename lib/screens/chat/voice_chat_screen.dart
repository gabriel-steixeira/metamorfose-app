/**
 * File: voice_chat_screen_bloc.dart
 * Description: Tela principal de chat por voz com BLoC.
 *
 * Responsabilidades:
 * - Exibir interface de chat usando BLoC
 * - Gerenciar gravação de áudio via BLoC
 * - Exibir respostas do personagem
 * - Preservar design original exatamente
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/blocs/voice_chat_bloc.dart';
import 'package:metamorfose_flutter/state/voice_chat/voice_chat_state.dart';
import 'package:metamorfose_flutter/blocs/auth_bloc.dart';
import 'package:metamorfose_flutter/models/chat_message.dart';

/// Tela principal de chat por voz com o assistente usando BLoC.
/// Permite ao usuário interagir por voz com o aplicativo.
class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    // Inicializa controladores de animação (exatamente como na original)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Inicializa o BLoC
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthBloc>().state.user?.id;
      if (uid != null) {
        context.read<VoiceChatBloc>().add(LoadChatHistoryEvent(uid));
      }
      context.read<VoiceChatBloc>().add(VoiceChatInitializeEvent());
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    context.read<VoiceChatBloc>().add(VoiceChatToggleListeningEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final uid = context.read<AuthBloc>().state.user?.id;
    
    return BlocListener<VoiceChatBloc, VoiceChatState>(
      listener: (context, state) {
        // Mostra erro se houver
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
              action: SnackBarAction(
                label: 'OK',
                textColor: MetamorfoseColors.whiteLight,
                onPressed: () {
                  context.read<VoiceChatBloc>().add(VoiceChatClearErrorEvent());
                },
              ),
            ),
          );
        }
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
              // Conteúdo principal (exatamente igual ao original)
            Column(
              children: [
                // Espaçamento superior
                SizedBox(height: screenHeight * 0.02),
                
                // Histórico de mensagens
                Expanded(
                  child: BlocBuilder<VoiceChatBloc, VoiceChatState>(
                    buildWhen: (p, c) => p.messages != c.messages,
                    builder: (context, state) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final msg = state.messages[index];
                          final isUser = msg.sender == 'user';
                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isUser ? MetamorfoseColors.purpleLight : MetamorfoseColors.greenLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'DinNext',
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                
                // Input simulado para teste (botão para enviar mensagem fixa)
                if (uid != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<VoiceChatBloc>().add(
                          SendMessageEvent(uid: uid, text: 'Olá, planta!'),
                        );
                      },
                      child: const Text('Enviar mensagem de teste'),
                    ),
                  ),
              ],
            ),
            
              // App bar inferior (com callback reativo ao BLoC)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
                child: BlocBuilder<VoiceChatBloc, VoiceChatState>(
                  buildWhen: (previous, current) => 
                      previous.isListening != current.isListening,
                  builder: (context, state) {
                    return BottomNavigationMenu(
                activeIndex: 1, // Voice icon ativo por padrão
                onItemTapped: (index) {
                  if (index == 1) {
                          // Se clicou no ícone de voice, toggle listening via BLoC
                    _toggleListening();
                  }
                },
                    );
                  },
                ),
              ),
            ],
            ),
        ),
      ),
    );
  }
} 