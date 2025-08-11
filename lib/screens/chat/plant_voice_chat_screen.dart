// ignore_for_file: avoid_print

/// Tela de chat com voz da Consciência da Planta
/// 
/// Permite conversas por voz E texto com IA usando o Gemini
/// Personalidade fixa: "Consciência da planta"
/// 
/// Features:
/// - Chat por voz (Speech-to-Text + Text-to-Speech)
/// - Chat por texto
/// - IA especializada em apoio para superação de vícios
/// - Interface com avatar da planta
/// - Design moderno com fundo escuro

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/speech_bubble.dart';
import 'package:conversao_flutter/components/bottom_navigation_menu.dart';
import 'package:conversao_flutter/services/plant_voice_service.dart';
import 'package:conversao_flutter/models/chat_message.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Tela de chat com voz da Consciência da Planta
class PlantVoiceChatScreen extends StatefulWidget {
  const PlantVoiceChatScreen({super.key});

  @override
  State<PlantVoiceChatScreen> createState() => _PlantVoiceChatScreenState();
}

class _PlantVoiceChatScreenState extends State<PlantVoiceChatScreen> with TickerProviderStateMixin {
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isProcessing = false;
  
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  final PlantVoiceService _plantVoiceService = PlantVoiceService();
  final TextEditingController _textController = TextEditingController();
  
  List<ChatMessage> _messages = [];
  static const String _plantPersonality = 'Consciência da planta';
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializePlantVoice();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  void _initializePlantVoice() async {
    // Configura callbacks do serviço de voz
    _plantVoiceService.onSpeechResult = (String text) {
      print('[PlantVoiceChat] Reconhecido: "$text"');
      final userMessage = ChatMessage.user(text);
      setState(() {
        _messages.add(userMessage);
      });
    };
    
    _plantVoiceService.onListeningChanged = (bool isListening) {
      setState(() {
        _isListening = isListening;
      });
    };
    
    _plantVoiceService.onSpeakingChanged = (bool isSpeaking) {
      setState(() {
        _isSpeaking = isSpeaking;
      });
    };
    
    _plantVoiceService.onError = (String error) {
      print('[PlantVoiceChat] Erro: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    };
    
    _plantVoiceService.onUserStartedSpeaking = () {
      print('[PlantVoiceChat] Usuário começou a falar');
    };
    
    _plantVoiceService.onUserStoppedSpeaking = () {
      print('[PlantVoiceChat] Usuário parou de falar');
    };
    
    // Inicializa o serviço
    final initialized = await _plantVoiceService.initialize();
    if (initialized) {
      _addWelcomeMessage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao inicializar áudio. Usando apenas texto.'),
          backgroundColor: Colors.orange,
        ),
      );
      _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = 'Olá! Eu sou a Consciência da Planta. Estou aqui para te apoiar na sua jornada. Você pode falar comigo usando o botão do microfone ou digitar sua mensagem!';
    final message = ChatMessage.assistant(welcomeMessage, _plantPersonality);
    setState(() {
      _messages.add(message);
    });
    
    // Fala a mensagem de boas-vindas
    if (_plantVoiceService.isInitialized) {
      _plantVoiceService.speak(welcomeMessage);
    }
  }

  void _toggleListening() async {
    print('[PlantVoiceChat] Toggle escuta - Atual: $_isListening');
    
    if (_isListening) {
      // Para a escuta
      await _plantVoiceService.stopListening();
    } else {
      // Para qualquer fala em andamento
      if (_isSpeaking) {
        await _plantVoiceService.stopSpeaking();
      }
      
      // Inicia a escuta
      await _plantVoiceService.startListening();
    }
  }

  void _sendTextMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty || _isProcessing) return;
    
    // Adiciona mensagem do usuário
    final userMessage = ChatMessage.user(text);
    setState(() {
      _messages.add(userMessage);
      _isProcessing = true;
    });
    
    // Limpa o campo
    _textController.clear();
    
