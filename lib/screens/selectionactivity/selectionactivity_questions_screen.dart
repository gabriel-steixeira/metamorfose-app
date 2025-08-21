import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/metamorfose_primary_button.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';


/// Constantes de layout
class _LayoutConstants {
  static const double buttonHeight = 43;
  static const double buttonWidth = 358;
  static const double horizontalPadding = 16;
  static const double bottomPadding = 36;
  static const double progressBarHeight = 8;
}

/// Tela de perguntas para personalização do usuário
class SelectionActivityQuestionsScreen extends StatefulWidget {
  const SelectionActivityQuestionsScreen({super.key});

  @override
  State<SelectionActivityQuestionsScreen> createState() => _SelectionActivityQuestionsScreenState();
}

class _SelectionActivityQuestionsScreenState extends State<SelectionActivityQuestionsScreen> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  
  // Lista de perguntas
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Qual vício você gostaria de trabalhar primeiro?',
      'options': [
        'Uso excessivo de celular',
        'Redes sociais',
        'Cigarro',
        'Bebida alcoólica',
        'Alimentos ultraprocessados',
        'Açúcar',
        'Cafeína',
      ],
      'type': 'single_choice',
    },
    {
      'question': 'Com que frequência você sente que perde o controle sobre esse hábito?',
      'options': [
        'Quase nunca',
        'Às vezes',
        'Frequentemente',
        'Quase sempre',
        'Sempre',
      ],
      'type': 'single_choice',
    },
    {
      'question': 'Como você se sente quando tenta parar?',
      'options': [
        'Ansioso(a)',
        'Irritado(a)',
        'Triste',
        'Motivado(a)',
        'Indiferente',
      ],
      'type': 'single_choice',
    },
    {
      'question': 'Você já tentou mudar esse hábito antes?',
      'options': ['Sim', 'Não'],
      'type': 'single_choice',
    },
    {
      'question': 'Qual é a principal razão pela qual você quer mudar?',
      'options': [
        'Minha saúde',
        'Minha família',
        'Meu bem-estar',
        'Economizar dinheiro',
        'Ter uma criança',
        'Minha liberdade',
      ],
      'type': 'single_choice',
    },
    {
      'question': 'Sua privacidade vem em primeiro lugar 💙\n\nTodas as suas respostas serão mantidas em sigilo e usadas apenas para personalizar sua experiência no aplicativo. Também utilizamos seus dados de forma anônima para gerar estatísticas e melhorar nossos serviços — nunca iremos vender ou compartilhar suas informações.\n\nAo continuar, você confirma que tem pelo menos 18 anos de idade.\n\nEstá tudo bem para você?',
      'options': [
        'Sim, podemos seguir em frente',
        'Como usamos seus dados',
        'Não, obrigado',
      ],
      'type': 'single_choice',
    },
  ];

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _nextQuestion() {
    if (selectedAnswer != null) {
      // Verificar se é a pergunta de privacidade (última pergunta)
      if (currentQuestionIndex == questions.length - 1) {
        // Tratar respostas da pergunta de privacidade
        if (selectedAnswer == 'Como usamos seus dados') {
          _showPrivacyDetailsDialog();
          return;
        } else if (selectedAnswer == 'Não, obrigado') {
          // Voltar para a tela anterior
          context.go(Routes.selectionActivityWelcome);
          return;
        } else if (selectedAnswer == 'Sim, podemos seguir em frente') {
          // Mostrar tela de conclusão
          _showConclusionDialog();
          return;
        }
      }
      
      // Para outras perguntas, seguir o fluxo normal
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswer = null;
        });
      } else {
        // Última pergunta - mostrar tela de conclusão
        _showConclusionDialog();
      }
    }
  }

  void _showConclusionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ivy feliz
              Image.asset(
                'assets/images/selectionactivity/ivy_laugh.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 20),
              Text(
                'Obrigada por compartilhar com a gente 💚',
                style: TextStyle(
                  color: MetamorfoseColors.purpleDark,
                  fontSize: 18,
                  fontFamily: 'DinNext',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'A partir de agora, nossa IA vai conversar com você todos os dias e te ajudar a cuidar de si — e da sua nova plantinha também!',
                style: TextStyle(
                  color: MetamorfoseColors.greyMedium,
                  fontSize: 16,
                  fontFamily: 'DinNext',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MetamorfosePrimaryButton(
                  text: 'Continuar',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('${Routes.auth}?mode=register');
                  },
                  backgroundColor: MetamorfoseColors.greenLight,
                  borderColor: MetamorfoseColors.greenDark,
                  shadowColor: MetamorfoseColors.greenDark,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDetailsDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Como usamos seus dados 💙',
                  style: TextStyle(
                    color: MetamorfoseColors.purpleDark,
                    fontSize: 20,
                    fontFamily: 'DinNext',
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildPrivacySection(
                  'Coleta de Dados',
                  'Coletamos apenas as informações necessárias para personalizar sua experiência: respostas das perguntas, preferências de plantas e interações com o app.',
                ),
                const SizedBox(height: 16),
                _buildPrivacySection(
                  'Uso dos Dados',
                  'Seus dados são usados para:\n• Personalizar conversas da IA\n• Recomendar plantas adequadas\n• Melhorar a experiência do usuário\n• Gerar estatísticas anônimas',
                ),
                const SizedBox(height: 16),
                _buildPrivacySection(
                  'Proteção',
                  '• Todos os dados são criptografados\n• Nunca vendemos ou compartilhamos informações pessoais\n• Estatísticas são sempre anônimas\n• Você pode solicitar exclusão a qualquer momento',
                ),
                const SizedBox(height: 16),
                _buildPrivacySection(
                  'Conformidade',
                  'Seguimos rigorosamente a LGPD (Lei Geral de Proteção de Dados) e as melhores práticas de segurança da indústria.',
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MetamorfosePrimaryButton(
                  text: 'Entendi, podemos continuar',
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showConclusionDialog();
                  },
                  backgroundColor: MetamorfoseColors.greenLight,
                  borderColor: MetamorfoseColors.greenDark,
                  shadowColor: MetamorfoseColors.greenDark,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: MetamorfoseColors.purpleDark,
            fontSize: 16,
            fontFamily: 'DinNext',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: MetamorfoseColors.greyMedium,
            fontSize: 14,
            fontFamily: 'DinNext',
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background com gradiente softPurpleGradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: MetamorfoseGradients.softPurpleGradient,
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // Header com back button e progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _LayoutConstants.horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/arrow_back.svg',
                            width: 34,
                            height: 34,
                          ),
                          onPressed: () => context.go(Routes.selectionActivityWelcome),
                          color: MetamorfoseColors.purpleDark,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Progress bar
                      Container(
                        width: double.infinity,
                        height: _LayoutConstants.progressBarHeight,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(_LayoutConstants.progressBarHeight / 2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: MetamorfoseColors.greenLight,
                              borderRadius: BorderRadius.circular(_LayoutConstants.progressBarHeight / 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16), // Reduzido de Spacer(flex: 2) para SizedBox(height: 16)
                
                // Ivy estudando e Speech bubble lado a lado
                Expanded(
                  flex: 2, // Aumentado de 1 para 2 para ocupar mais espaço
                  child: Row(
                    children: [
                      // Ivy estudando (lado esquerdo)
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 16, right: 16), // Adicionado margens laterais
                          child: Image.asset(
                            'assets/images/selectionactivity/ivy_studying.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // Speech bubble com pergunta (lado direito)
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 8, right: 16), // Reduzido left de 16 para 8 para aproximar do Ivy
                          child: IntrinsicWidth(
                            child: IntrinsicHeight(
                              child: SpeechBubble(
                                width: 280, // Aumentado de 200 para 280
                                arrowDirection: 'left',
                                color: Colors.white,
                                borderColor: MetamorfoseColors.purpleLight,
                                triangleColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Aumentado padding
                                  child: Text(
                                    currentQuestion['question'],
                                    style: TextStyle(
                                      color: MetamorfoseColors.purpleDark,
                                      fontSize: 18, // Aumentado de 15 para 18
                                      fontFamily: 'DinNext',
                                      fontWeight: FontWeight.w700,
                                      height: 1.4, // Aumentado de 1.3 para 1.4
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16), // Reduzido de 20 para 16
                
                // Opções de resposta
                Expanded(
                  flex: 4, // Aumentado de 3 para 4 para ocupar mais espaço
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _LayoutConstants.horizontalPadding,
                    ),
                    child: ListView.builder(
                      itemCount: currentQuestion['options'].length,
                      itemBuilder: (context, index) {
                        final option = currentQuestion['options'][index];
                        final isSelected = selectedAnswer == option;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10), // Reduzido de 12 para 10
                          child: MetamorfosePrimaryButton(
                            text: option,
                            onPressed: () => _selectAnswer(option),
                            backgroundColor: isSelected 
                                ? MetamorfoseColors.greenLight 
                                : MetamorfoseColors.purpleLight,
                            borderColor: isSelected 
                                ? MetamorfoseColors.greenDark 
                                : MetamorfoseColors.purpleNormal,
                            shadowColor: isSelected 
                                ? MetamorfoseColors.greenDark 
                                : MetamorfoseColors.purpleNormal,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 16), // Reduzido de Spacer(flex: 1) para SizedBox(height: 16)
                
                // Bottom button
                Padding(
                  padding: const EdgeInsets.only(
                    left: _LayoutConstants.horizontalPadding,
                    right: _LayoutConstants.horizontalPadding,
                    bottom: _LayoutConstants.bottomPadding,
                  ),
                  child: SizedBox(
                    width: _LayoutConstants.buttonWidth,
                    height: _LayoutConstants.buttonHeight,
                    child: MetamorfosePrimaryButton(
                      text: 'Continuar',
                      onPressed: selectedAnswer != null ? _nextQuestion : () {},
                      backgroundColor: selectedAnswer != null 
                          ? MetamorfoseColors.greenLight 
                          : MetamorfoseColors.greyLight,
                      borderColor: selectedAnswer != null 
                          ? MetamorfoseColors.greenDark 
                          : MetamorfoseColors.greyMedium,
                      shadowColor: selectedAnswer != null 
                          ? MetamorfoseColors.greenDark 
                          : MetamorfoseColors.greyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


 