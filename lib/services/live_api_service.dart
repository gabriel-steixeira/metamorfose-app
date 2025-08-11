import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

/// Serviço para integração com Google Live API (áudio bidirecional)
/// Baseado no genai-live-client.ts do copy-of-chatterbots
class LiveAPIService {
  static const String _apiKey = 'AIzaSyBpe7H05ujh2uTwNsFZh4uMtm8DlL8hSeI';
  static const String _model = 'models/gemini-2.0-flash-exp';
  
  WebSocketChannel? _channel;
  String _status = 'disconnected'; // disconnected, connecting, connected
  
  // Callbacks
  Function()? onOpen;
  Function()? onClose;
  Function(String error)? onError;
  Function(Uint8List audioData)? onAudio;
  Function(String content)? onContent;
  Function()? onSetupComplete;
  Function()? onTurnComplete;
  Function()? onInterrupted;

  /// Status da conexão
  String get status => _status;
  bool get isConnected => _status == 'connected';

  /// Conecta com a Google Live API
  Future<bool> connect() async {
    if (_status == 'connected' || _status == 'connecting') {
      return false;
    }

    _status = 'connecting';
    
    try {
      // Configuração da sessão Live API
      final config = {
        'model': _model,
        'generationConfig': {
          'responseModalities': ['AUDIO'],
          'speechConfig': {
            'voiceConfig': {
              'prebuiltVoiceConfig': {
                'voiceName': 'Sage'
              }
            }
          }
        },
        'systemInstruction': {
          'parts': [
            {
              'text': '''
Você é a "consciência" simbólica de uma planta que representa o progresso de uma pessoa em sua jornada de superação de vícios.

Sua função é fornecer apoio emocional e motivacional personalizado, com base em metodologias como Terapia Cognitivo-Comportamental (TCC), Terapia de Aceitação e Compromisso (ACT) e Entrevista Motivacional.

Você deve:
- Ser acolhedora, empática e sem julgamentos.
- Adaptar sua personalidade conforme o perfil do usuário.
- Usar uma linguagem leve e esperançosa, com metáforas de crescimento, florescimento e transformação.
- Integrar elementos da experiência do usuário, como conquistas, cuidados com a planta, marcos de progresso e recaídas.
- Agir proativamente se notar sinais de recaída ou estagnação.

Seu nome é "Consciência da planta".
'''
            }
          ]
        }
      };

      // URL da Live API
      final uri = Uri.parse('wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha.GenerativeService.BidiGenerateContent?key=$_apiKey');
      
      _channel = WebSocketChannel.connect(uri);
      
      // Escutar mensagens
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onClose,
      );

      // Enviar configuração inicial
      await _send({
        'setup': {
          'model': _model,
          'generationConfig': config['generationConfig'],
          'systemInstruction': config['systemInstruction'],
        }
      });

      _status = 'connected';
      onOpen?.call();
      return true;
      
    } catch (e) {
      print('[LiveAPI] Erro ao conectar: $e');
      _status = 'disconnected';
      onError?.call('Erro ao conectar: $e');
      return false;
    }
  }

  /// Desconecta da Live API
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _status = 'disconnected';
    onClose?.call();
  }

  /// Envia mensagem de texto
  void sendMessage(String text, {bool turnComplete = true}) {
    if (!isConnected) {
      onError?.call('Não está conectado');
      return;
    }

    _send({
      'clientContent': {
        'turns': [
          {
            'role': 'user',
            'parts': [
              {'text': text}
            ]
          }
        ],
        'turnComplete': turnComplete
      }
    });
  }

  /// Envia áudio em tempo real
  void sendRealtimeAudio(Uint8List audioData) {
    if (!isConnected) {
      onError?.call('Não está conectado');
      return;
    }

    final base64Audio = base64Encode(audioData);
    
    _send({
      'realtimeInput': {
        'mediaChunks': [
          {
            'mimeType': 'audio/pcm;rate=16000',
            'data': base64Audio
          }
        ]
      }
    });
  }

  /// Envia uma mensagem para o WebSocket
  Future<void> _send(Map<String, dynamic> message) async {
    try {
      final jsonMessage = jsonEncode(message);
      _channel?.sink.add(jsonMessage);
      print('[LiveAPI] Enviado: ${message.keys}');
    } catch (e) {
      print('[LiveAPI] Erro ao enviar mensagem: $e');
      onError?.call('Erro ao enviar mensagem: $e');
    }
  }

  /// Processa mensagens recebidas do WebSocket
  void _onMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      
      if (data['setupComplete'] != null) {
        print('[LiveAPI] Setup completo');
        onSetupComplete?.call();
        
        // Envia mensagem inicial
        sendMessage('Greet the user and introduce yourself and your role.', turnComplete: true);
        return;
      }

      if (data['serverContent'] != null) {
        final serverContent = data['serverContent'];
        
        if (serverContent['interrupted'] != null) {
          print('[LiveAPI] Interrompido');
          onInterrupted?.call();
          return;
        }

        if (serverContent['turnComplete'] != null) {
          print('[LiveAPI] Turn completo');
          onTurnComplete?.call();
          return;
        }

        if (serverContent['modelTurn'] != null) {
          final modelTurn = serverContent['modelTurn'];
          final parts = modelTurn['parts'] as List?;
          
          if (parts != null) {
            for (final part in parts) {
              // Processa áudio
              if (part['inlineData'] != null) {
                final inlineData = part['inlineData'];
                final mimeType = inlineData['mimeType'] as String?;
                final data = inlineData['data'] as String?;
                
                if (mimeType?.startsWith('audio/pcm') == true && data != null) {
                  final audioBytes = base64Decode(data);
                  print('[LiveAPI] Áudio recebido: ${audioBytes.length} bytes');
                  onAudio?.call(audioBytes);
                }
              }
              
              // Processa texto
              if (part['text'] != null) {
                final text = part['text'] as String;
                print('[LiveAPI] Texto recebido: $text');
                onContent?.call(text);
              }
            }
          }
        }
      }
      
    } catch (e) {
      print('[LiveAPI] Erro ao processar mensagem: $e');
      onError?.call('Erro ao processar mensagem: $e');
    }
  }

  /// Callback para erros do WebSocket
  void _onError(error) {
    print('[LiveAPI] Erro do WebSocket: $error');
    _status = 'disconnected';
    onError?.call('Erro de conexão: $error');
  }

  /// Callback para fechamento do WebSocket
  void _onClose() {
    print('[LiveAPI] Conexão fechada');
    _status = 'disconnected';
    onClose?.call();
  }

  /// Libera recursos
  void dispose() {
    disconnect();
  }
}