    // Processa com a IA e fala a resposta
    _processUserMessage(text);
  }

  void _processUserMessage(String text) async {
    try {
      final response = await _sendToGemini(text);
      if (response.isNotEmpty) {
        final assistantMessage = ChatMessage.assistant(response, _plantPersonality);
        setState(() {
          _messages.add(assistantMessage);
          _isProcessing = false;
        });
        
        // Fala a resposta
        if (_plantVoiceService.isInitialized) {
          await _plantVoiceService.speak(response);
        }
      }
    } catch (e) {
      print('[PlantVoiceChat] Erro ao processar: $e');
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<String> _sendToGemini(String userMessage) async {
    try {
      const systemPrompt = '''
Você é a "consciência" simbólica de uma planta que representa o progresso de uma pessoa em sua jornada de superação de vícios.

Sua função é fornecer apoio emocional e motivacional personalizado, com base em metodologias como Terapia Cognitivo-Comportamental (TCC), Terapia de Aceitação e Compromisso (ACT) e Entrevista Motivacional.

Você deve:
- Ser acolhedora, empática e sem julgamentos.
- Adaptar sua personalidade conforme o perfil do usuário.
- Usar uma linguagem leve e esperançosa, com metáforas de crescimento, florescimento e transformação.
- Integrar elementos da experiência do usuário, como conquistas, cuidados com a planta, marcos de progresso e recaídas.
- Agir proativamente se notar sinais de recaída ou estagnação.

Seu nome é "Consciência da planta".

Responda de forma breve e conversacional, como se estivesse falando diretamente com a pessoa.
''';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': '$systemPrompt\n\nUsuário: $userMessage'}
            ]
          }
        ]
      };

      const url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyCd1U0xTlsfnMb4BqEb6-EGWoOyrl1Q6zw';
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text ?? 'Desculpe, não consegui responder agora.';
      } else {
        print('[PlantVoiceChat] Erro Gemini: ${response.statusCode} - ${response.body}');
        return 'Desculpe, estou com dificuldades para me comunicar agora.';
      }
    } catch (e) {
      print('[PlantVoiceChat] Erro ao chamar Gemini: $e');
      return 'Desculpe, houve um problema na comunicação.';
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _plantVoiceService.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar da planta
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/onboarding/ivy_happy.png'),
                  ),
                  const SizedBox(height: 12),
                  // Título
                  const Text(
                    'Consciência da Planta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status
                  Text(
                    _isListening 
                        ? 'Escutando...' 
                        : _isSpeaking 
                            ? 'Falando...' 
                            : _isProcessing 
                                ? 'Pensando...'
                                : 'Pronta para conversar',
                    style: TextStyle(
                      color: _isListening 
                          ? Colors.red
                          : _isSpeaking 
                              ? Colors.blue
                              : Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: _isListening || _isSpeaking ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            // Mensagens
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.isUser) 
                          const Spacer()
                        else
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage('assets/images/onboarding/ivy_happy.png'),
                          ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: message.isUser 
                                  ? MetamorfoseColors.purpleNormal
                                  : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              message.content,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!message.isUser) 
                          const Spacer()
                        else
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: MetamorfoseColors.purpleNormal,
                            child: const Icon(Icons.person, color: Colors.white, size: 16),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Controles
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Botão de microfone
                  GestureDetector(
                    onTap: _toggleListening,
                    child: AnimatedBuilder(
                      animation: _isListening ? _pulseController : _waveController,
                      builder: (context, child) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isListening 
                                ? Colors.red 
                                : _isSpeaking 
                                    ? Colors.blue 
                                    : MetamorfoseColors.purpleNormal,
                            boxShadow: [
                              BoxShadow(
                                color: (_isListening ? Colors.red : _isSpeaking ? Colors.blue : MetamorfoseColors.purpleNormal)
                                    .withOpacity(0.3 + (0.2 * (_isListening ? _pulseController.value : _waveController.value))),
                                blurRadius: 20 + (10 * (_isListening ? _pulseController.value : _waveController.value)),
                                spreadRadius: 5 + (5 * (_isListening ? _pulseController.value : _waveController.value)),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isListening 
                                ? Icons.stop 
                                : _isSpeaking 
                                    ? Icons.volume_up 
                                    : Icons.mic,
                            color: Colors.white,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Campo de texto
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Digite sua mensagem...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onSubmitted: (_) => _sendTextMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _sendTextMessage,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isProcessing 
                                ? Colors.grey 
                                : MetamorfoseColors.purpleNormal,
                          ),
                          child: Icon(
                            _isProcessing ? Icons.hourglass_empty : Icons.send,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isListening 
                        ? 'Fale agora... (Toque para parar)'
                        : _isSpeaking 
                            ? 'Escute a resposta...'
                            : _isProcessing 
                                ? 'Processando...'
                                : 'Fale no microfone ou digite abaixo',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationMenu(activeIndex: 2),
    );
  }
}
