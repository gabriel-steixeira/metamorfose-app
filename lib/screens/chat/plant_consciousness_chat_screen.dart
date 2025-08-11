import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/bottom_navigation_menu.dart';
import 'package:conversao_flutter/services/simple_plant_service.dart';
import 'package:conversao_flutter/models/chat_message.dart';

/// Tela de chat por texto com a Consciência da Planta
/// Apenas funcionalidade de texto - sem áudio
class PlantConsciousnessChatScreen extends StatefulWidget {
  const PlantConsciousnessChatScreen({super.key});

  @override
  State<PlantConsciousnessChatScreen> createState() => _PlantConsciousnessChatScreenState();
}

class _PlantConsciousnessChatScreenState extends State<PlantConsciousnessChatScreen> {
  bool _isProcessing = false;
  
  final SimplePlantService _plantService = SimplePlantService();
  final TextEditingController _textController = TextEditingController();
  
  List<ChatMessage> _messages = [];
  static const String _plantPersonality = 'Consciência da planta';
  
  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = 'Olá! Eu sou a Consciência da Planta. Estou aqui para te apoiar na sua jornada de superação e crescimento. Digite sua mensagem e eu responderei com carinho e sabedoria!';
    final message = ChatMessage.assistant(welcomeMessage, _plantPersonality);
    setState(() {
      _messages.add(message);
    });
  }

  void _sendTextMessage() async {
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
    
    try {
      // Processa com a IA
      final response = await _plantService.sendMessage(text);
      final assistantMessage = ChatMessage.assistant(response, _plantPersonality);
      setState(() {
        _messages.add(assistantMessage);
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao processar mensagem: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
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
                          'Chat com a Planta',
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
                           child: ClipOval(
                             child: Image.asset(
                               'assets/images/onboarding/ivy_happy.png',
                               width: 90,
                               height: 90,
                               fit: BoxFit.cover,
                             ),
                           ),
                         ),
                       ),
                       
                       const SizedBox(height: 16),
                       
                       // Nome da planta
                       Text(
                         'Consciência da Planta',
                         style: TextStyle(
                           color: MetamorfoseColors.blackNormal,
                           fontSize: 22,
                           fontWeight: FontWeight.bold,
                           fontFamily: 'DinNext',
                         ),
                       ),
                       
                       const SizedBox(height: 8),
                       
                       // Status simples
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                         decoration: BoxDecoration(
                           color: _isProcessing
                               ? MetamorfoseColors.purpleLight.withOpacity(0.2)
                               : MetamorfoseColors.greenLight.withOpacity(0.2),
                           borderRadius: BorderRadius.circular(20),
                           border: Border.all(
                             color: _isProcessing
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
                                 color: _isProcessing
                                     ? MetamorfoseColors.purpleNormal
                                     : MetamorfoseColors.greenNormal,
                               ),
                             ),
                             const SizedBox(width: 8),
                             Text(
                               _isProcessing 
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
                       ),
                     ],
                   ),
                 ),
            
                // Mensagens
                Expanded(
                  child: Container(
                    // Removido o margin horizontal para ocupar toda a largura
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.whiteLight,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: MetamorfoseColors.shadowLight,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4), // padding lateral reduzido
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
                                  radius: 18,
                                  backgroundColor: MetamorfoseColors.greenLight,
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/onboarding/ivy_happy.png',
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 12),
                              // Flexible(
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
                              // ),
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
                    ),
                  ),
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
                                 color: MetamorfoseColors.whiteLight,
                                 borderRadius: BorderRadius.circular(25),
                                 boxShadow: [
                                   BoxShadow(
                                     color: MetamorfoseColors.shadowLight,
                                     blurRadius: 8,
                                     spreadRadius: 1,
                                   ),
                                 ],
                               ),
                               child: TextField(
                                 controller: _textController,
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
                                   fillColor: MetamorfoseColors.whiteLight,
                                   border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(25),
                                     borderSide: BorderSide.none,
                                   ),
                                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                 ),
                                 onSubmitted: (_) => _sendTextMessage(),
                               ),
                             ),
                           ),
                           const SizedBox(width: 12),
                           GestureDetector(
                             onTap: _sendTextMessage,
                             child: Container(
                               width: 50,
                               height: 50,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 gradient: _isProcessing 
                                     ? LinearGradient(
                                         colors: [
                                           MetamorfoseColors.greyMedium,
                                           MetamorfoseColors.greyLight,
                                         ],
                                       )
                                     : MetamorfoseGradients.lightPurpleGradient,
                                 boxShadow: [
                                   BoxShadow(
                                     color: MetamorfoseColors.shadowLight,
                                     blurRadius: 8,
                                     spreadRadius: 2,
                                   ),
                                 ],
                               ),
                               child: Icon(
                                 _isProcessing ? Icons.hourglass_empty : Icons.send_rounded,
                                 color: MetamorfoseColors.whiteLight,
                                 size: 24,
                               ),
                             ),
                           ),
                         ],
                       ),
                       
                       const SizedBox(height: 16),
                       
                       // Instruções
                       Text(
                         _isProcessing 
                             ? '🤔 Processando sua mensagem...'
                             : '🌱 Digite sua mensagem e toque em enviar',
                         style: TextStyle(
                           color: MetamorfoseColors.blackNormal,
                           fontSize: 14,
                           fontFamily: 'DinNext',
                           fontWeight: FontWeight.w500,
                         ),
                         textAlign: TextAlign.center,
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