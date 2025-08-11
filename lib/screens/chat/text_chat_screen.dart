import 'package:flutter/material.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/bottom_navigation_menu.dart';
import 'package:conversao_flutter/services/text_chat_service.dart';

/// Tela de chat por texto com a Consciência da Planta
/// Versão simplificada sem áudio
class TextChatScreen extends StatefulWidget {
  const TextChatScreen({super.key});

  @override
  State<TextChatScreen> createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> 
    with TickerProviderStateMixin {
  
  // Serviço de chat
  late TextChatService _chatService;
  
  // Estados
  bool _isProcessing = false;
  bool _isInitialized = false;
  
  // Controladores
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Animações
  late AnimationController _pulseController;
  late AnimationController _breathingController;
  
  String _statusMessage = 'Inicializando...';
  List<Map<String, dynamic>> _messages = [];
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeChatService();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }
  
  void _initializeChatService() async {
    _chatService = TextChatService();
    
    // Configurar callbacks
    _chatService.onProcessingChanged = (processing) {
      setState(() {
        _isProcessing = processing;
        _statusMessage = processing 
            ? 'Pensando... 🤔'
            : _isInitialized ? 'Pronta para conversar! 🌱' : 'Inicializando...';
      });
    };
    
    _chatService.onResponse = (response) {
      _addMessage('plant', response);
      _scrollToBottom();
    };
    
    _chatService.onError = (error) {
      _addMessage('system', 'Erro: $error');
      setState(() {
        _statusMessage = 'Erro na comunicação';
      });
    };
    
    // Inicializa o serviço
    final initialized = await _chatService.initialize();
    
    setState(() {
      _isInitialized = initialized;
      _statusMessage = initialized 
          ? 'Pronta para conversar! 🌱'
          : 'Erro na inicialização';
    });
    
    if (initialized) {
      // Mensagem de boas-vindas
      _addMessage('plant', 'Olá! Eu sou a consciência da sua planta. 🌱\n\nEstou aqui para te apoiar na sua jornada de transformação e crescimento. Pode me contar como você está se sentindo hoje!');
      _scrollToBottom();
    }
  }
  
  void _addMessage(String sender, String text) {
    setState(() {
      _messages.add({
        'sender': sender,
        'text': text,
        'timestamp': DateTime.now(),
      });
    });
  }
  
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isProcessing || !_isInitialized) return;
    
    // Adiciona mensagem do usuário
    _addMessage('user', text);
    _messageController.clear();
    _scrollToBottom();
    
    // Processa a mensagem
    await _chatService.processMessage(text);
  }
  
  void _scrollToBottom() {
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

  Widget _buildMessage(Map<String, dynamic> message) {
    final isUser = message['sender'] == 'user';
    final isSystem = message['sender'] == 'system';
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser && !isSystem) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/onboarding/ivy_happy.png'),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSystem 
                    ? Colors.red[900]
                    : isUser 
                        ? Colors.blue[700]
                        : Colors.green[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser && !isSystem)
                    const Text(
                      '🌱 Consciência da Planta',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  if (!isUser && !isSystem) const SizedBox(height: 4),
                  
                  Text(
                    message['text'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message['timestamp']),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[700],
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _chatService.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                final scale = 1.0 + (0.05 * _breathingController.value);
                return Transform.scale(
                  scale: scale,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/onboarding/ivy_happy.png'),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consciência da Planta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Chat por Texto',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Status
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isInitialized 
                        ? _isProcessing
                            ? Colors.orange
                            : Colors.green
                        : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _isProcessing 
                        ? Colors.orange
                        : Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Mensagens
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final scale = 1.0 + (0.1 * _pulseController.value);
                            return Transform.scale(
                              scale: scale,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('assets/images/onboarding/ivy_happy.png'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Aguardando inicialização...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessage(_messages[index]);
                    },
                  ),
          ),
          
          // Campo de entrada
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(
                top: BorderSide(color: Colors.grey[700]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: _isInitialized && !_isProcessing,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: _isInitialized 
                          ? 'Digite sua mensagem...'
                          : 'Aguarde inicialização...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                
                AnimatedBuilder(
                  animation: _isProcessing ? _pulseController : _breathingController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isInitialized && !_isProcessing 
                            ? Colors.green 
                            : Colors.grey,
                        boxShadow: _isProcessing ? [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.4),
                            blurRadius: 10 + (5 * _pulseController.value),
                            spreadRadius: 2 + (2 * _pulseController.value),
                          ),
                        ] : null,
                      ),
                      child: IconButton(
                        onPressed: _isInitialized && !_isProcessing ? _sendMessage : null,
                        icon: Icon(
                          _isProcessing ? Icons.hourglass_empty : Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
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
