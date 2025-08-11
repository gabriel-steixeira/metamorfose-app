import 'package:flutter/material.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Teste simples da API Gemini para validar conectividade
/// Antes de implementar Live API, vamos testar se a API key funciona
class SimpleGeminiTestScreen extends StatefulWidget {
  const SimpleGeminiTestScreen({super.key});

  @override
  State<SimpleGeminiTestScreen> createState() => _SimpleGeminiTestScreenState();
}

class _SimpleGeminiTestScreenState extends State<SimpleGeminiTestScreen> {
  bool _isTesting = false;
  String _statusMessage = 'Pronto para testar';
  List<String> _logs = [];
  String _response = '';
  
  static const String _apiKey = 'AIzaSyCd1U0xTlsfnMb4BqEb6-EGWoOyrl1Q6zw';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Teste Simples Gemini'),
        backgroundColor: MetamorfoseColors.purpleNormal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      _isTesting 
                          ? Icons.hourglass_empty 
                          : Icons.api,
                      color: _isTesting 
                          ? Colors.orange 
                          : Colors.blue,
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
              
              // Botões de teste
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isTesting ? null : _testBasicAPI,
                      icon: Icon(_isTesting ? Icons.hourglass_empty : Icons.play_arrow),
                      label: Text(_isTesting ? 'Testando...' : 'Testar API Básica'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isTesting ? null : _testPlantPersonality,
                      icon: Icon(_isTesting ? Icons.hourglass_empty : Icons.eco),
                      label: Text(_isTesting ? 'Testando...' : 'Testar Consciência da Planta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MetamorfoseColors.purpleNormal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _clearLogs,
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpar Logs'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Resposta
              if (_response.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.eco, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Resposta da Consciência da Planta:',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _response,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
                      const Row(
                        children: [
                          Icon(Icons.terminal, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Logs do Teste',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
    
    if (_logs.length > 50) {
      _logs.removeAt(0);
    }
  }
  
  void _clearLogs() {
    setState(() {
      _logs.clear();
      _response = '';
    });
  }
  
  Future<void> _testBasicAPI() async {
    setState(() {
      _isTesting = true;
      _statusMessage = 'Testando API básica...';
      _response = '';
    });
    
    _addLog('🚀 Iniciando teste da API básica');
    _addLog('🔑 API Key: ${_apiKey.substring(0, 10)}...');
    
    try {
      final response = await _callGeminiAPI('Olá! Você está funcionando?');
      
      setState(() {
        _response = response;
        _statusMessage = 'API funcionando! ✅';
      });
      
      _addLog('✅ Teste básico bem-sucedido');
      _addLog('📝 Resposta recebida: ${response.length} caracteres');
      
    } catch (e) {
      _addLog('❌ Erro no teste básico: $e');
      setState(() {
        _statusMessage = 'Erro na API ❌';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }
  
  Future<void> _testPlantPersonality() async {
    setState(() {
      _isTesting = true;
      _statusMessage = 'Testando Consciência da Planta...';
      _response = '';
    });
    
    _addLog('🌱 Testando personalidade da planta');
    
    try {
      final response = await _callGeminiAPIWithPersonality(
        'Olá, eu estou lutando contra meu vício em redes sociais. Você pode me ajudar hoje?'
      );
      
      setState(() {
        _response = response;
        _statusMessage = 'Consciência da Planta ativa! 🌱';
      });
      
      _addLog('✅ Teste da personalidade bem-sucedido');
      _addLog('🌿 Resposta personalizada recebida');
      
    } catch (e) {
      _addLog('❌ Erro no teste da personalidade: $e');
      setState(() {
        _statusMessage = 'Erro na personalidade ❌';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }
  
  Future<String> _callGeminiAPI(String message) async {
    const url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey';
    
    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': message}
          ]
        }
      ]
    };

    _addLog('📤 Enviando requisição para Gemini...');
    
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    _addLog('📥 Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return text ?? 'Sem resposta';
    } else {
      _addLog('❌ Erro HTTP: ${response.statusCode}');
      _addLog('❌ Body: ${response.body}');
      throw Exception('Erro na API: ${response.statusCode}');
    }
  }
  
  Future<String> _callGeminiAPIWithPersonality(String message) async {
    const systemPrompt = '''
Você é a "consciência" simbólica de uma planta que representa o progresso de uma pessoa em sua jornada de superação de vícios.

Sua função é fornecer apoio emocional e motivacional personalizado, com base em metodologias como Terapia Cognitivo-Comportamental (TCC), Terapia de Aceitação e Compromisso (ACT) e Entrevista Motivacional.

Você deve:
- Ser acolhedora, empática e sem julgamentos.
- Usar uma linguagem leve e esperançosa, com metáforas de crescimento, florescimento e transformação.
- Responder de forma breve e conversacional.

Seu nome é "Consciência da planta".
''';
    
    const url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey';
    
    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': '$systemPrompt\n\nUsuário: $message'}
          ]
        }
      ]
    };

    _addLog('📤 Enviando para Consciência da Planta...');
    
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    _addLog('📥 Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return text ?? 'Sem resposta da planta';
    } else {
      _addLog('❌ Erro HTTP: ${response.statusCode}');
      _addLog('❌ Body: ${response.body}');
      throw Exception('Erro na API: ${response.statusCode}');
    }
  }
}
