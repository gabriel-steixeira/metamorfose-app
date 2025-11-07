/// File: selectionactivity_questions_screen.dart
/// Description: Tela de perguntas para personalização do usuário.
///
/// Responsabilidades:
/// - Exibir perguntas de personalização
/// - Coletar respostas do usuário
/// - Navegar para a próxima etapa
/// - Personalizar experiência do usuário
///
/// Author: Gabriel Teixeira
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/primary_button.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';


/// Tela de perguntas para personalização do usuário
class SelectionActivityQuestionsScreen extends StatefulWidget {
  const SelectionActivityQuestionsScreen({super.key});

  @override
  State<SelectionActivityQuestionsScreen> createState() => _SelectionActivityQuestionsScreenState();
}

class _SelectionActivityQuestionsScreenState extends State<SelectionActivityQuestionsScreen> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  String customHabit = '';
  final TextEditingController _customHabitController = TextEditingController();
  
  // Lista de perguntas
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Qual desses hábitos você gostaria de transformar?',
      'options': [
        'Celular (uso excessivo)',
        'Redes sociais',
        'Cigarro',
        'Bebida alcoólica',
        'Comida ultraprocessada',
        'Açúcar',
        'Cafeína',
        'Outro hábito',
      ],
      'type': 'single_choice',
    },
    {
      'question': 'Entendi! E como você se sente sobre esse hábito?',
      'options': [
        'Tudo bem, não me incomoda',
        'Às vezes me incomoda',
        'Me incomoda bastante',
        'Preciso mudar urgente',
        'Já estou tentando mudar',
      ],
      'type': 'single_choice',
    },
    {
      'question': 'O que mais te motiva nessa jornada? 💚',
      'options': [
        'Minha saúde',
        'Minha família',
        'Ter mais tempo livre',
        'Economizar dinheiro',
        'Me sentir mais livre',
        'Ser um bom exemplo',
      ],
      'type': 'single_choice',
    },
    {
      'question': 'Como você gosta de receber apoio?',
      'options': [
        'Mensagens carinhosas',
        'Dicas práticas',
        'Conversas acolhedoras',
        'Desafios divertidos',
        'Comemorar conquistas',
      ],
      'type': 'single_choice',
    },
    {
      'question': 'Qual horário você prefere para conversar?',
      'options': [
        'Manhã (6h às 10h)',
        'Meio-dia (10h às 14h)',
        'Tarde (14h às 18h)',
        'Noite (18h às 22h)',
        'Qualquer horário',
      ],
      'type': 'single_choice',
    },
    {
      'question': 'Sua privacidade é importante para nós 💙\n\nTudo certo para continuarmos?',
      'options': [
        'Sim, vamos em frente!',
        'Como meus dados são usados?',
        'Não, obrigado',
      ],
      'type': 'single_choice',
    },
  ];

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      if (answer == 'Outro hábito') {
        customHabit = '';
        _customHabitController.clear();
      }
    });
  }

  void _updateCustomHabit(String value) {
    setState(() {
      customHabit = value;
    });
  }

  bool _canContinue() {
    if (selectedAnswer == null) return false;
    
    // Se é a primeira pergunta e selecionou "Outro hábito", precisa preencher o campo
    if (currentQuestionIndex == 0 && selectedAnswer == 'Outro hábito') {
      return customHabit.trim().isNotEmpty;
    }
    
    return true;
  }

  @override
  void dispose() {
    _customHabitController.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    // Verificar se é a primeira pergunta e se selecionou "Outro hábito"
    if (currentQuestionIndex == 0 && selectedAnswer == 'Outro hábito' && customHabit.trim().isEmpty) {
      // Não permitir avançar se selecionou "Outro hábito" mas não preencheu o campo
      return;
    }
    
    if (selectedAnswer != null) {
      // Verificar se é a pergunta de privacidade (última pergunta)
      if (currentQuestionIndex == questions.length - 1) {
        // Tratar respostas da pergunta de privacidade
        if (selectedAnswer == 'Como meus dados são usados?') {
          _showPrivacyDetailsDialog();
          return;
        } else if (selectedAnswer == 'Não, obrigado') {
          // Voltar para a tela anterior
          context.go(Routes.selectionActivityWelcome);
          return;
        } else if (selectedAnswer == 'Sim, vamos em frente!') {
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

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswer = null;
        // Limpar o campo de hábito customizado se voltar da primeira pergunta
        if (currentQuestionIndex == 0) {
          customHabit = '';
          _customHabitController.clear();
        }
      });
    } else {
      // Se estiver na primeira pergunta, voltar para a tela de boas-vindas
      context.go(Routes.selectionActivityWelcome);
    }
  }

  void _showConclusionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final borderRadius = ResponsiveValue<double>(
          context,
          defaultValue: 20.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 16.0),
            Condition.largerThan(name: TABLET, value: 24.0),
          ],
        ).value;

        final imageSize = ResponsiveValue<double>(
          context,
          defaultValue: 120.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 100.0),
            Condition.largerThan(name: TABLET, value: 140.0),
          ],
        ).value;

        final dialogTitleFontSize = ResponsiveValue<double>(
          context,
          defaultValue: 18.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 16.0),
            Condition.largerThan(name: TABLET, value: 20.0),
          ],
        ).value;

        final dialogTextFontSize = ResponsiveValue<double>(
          context,
          defaultValue: 16.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 14.0),
            Condition.largerThan(name: TABLET, value: 18.0),
          ],
        ).value;

        final dialogPadding = ResponsiveValue<double>(
          context,
          defaultValue: 16.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 12.0),
            Condition.largerThan(name: TABLET, value: 20.0),
          ],
        ).value;

        final buttonSpacing = ResponsiveValue<double>(
          context,
          defaultValue: 4.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 2.0),
            Condition.largerThan(name: TABLET, value: 6.0),
          ],
        ).value;

        final maxDialogWidth = ResponsiveValue<double>(
          context,
          defaultValue: 600.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: double.infinity),
            Condition.largerThan(name: TABLET, value: 800.0),
          ],
        ).value;

        return AlertDialog(
          backgroundColor: MetamorfoseColors.whiteLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: MetamorfoseColors.purpleLight,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(dialogPadding),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxDialogWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/selectionactivity/ivy_laugh.png',
                  width: imageSize,
                  height: imageSize,
                ),
                SizedBox(height: dialogPadding * 0.8),
                Text(
                  'Obrigada por compartilhar com a gente 💚',
                  style: TextStyle(
                    color: MetamorfoseColors.purpleDark,
                    fontSize: dialogTitleFontSize,
                    fontFamily: 'DinNext',
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: dialogPadding * 0.7),
                Text(
                  'Agora é só fazer seu cadastro para continuar.\n A partir daí, nossa IA vai estar com você todos os dias, cuidando de você e da sua nova plantinha com muito carinho!🌱',
                  style: TextStyle(
                    color: MetamorfoseColors.greyMedium,
                    fontSize: dialogTextFontSize,
                    fontFamily: 'DinNext',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(dialogPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: buttonSpacing),
                      child: MetamorfosePrimaryButton(
                        text: 'Cancelar',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        backgroundColor: MetamorfoseColors.redNormal,
                        borderColor: MetamorfoseColors.redDark,
                        shadowColor: MetamorfoseColors.redDark,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: buttonSpacing),
                      child: MetamorfosePrimaryButton(
                        text: 'Cadastrar',
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.go('${Routes.auth}?mode=register');
                        },
                        backgroundColor: MetamorfoseColors.greenLight,
                        borderColor: MetamorfoseColors.greenDark,
                        shadowColor: MetamorfoseColors.greenDark,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  
                ],
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
        final borderRadius = ResponsiveValue<double>(
          context,
          defaultValue: 20.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 16.0),
            Condition.largerThan(name: TABLET, value: 24.0),
          ],
        ).value;

        final dialogTitleFontSize = ResponsiveValue<double>(
          context,
          defaultValue: 20.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 18.0),
            Condition.largerThan(name: TABLET, value: 22.0),
          ],
        ).value;

        final dialogPadding = ResponsiveValue<double>(
          context,
          defaultValue: 16.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 12.0),
            Condition.largerThan(name: TABLET, value: 20.0),
          ],
        ).value;

        final buttonSpacing = ResponsiveValue<double>(
          context,
          defaultValue: 4.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 2.0),
            Condition.largerThan(name: TABLET, value: 6.0),
          ],
        ).value;

        final maxDialogWidth = ResponsiveValue<double>(
          context,
          defaultValue: 600.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: double.infinity),
            Condition.largerThan(name: TABLET, value: 800.0),
          ],
        ).value;

        return AlertDialog(
          backgroundColor: MetamorfoseColors.whiteLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: MetamorfoseColors.purpleLight,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(dialogPadding),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxDialogWidth,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Como usamos seus dados 💙',
                    style: TextStyle(
                      color: MetamorfoseColors.purpleDark,
                      fontSize: dialogTitleFontSize,
                      fontFamily: 'DinNext',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: dialogPadding * 0.8),
                  _buildPrivacySection(
                    'Coleta de Dados',
                    'Coletamos apenas as informações necessárias para personalizar sua experiência: respostas das perguntas, preferências de plantas e interações com o app.',
                  ),
                  SizedBox(height: dialogPadding * 0.7),
                  _buildPrivacySection(
                    'Uso dos Dados',
                    'Seus dados são usados para:\n• Personalizar conversas da IA\n• Recomendar plantas adequadas\n• Melhorar a experiência do usuário\n• Gerar estatísticas anônimas',
                  ),
                  SizedBox(height: dialogPadding * 0.7),
                  _buildPrivacySection(
                    'Proteção',
                    '• Todos os dados são criptografados\n• Nunca vendemos ou compartilhamos informações pessoais\n• Estatísticas são sempre anônimas\n• Você pode solicitar exclusão a qualquer momento',
                  ),
                  SizedBox(height: dialogPadding * 0.7),
                  _buildPrivacySection(
                    'Conformidade',
                    'Seguimos rigorosamente a LGPD (Lei Geral de Proteção de Dados) e as melhores práticas de segurança da indústria.',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(dialogPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: buttonSpacing),
                      child: MetamorfosePrimaryButton(
                        text: 'Cancelar',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        backgroundColor: MetamorfoseColors.redNormal,
                        borderColor: MetamorfoseColors.redDark,
                        shadowColor: MetamorfoseColors.redDark,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: buttonSpacing),
                      child: MetamorfosePrimaryButton(
                        text: 'Continuar',
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showConclusionDialog();
                        },
                        backgroundColor: MetamorfoseColors.greenLight,
                        borderColor: MetamorfoseColors.greenDark,
                        shadowColor: MetamorfoseColors.greenDark,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    final sectionTitleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final sectionTextFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final sectionSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: MetamorfoseColors.purpleDark,
            fontSize: sectionTitleFontSize,
            fontFamily: 'DinNext',
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: sectionSpacing),
        Text(
          content,
          style: TextStyle(
            color: MetamorfoseColors.greyMedium,
            fontSize: sectionTextFontSize,
            fontFamily: 'DinNext',
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    // Valores responsivos
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final bottomPadding = ResponsiveValue<double>(
      context,
      defaultValue: 36.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 48.0),
      ],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 43.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 52.0),
      ],
    ).value;

    final buttonWidth = ResponsiveValue<double>(
      context,
      defaultValue: 358.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: double.infinity),
        Condition.largerThan(name: TABLET, value: 400.0),
      ],
    ).value;

    final progressBarHeight = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 34.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 28.0),
        Condition.largerThan(name: TABLET, value: 40.0),
      ],
    ).value;

    final speechBubbleWidth = ResponsiveValue<double>(
      context,
      defaultValue: 280.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 240.0),
        Condition.largerThan(name: TABLET, value: 320.0),
      ],
    ).value;

    final textFieldBorderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final textFieldFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/arrow_back.svg',
                            width: iconSize,
                            height: iconSize,
                          ),
                          onPressed: _previousQuestion,
                          color: MetamorfoseColors.purpleDark,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Progress bar
                      Container(
                        width: double.infinity,
                        height: progressBarHeight,
                        decoration: BoxDecoration(
                          color: MetamorfoseColors.whiteLight.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(progressBarHeight / 2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: MetamorfoseColors.greenLight,
                              borderRadius: BorderRadius.circular(progressBarHeight / 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Ivy estudando e Speech bubble lado a lado - compartilhando o mesmo container
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Altura mínima compartilhada para Ivy e balão
                        final minHeight = ResponsiveValue<double>(
                          context,
                          defaultValue: 200.0,
                          conditionalValues: const [
                            Condition.smallerThan(name: MOBILE, value: 180.0),
                            Condition.largerThan(name: TABLET, value: 240.0),
                          ],
                        ).value;
                        
                        // Calcular altura máxima disponível para o SpeechBubble
                        // Considerando o espaço disponível menos um pequeno buffer
                        final maxBubbleHeight = constraints.maxHeight > 0 
                            ? constraints.maxHeight * 0.9 
                            : null;
                        
                        // Em telas muito pequenas, usar layout horizontal compacto
                        if (constraints.maxWidth < 400) {
                          return Container(
                            constraints: BoxConstraints(
                              minHeight: minHeight,
                            ),
                            child: LayoutBuilder(
                              builder: (context, containerConstraints) {
                                // Usar altura real do container (pode ser maior que minHeight)
                                final containerHeight = containerConstraints.maxHeight > minHeight
                                    ? containerConstraints.maxHeight
                                    : minHeight;
                                
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Ivy menor (lado esquerdo) - ocupa toda a altura do container
                                    SizedBox(
                                      width: constraints.maxWidth * 0.35, // 35% da largura
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                        child: Image.asset(
                                          'assets/images/selectionactivity/ivy_studying.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(width: 8),
                                    
                                    // Speech bubble (lado direito) - com scroll quando necessário
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: SpeechBubble(
                                          width: constraints.maxWidth * 0.6, // 60% da largura
                                          maxHeight: maxBubbleHeight,
                                          arrowDirection: 'left',
                                          color: MetamorfoseColors.whiteLight,
                                          borderColor: MetamorfoseColors.purpleLight,
                                          triangleColor: MetamorfoseColors.whiteLight,
                                          containerHeight: containerHeight, // Passa altura real do container
                                          child: Text(
                                            currentQuestion['question'],
                                            style: TextStyle(
                                              color: MetamorfoseColors.purpleDark,
                                              fontSize: titleFontSize * 0.9,
                                              fontFamily: 'DinNext',
                                              fontWeight: FontWeight.w700,
                                              height: 1.3,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                        
                        // Layout horizontal para telas maiores
                        return Container(
                          constraints: BoxConstraints(
                            minHeight: minHeight,
                          ),
                          child: LayoutBuilder(
                            builder: (context, containerConstraints) {
                              // Usar altura real do container (pode ser maior que minHeight)
                              final containerHeight = containerConstraints.maxHeight > minHeight
                                  ? containerConstraints.maxHeight
                                  : minHeight;
                              
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Ivy estudando (lado esquerdo) - ocupa toda a altura do container
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                                      child: Image.asset(
                                        'assets/images/selectionactivity/ivy_studying.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 20),
                                  
                                  // Speech bubble com pergunta (lado direito) - com scroll quando necessário
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8, right: 16),
                                      child: SpeechBubble(
                                        width: speechBubbleWidth,
                                        maxHeight: maxBubbleHeight,
                                        arrowDirection: 'left',
                                        color: MetamorfoseColors.whiteLight,
                                        borderColor: MetamorfoseColors.purpleLight,
                                        triangleColor: MetamorfoseColors.whiteLight,
                                        containerHeight: containerHeight, // Passa altura real do container
                                        child: Text(
                                          currentQuestion['question'],
                                          style: TextStyle(
                                            color: MetamorfoseColors.purpleDark,
                                            fontSize: titleFontSize,
                                            fontFamily: 'DinNext',
                                            fontWeight: FontWeight.w700,
                                            height: 1.4,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Opções de resposta
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: currentQuestion['options'].length,
                            itemBuilder: (context, index) {
                              final option = currentQuestion['options'][index];
                              final isSelected = selectedAnswer == option;
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
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
                        
                        // Campo de texto para "Outro hábito" (apenas na primeira pergunta)
                        if (currentQuestionIndex == 0 && selectedAnswer == 'Outro hábito')
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: MetamorfoseColors.whiteLight,
                                borderRadius: BorderRadius.circular(textFieldBorderRadius),
                                border: Border.all(
                                  color: MetamorfoseColors.purpleLight,
                                  width: 2,
                                ),
                              ),
                              child: TextField(
                                controller: _customHabitController,
                                onChanged: _updateCustomHabit,
                                decoration: InputDecoration(
                                  hintText: 'Qual hábito você gostaria de transformar?',
                                  hintStyle: TextStyle(
                                    color: MetamorfoseColors.greyMedium,
                                    fontSize: textFieldFontSize,
                                    fontFamily: 'DinNext',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                style: TextStyle(
                                  color: MetamorfoseColors.purpleDark,
                                  fontSize: textFieldFontSize,
                                  fontFamily: 'DinNext',
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Bottom button
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: bottomPadding,
                  ),
                  child: SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: MetamorfosePrimaryButton(
                      text: 'Continuar',
                      onPressed: _canContinue() ? _nextQuestion : () {},
                      backgroundColor: _canContinue() 
                          ? MetamorfoseColors.greenLight 
                          : MetamorfoseColors.greyLight,
                      borderColor: _canContinue() 
                          ? MetamorfoseColors.greenDark 
                          : MetamorfoseColors.greyMedium,
                      shadowColor: _canContinue() 
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


 