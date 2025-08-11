import 'dart:convert';
import 'dart:io';

void main() async {
  const String apiKey = 'AIzaSyCd1U0xTlsfnMb4BqEb6-EGWoOyrl1Q6zw';
  const String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';
  
  final requestBody = {
    'contents': [
      {
        'parts': [
          {'text': 'Olá, você está funcionando?'}
        ]
      }
    ]
  };

  try {
    print('🔍 Testando API Gemini...');
    
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json');
    
    final jsonString = jsonEncode(requestBody);
    request.write(jsonString);
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('📊 Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      print('✅ API funcionando!');
      print('🤖 Resposta: $text');
    } else {
      print('❌ Erro na API:');
      print(responseBody);
    }
    
    client.close();
  } catch (e) {
    print('❌ Erro de conexão: $e');
  }
}
