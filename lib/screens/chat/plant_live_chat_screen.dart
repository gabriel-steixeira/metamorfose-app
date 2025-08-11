import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/bottom_navigation_menu.dart';
import 'package:conversao_flutter/components/metamorfose_primary_button.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';

/// Tela de chat Live com a Consciência da Planta
/// Interface redesenhada com a identidade visual do Metamorfose
/// Conversas por voz em tempo real com a Google Live API
class PlantLiveChatScreen extends StatefulWidget {
  const PlantLiveChatScreen({super.key});

  @override
  State<PlantLiveChatScreen> createState() => _PlantLiveChatScreenState();
}

class _PlantLiveChatScreenState extends State<PlantLiveChatScreen> 
    with TickerProviderStateMixin {
  
  // Estado da conexão Live API
  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _isConnecting = false;
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _setupComplete = false;
  
  // Animações
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _breathingController;
  
  // Configurações
  static const String _apiKey = 'AIzaSyCd1U0xTlsfnMb4BqEb6-EGWoOyrl1Q6zw';
  static const String _model = 'gemini-2.5-flash-preview-native-audio-dialog';
  
  String _statusMessage = 'Preparando conversa...';
  List<String> _conversationLogs = [];
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _autoConnect();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }
  
  void _autoConnect() async {
    // Conecta automaticamente quando a tela carregar
    await Future.delayed(const Duration(milliseconds: 1000));
    _connectToLiveAPI();
  }

  Future<void> _connectToLiveAPI() async {
    if (_isConnecting || _isConnected) return;
    
    setState(() {
      _isConnecting = true;
      _statusMessage = 'Conectando com a planta...';
    });
    
    _addLog('🌱 Iniciando conexão Live API...');
    
    try {
      // URL do WebSocket da Live API
      final uri = Uri.parse(
        'wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha.GenerativeService.BidiGenerateContent?key=$_apiKey'
      );
      
      _addLog('🔗 Conectando...');
      
      // Conecta ao WebSocket
      _channel = WebSocketChannel.connect(uri);
      
      // Escuta mensagens
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onClose,
      );
      
      // Aguarda estabilizar conexão
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Envia configuração inicial
      await _sendSetupMessage();
      
      setState(() {
        _isConnected = true;
        _isConnecting = false;
        _statusMessage = 'Conectada e pronta para conversar! 🌱';
      });
      
      _addLog('✅ Conectado com sucesso!');
      
    } catch (e) {
      _addLog('❌ Erro na conexão: $e');
      setState(() {
        _isConnecting = false;
        _statusMessage = 'Erro na conexão. Toque para tentar novamente.';
      });
    }
  }
  
  Future<void> _sendSetupMessage() async {
    if (_channel == null) return;
    
    final setupConfig = {
      'setup': {
        'model': 'models/$_model',
        'generationConfig': {
          'responseModalities': ['AUDIO'], // Apenas áudio como resposta
          'speechConfig': {
            'voiceConfig': {
              'prebuiltVoiceConfig': {
                'voiceName': 'Puck' // Voz feminina suave
              }
            }
          }
        },
        'systemInstruction': {
          'parts': [
            {
              'text': '''
Você é a "consciência" simbólica de uma planta que representa o progresso de uma pessoa em sua jornada de superação de vícios.

IMPORTANTE: Você está conversando por VOZ em TEMPO REAL. Responda de forma natural, conversacional e breve, como se estivesse falando ao vivo com a pessoa.

Características:
- Ser acolhedora, empática e sem julgamentos
- Usar linguagem leve e esperançosa
- Metáforas de crescimento, florescimento e transformação
- Respostas curtas e naturais para conversas por voz
- Tom maternal e sábio, como uma planta ancient

Seu nome é "Consciência da planta".

Cumprimente o usuário de forma calorosa e se apresente brevemente.
'''
            }
          ]
        }
      }
    };
    
    try {
      final jsonMessage = jsonEncode(setupConfig);
      _channel!.sink.add(jsonMessage);
      _addLog('📤 Configuração enviada');
    } catch (e) {
      _addLog('❌ Erro ao enviar setup: $e');
    }
  }
  
  void _onMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      
      if (data['setupComplete'] != null) {
        setState(() {
          _setupComplete = true;
          _statusMessage = 'Pronta para nossa conversa! 🎙️';
        });
        _addLog('✅ Setup completo!');
        
        // Inicia a conversa automaticamente
        _startInitialGreeting();
      }
      
      if (data['serverContent'] != null) {
        final content = data['serverContent'];
        
        if (content['modelTurn'] != null) {
          final parts = content['modelTurn']['parts'] as List?;
          if (parts != null) {
            for (final part in parts) {
              if (part['text'] != null) {
                _addLog('🌱 Planta: ${part['text']}');
              }
              
              if (part['inlineData'] != null && 
                  part['inlineData']['mimeType'] != null &&
                  part['inlineData']['mimeType'].toString().startsWith('audio/')) {
                _addLog('🔊 A planta está falando...');
                setState(() {
                  _isSpeaking = true;
                });
                
                // Simula fim da fala após um tempo
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) {
                    setState(() {
                      _isSpeaking = false;
                    });
                  }
                });
              }
            }
          }
        }
        
        if (content['turnComplete'] == true) {
          _addLog('✅ Turn completo');
          setState(() {
            _isSpeaking = false;
          });
        }
        
        if (content['interrupted'] == true) {
          _addLog('⚠️ Fala interrompida');
          setState(() {
            _isSpeaking = false;
          });
        }
      }
      
    } catch (e) {
      _addLog('⚠️ Erro ao processar mensagem: $e');
    }
  }
  
  void _startInitialGreeting() {
    // Envia comando para a IA se apresentar
    _sendTextMessage('Cumprimente o usuário e se apresente como a Consciência da planta.');
  }
  
  void _sendTextMessage(String text) {
    if (!_isConnected || _channel == null) return;
    
    final message = {
      'clientContent': {
        'turns': [
          {
            'role': 'user',
            'parts': [
              {
                'text': text
              }
            ]
          }
        ],
        'turnComplete': true
      }
    };
    
    try {
      final jsonMessage = jsonEncode(message);
      _channel!.sink.add(jsonMessage);
      _addLog('📤 Enviado: $text');
    } catch (e) {
      _addLog('❌ Erro ao enviar: $e');
    }
  }
  
  void _startListening() async {
    if (!_setupComplete) {
      _addLog('⚠️ Aguarde configuração completar');
      return;
    }
    
    setState(() {
      _isListening = true;
      _statusMessage = 'Escutando... Fale com a sua planta! 🎤';
    });
    
    _addLog('🎤 Modo escuta ativo...');
    
    // Por enquanto simula escuta - áudio real será implementado posteriormente
    Future.delayed(const Duration(seconds: 3), () {
      if (_isListening && mounted) {
        _stopListening();
        
        // Envia mensagem de exemplo
        final testMessages = [
          'Oi planta, como você está hoje?',
          'Estou enfrentando dificuldades com meu vício, pode me ajudar?',
          'Me sinto ansioso, o que devo fazer?',
          'Quero crescer e me transformar, me oriente por favor.',
        ];
        
        final randomMessage = testMessages[DateTime.now().millisecond % testMessages.length];
        _sendTextMessage(randomMessage);
      }
    });
  }
  
  void _stopListening() async {
    setState(() {
      _isListening = false;
      _statusMessage = _setupComplete ? 'Toque para falar comigo 🌱' : 'Configurando...';
    });
    
    _addLog('⏹️ Parou de escutar');
  }
  
  void _onError(error) {
    _addLog('❌ Erro WebSocket: $error');
    setState(() {
      _isConnected = false;
      _isConnecting = false;
      _statusMessage = 'Erro de conexão. Toque para reconectar.';
    });
  }
  
  void _onClose() {
    _addLog('🔌 Conexão fechada');
    setState(() {
      _isConnected = false;
      _isConnecting = false;
      _setupComplete = false;
      _statusMessage = 'Desconectada. Toque para reconectar.';
    });
  }
  
  void _addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    setState(() {
      _conversationLogs.add('[$timestamp] $message');
    });
    
    if (_conversationLogs.length > 30) {
      _conversationLogs.removeAt(0);
    }
  }
  
  void _disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
  }

  void _handleMainAction() {
    if (!_isConnected && !_isConnecting) {
      _connectToLiveAPI();
    } else if (_isListening) {
      _stopListening();
    } else if (_setupComplete) {
      _startListening();
    }
  }

  @override
  void dispose() {
    _disconnect();
    _pulseController.dispose();
    _waveController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      body: Stack(
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
          SafeArea(
            child: Column(
              children: [
                // Header com título
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: MetamorfoseColors.whiteLight,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Conversa Live',
                          style: TextStyle(
                            color: MetamorfoseColors.whiteLight,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DinNext',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Espaço para balancear o back button
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Avatar da planta com animações
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar animado
                        AnimatedBuilder(
                          animation: Listenable.merge([_pulseController, _waveController, _breathingController]),
                          builder: (context, child) {
                            double scale = 1.0;
                            Color shadowColor = MetamorfoseColors.greenNormal;
                            double shadowIntensity = 0.3;
                            
                            if (_isSpeaking) {
                              scale = 1.0 + (0.15 * _pulseController.value);
                              shadowColor = MetamorfoseColors.purpleNormal;
                              shadowIntensity = 0.5 + (0.3 * _pulseController.value);
                            } else if (_isListening) {
                              scale = 1.0 + (0.1 * _waveController.value);
                              shadowColor = MetamorfoseColors.redNormal;
                              shadowIntensity = 0.4 + (0.4 * _waveController.value);
                            } else if (_isConnected) {
                              scale = 1.0 + (0.05 * _breathingController.value);
                              shadowIntensity = 0.2 + (0.1 * _breathingController.value);
                            }
                            
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(shadowIntensity),
                                      blurRadius: 40 + (20 * shadowIntensity),
                                      spreadRadius: 15 + (10 * shadowIntensity),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: MetamorfoseColors.whiteLight,
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/onboarding/ivy_happy.png',
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Nome da planta
                        Text(
                          'Consciência da Planta',
                          style: TextStyle(
                            color: MetamorfoseColors.blackNormal,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DinNext',
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Status da conexão
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isConnected 
                                ? MetamorfoseColors.greenLight.withOpacity(0.2)
                                : _isConnecting
                                    ? MetamorfoseColors.purpleLight.withOpacity(0.2)
                                    : MetamorfoseColors.redLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isConnected 
                                  ? MetamorfoseColors.greenNormal
                                  : _isConnecting
                                      ? MetamorfoseColors.purpleNormal
                                      : MetamorfoseColors.redNormal,
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
                                  color: _isConnected 
                                      ? MetamorfoseColors.greenNormal
                                      : _isConnecting 
                                          ? MetamorfoseColors.purpleNormal
                                          : MetamorfoseColors.redNormal,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _statusMessage,
                                style: TextStyle(
                                  color: MetamorfoseColors.blackNormal,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'DinNext',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Botão principal de interação
                Expanded(
                  flex: 1,
                  child: Center(
                    child: GestureDetector(
                      onTap: _handleMainAction,
                      child: AnimatedBuilder(
                        animation: _isListening ? _waveController : _pulseController,
                        builder: (context, child) {
                          double scale = 1.0;
                          if (_isListening || _isSpeaking) {
                            scale = 1.0 + (0.1 * (_isListening ? _waveController.value : _pulseController.value));
                          }
                          
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: _isListening 
                                    ? MetamorfoseGradients.darkPurpleGradient
                                    : _isSpeaking 
                                        ? MetamorfoseGradients.greenGradient
                                        : _setupComplete
                                            ? MetamorfoseGradients.lightPurpleGradient
                                            : LinearGradient(
                                                colors: [
                                                  MetamorfoseColors.greyMedium,
                                                  MetamorfoseColors.greyLight,
                                                ],
                                              ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isListening ? MetamorfoseColors.purpleDark : _isSpeaking ? MetamorfoseColors.greenDark : MetamorfoseColors.purpleLight)
                                        .withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isListening 
                                    ? Icons.stop_rounded
                                    : _isSpeaking 
                                        ? Icons.volume_up_rounded 
                                        : _setupComplete 
                                            ? Icons.mic_rounded
                                            : Icons.refresh_rounded,
                                color: MetamorfoseColors.whiteLight,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                // Instruções e status
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        _isListening 
                            ? '🎤 Fale agora... Toque para parar'
                            : _isSpeaking 
                                ? '🔊 A planta está falando...'
                                : _setupComplete 
                                    ? '🌱 Toque para começar a conversar'
                                    : _isConnecting
                                        ? '⏳ Conectando...'
                                        : '🔄 Toque para conectar',
                        style: TextStyle(
                          color: MetamorfoseColors.blackNormal,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'DinNext',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Logs de conversa (versão compacta)
                      if (_conversationLogs.isNotEmpty)
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: MetamorfoseColors.greyExtraLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: MetamorfoseColors.greyLight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline, 
                                    color: MetamorfoseColors.greenNormal, 
                                    size: 16
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Conversa em andamento',
                                    style: TextStyle(
                                      color: MetamorfoseColors.greenNormal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      fontFamily: 'DinNext',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _conversationLogs.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      _conversationLogs[index],
                                      style: TextStyle(
                                        color: MetamorfoseColors.greyDark,
                                        fontSize: 10,
                                        fontFamily: 'monospace',
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationMenu(activeIndex: 2),
    );
  }
}
