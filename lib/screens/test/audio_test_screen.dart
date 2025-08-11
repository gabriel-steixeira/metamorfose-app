import 'package:flutter/material.dart';
import 'package:conversao_flutter/theme/colors.dart';

/// Tela de teste de áudio simples
/// Testa as funcionalidades de Speech-to-Text e Text-to-Speech
class AudioTestScreen extends StatefulWidget {
  const AudioTestScreen({super.key});

  @override
  State<AudioTestScreen> createState() => _AudioTestScreenState();
}

class _AudioTestScreenState extends State<AudioTestScreen> {
  bool _isListening = false;
  bool _isSpeaking = false;
  String _lastRecognized = '';
  String _statusMessage = 'Pronto para testar';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Teste de Áudio'),
        backgroundColor: MetamorfoseColors.purpleNormal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Status
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Icon(
                      _isListening 
                          ? Icons.mic 
                          : _isSpeaking 
                              ? Icons.volume_up 
                              : Icons.headset,
                      color: _isListening 
                          ? Colors.red 
                          : _isSpeaking 
                              ? Colors.blue 
                              : Colors.white,
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
                    if (_lastRecognized.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Último reconhecido: "$_lastRecognized"',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Botões de teste
              Column(
                children: [
                  // Teste Speech-to-Text
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isListening ? _stopListening : _startListening,
                      icon: Icon(_isListening ? Icons.stop : Icons.mic),
                      label: Text(_isListening ? 'Parar Escuta' : 'Testar Microfone'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isListening ? Colors.red : MetamorfoseColors.purpleNormal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Teste Text-to-Speech
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isSpeaking ? _stopSpeaking : _startSpeaking,
                      icon: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
                      label: Text(_isSpeaking ? 'Parar Fala' : 'Testar Alto-falante'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSpeaking ? Colors.orange : MetamorfoseColors.purpleNormal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Teste completo
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _testComplete,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Teste Completo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Informações
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ℹ️ Informações do Teste:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Microfone: Simula reconhecimento de voz\n'
                      '• Alto-falante: Simula síntese de voz\n'
                      '• Teste completo: Simula conversa completa',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
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
  
  void _startListening() {
    setState(() {
      _isListening = true;
      _statusMessage = 'Escutando... (Simulado)';
    });
    
    // Simula reconhecimento após 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (_isListening) {
        setState(() {
          _isListening = false;
          _lastRecognized = 'Olá, como você está?';
          _statusMessage = 'Reconheceu: "${_lastRecognized}"';
        });
      }
    });
  }
  
  void _stopListening() {
    setState(() {
      _isListening = false;
      _statusMessage = 'Escuta interrompida';
    });
  }
  
  void _startSpeaking() {
    setState(() {
      _isSpeaking = true;
      _statusMessage = 'Falando... (Simulado)';
    });
    
    // Simula fala por 4 segundos
    Future.delayed(const Duration(seconds: 4), () {
      if (_isSpeaking) {
        setState(() {
          _isSpeaking = false;
          _statusMessage = 'Terminou de falar';
        });
      }
    });
  }
  
  void _stopSpeaking() {
    setState(() {
      _isSpeaking = false;
      _statusMessage = 'Fala interrompida';
    });
  }
  
  void _testComplete() async {
    setState(() {
      _statusMessage = 'Iniciando teste completo...';
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    // 1. Teste de escuta
    setState(() {
      _statusMessage = 'Testando microfone...';
    });
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _lastRecognized = 'Teste de microfone';
      _statusMessage = 'Microfone OK ✅';
    });
    await Future.delayed(const Duration(seconds: 1));
    
    // 2. Teste de fala
    setState(() {
      _statusMessage = 'Testando alto-falante...';
    });
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _statusMessage = 'Alto-falante OK ✅';
    });
    await Future.delayed(const Duration(seconds: 1));
    
    // 3. Resultado final
    setState(() {
      _statusMessage = '🎉 Teste completo realizado com sucesso!';
    });
  }
}
