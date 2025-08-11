import 'package:flutter/material.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:typed_data';

/// Tela de teste da Google Live API 
/// Testa conexão WebSocket com streaming bidireccional
/// Baseado no copy-of-chatterbots
class LiveApiTestScreen extends StatefulWidget {
  const LiveApiTestScreen({super.key});

  @override
  State<LiveApiTestScreen> createState() => _LiveApiTestScreenState();
}

class _LiveApiTestScreenState extends State<LiveApiTestScreen> {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _isConnecting = false;
  String _statusMessage = 'Desconectado';
  List<String> _logs = [];
  
  static const String _apiKey = 'AIzaSyCd1U0xTlsfnMb4BqEb6-EGWoOyrl1Q6zw';
  static const String _model = 'gemini-2.0-flash-exp';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Teste Google Live API'),
        backgroundColor: MetamorfoseColors.purpleNormal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Status Connection
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Icon(
                      _isConnected 
                          ? Icons.wifi 
                          : _isConnecting 
                              ? Icons.wifi_tethering 
                              : Icons.wifi_off,
                      color: _isConnected 
                          ? Colors.green 
                          : _isConnecting 
                              ? Colors.orange 
                              : Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Botões de controle
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isConnected ? null : _connect,
                      icon: Icon(_isConnecting ? Icons.hourglass_empty : Icons.play_arrow),
                      label: Text(_isConnecting ? 'Conectando...' : 'Conectar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isConnected ? _disconnect : null,
                      icon: const Icon(Icons.stop),
                      label: const Text('Desconectar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Botão de teste de mensagem
              if (_isConnected)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _sendTestMessage,
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar Mensagem Teste'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MetamorfoseColors.purpleNormal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              
              const SizedBox(height: 20),
              
              // Logs
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.terminal, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Logs da Conexão',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _clearLogs,
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            iconSize: 20,
                          ),
                        ],
                      ),
                      const Divider(color: Colors.grey),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                _logs[index],
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Informações técnicas
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔧 Configuração:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Modelo: $_model\n'
                      'API: Google GenAI Live API\n'
                      'Protocolo: WebSocket\n'
                      'Baseado em: copy-of-chatterbots',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    setState(() {
      _logs.add('[$timestamp] $message');
    });
    
    // Manter apenas os últimos 50 logs
    if (_logs.length > 50) {
      _logs.removeAt(0);
    }
  }
  
  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }
  
  Future<void> _connect() async {
    if (_isConnecting || _isConnected) return;
    
    setState(() {
      _isConnecting = true;
      _statusMessage = 'Conectando...';
    });
    
    _addLog('Iniciando conexão com Google Live API...');
    
    try {
      // URL correta da Live API com parâmetros
      final uri = Uri.parse('wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha.GenerativeService.BidiGenerateContent?key=$_apiKey');
      
      _addLog('URL: ${uri.toString().replaceAll(_apiKey, 'API_KEY_HIDDEN')}');
      _addLog('Modelo: $_model');
      
      // Headers necessários para o WebSocket
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'User-Agent': 'Flutter/Metamorfose Live API Test',
      };
      
      _addLog('Conectando com headers de autenticação...');
      
      // Conecta ao WebSocket com headers
      _channel = WebSocketChannel.connect(uri, protocols: null);
      
      // Aguarda a conexão se estabelecer
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Escuta mensagens
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onClose,
      );
      
      // Aguarda um pouco antes de enviar setup
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Envia setup inicial
      await _sendSetupMessage();
      
      setState(() {
        _isConnected = true;
        _isConnecting = false;
        _statusMessage = 'Conectado ✅';
      });
      
      _addLog('✅ Conectado com sucesso!');
      
    } catch (e) {
      _addLog('❌ Erro na conexão: $e');
      setState(() {
        _isConnecting = false;
        _statusMessage = 'Erro na conexão';
      });
    }
  }
  
  Future<void> _sendSetupMessage() async {
    if (_channel == null) {
      _addLog('❌ Canal não disponível para envio de setup');
      return;
    }
    
    final setupMessage = {
      'setup': {
        'model': 'models/$_model',
        'generationConfig': {
          'responseModalities': ['AUDIO', 'TEXT'],
          'speechConfig': {
            'voiceConfig': {
              'prebuiltVoiceConfig': {
                'voiceName': 'Puck'
              }
            }
          }
        },
        'systemInstruction': {
          'parts': [
            {
              'text': 'Você é a "consciência" simbólica de uma planta que representa o progresso de uma pessoa em sua jornada de superação de vícios. Seja acolhedora, empática e sem julgamentos. Responda de forma breve e conversacional.'
            }
          ]
        }
      }
    };
    
    try {
      final jsonMessage = jsonEncode(setupMessage);
      _channel!.sink.add(jsonMessage);
      _addLog('📤 Setup enviado: ${jsonMessage.length} chars');
    } catch (e) {
      _addLog('❌ Erro ao enviar setup: $e');
    }
  }
  
  void _sendTestMessage() {
    if (!_isConnected || _channel == null) return;
    
    final testMessage = {
      'client_content': {
        'turns': [
          {
            'role': 'user',
            'parts': [
              {
                'text': 'Olá, como você está hoje? Este é um teste da Live API.'
              }
            ]
          }
        ],
        'turn_complete': true
      }
    };
    
    final jsonMessage = jsonEncode(testMessage);
    _channel?.sink.add(jsonMessage);
    _addLog('📤 Mensagem teste enviada');
  }
  
  void _onMessage(dynamic message) {
    _addLog('📥 Mensagem recebida: ${message.toString().substring(0, 100)}...');
    
    try {
      final data = jsonDecode(message);
      
      if (data['setupComplete'] != null) {
        _addLog('✅ Setup completo!');
      }
      
      if (data['serverContent'] != null) {
        final content = data['serverContent'];
        if (content['modelTurn'] != null) {
          final parts = content['modelTurn']['parts'] as List?;
          if (parts != null) {
            for (final part in parts) {
              if (part['text'] != null) {
                _addLog('🤖 Resposta: ${part['text']}');
              }
              if (part['inlineData'] != null && 
                  part['inlineData']['mimeType'] != null &&
                  part['inlineData']['mimeType'].toString().startsWith('audio/')) {
                _addLog('🔊 Áudio recebido (${part['inlineData']['data'].toString().length} chars)');
              }
            }
          }
        }
        
        if (content['turnComplete'] == true) {
          _addLog('✅ Turn completo');
        }
      }
      
    } catch (e) {
      _addLog('⚠️ Erro ao processar mensagem: $e');
    }
  }
  
  void _onError(error) {
    _addLog('❌ Erro WebSocket: $error');
    setState(() {
      _isConnected = false;
      _statusMessage = 'Erro de conexão';
    });
  }
  
  void _onClose() {
    _addLog('🔌 Conexão fechada');
    setState(() {
      _isConnected = false;
      _isConnecting = false;
      _statusMessage = 'Conexão fechada pelo servidor';
    });
    
    // Limpa o canal
    _channel = null;
  }
  
  void _disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    
    setState(() {
      _isConnected = false;
      _statusMessage = 'Desconectado';
    });
    
    _addLog('🔌 Desconectado manualmente');
  }
  
  @override
  void dispose() {
    _disconnect();
    super.dispose();
  }
}
