/// File: sos_screen.dart
/// Description: Tela SOS com opções de suporte
///
/// Responsabilidades:
/// - Exibir opções de suporte
///
/// Author: Vitoria Lana
/// Created on: 26-10-2025
/// Version: 2.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/typography.dart';
import 'package:metamorfose_flutter/blocs/sos_bloc.dart';
import 'package:metamorfose_flutter/state/sos/sos_state.dart';
import 'package:metamorfose_flutter/state/sos/sos_events.dart';
import 'package:metamorfose_flutter/models/sos_contact.dart';
import 'package:metamorfose_flutter/services/sos_service.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart';
import 'package:metamorfose_flutter/components/metamorfose_button.dart';
import 'package:metamorfose_flutter/components/secondary_button.dart';
import 'package:metamorfose_flutter/components/input_field.dart';
import 'package:url_launcher/url_launcher.dart';

class NewSosScreen extends StatefulWidget {
  const NewSosScreen({super.key});

  @override
  State<NewSosScreen> createState() => _NewSosScreenState();
}

class SosScreen extends StatelessWidget {
  const SosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NewSosScreen();
  }
}

class _NewSosScreenState extends State<NewSosScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  SosContact? _lastKnownContact;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);

    context.read<SosBloc>().add(InitializeSosEvent());

    // Inicializar o contato conhecido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = context.read<SosBloc>().state;
      _lastKnownContact = currentState.emergencyContact;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _forceUIUpdateAfterContactDeletion() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final maxContentWidth = ResponsiveValue<double>(
      context,
      defaultValue: 500.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: double.infinity),
        Condition.largerThan(name: TABLET, value: 600.0),
      ],
    ).value;

    return BlocConsumer<SosBloc, SosState>(
      listener: (context, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.whiteLight,
                ),
                textAlign: TextAlign.center,
              ),
              backgroundColor: MetamorfoseColors.redNormal,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(horizontalPadding),
            ),
          );
          context.read<SosBloc>().add(ClearSosErrorEvent());
        }

        final previousContact = _lastKnownContact;
        if (state.emergencyContact != previousContact) {
          _lastKnownContact = state.emergencyContact;
          if (mounted) {
            setState(() {});
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MetamorfoseColors.purpleDark,
                  MetamorfoseColors.purpleNormal,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () => context.go('/home'),
                          color: MetamorfoseColors.whiteLight,
                        ),
                        floating: true,
                        snap: true,
                        elevation: 0,
                      ),

                      // Conteúdo principal
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildSmallSosButton(),

                              SizedBox(height: spacing),

                              // Título da seção
                              Text(
                                'Como podemos ajudar?',
                                style: AppTypography.displayMedium.copyWith(
                                  color: MetamorfoseColors.whiteLight,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                              ),

                              SizedBox(height: spacing / 2),

                              // Subtítulo
                              Text(
                                'Escolha uma das opções abaixo para receber suporte',
                                style: AppTypography.titleMedium.copyWith(
                                  color: MetamorfoseColors.whiteLight
                                      .withOpacity(0.8),
                                ),
                                textAlign: TextAlign.start,
                              ),

                              SizedBox(height: spacing),

                              // Grid de opções
                              _buildOptionsGrid(context, spacing),

                              SizedBox(height: spacing),

                              // Seção de contatos de emergência
                              _buildEmergencyContactSection(state, context),

                              SizedBox(height: spacing),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallSosButton() {
    final buttonSize = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.read<SosBloc>().add(ActivateSosEvent()),
          borderRadius: BorderRadius.circular(buttonSize / 2),
          splashColor: MetamorfoseColors.whiteLight.withOpacity(0.2),
          highlightColor: MetamorfoseColors.whiteLight.withOpacity(0.1),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        MetamorfoseColors.redNormal,
                        MetamorfoseColors.pinkNormal,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MetamorfoseColors.purpleLight.withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'SOS',
                      textAlign: TextAlign.center,
                      style: AppTypography.displaySmall.copyWith(
                        color: MetamorfoseColors.whiteLight,
                        fontWeight: FontWeight.w900,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(BuildContext context, double spacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 600;
        final isMediumScreen = screenWidth < 900;

        final crossAxisCount = isSmallScreen ? 1 : (isMediumScreen ? 2 : 3);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: isSmallScreen ? 3.2 : 2.4,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final items = [
              {
                'icon': Icons.chat_bubble_outline,
                'title': 'Conversar com sua Planta',
                'subtitle': 'Sua companheira está aqui para ouvir você',
                'color': MetamorfoseColors.greenNormal,
                'onTap': () =>
                    context.push('/chat', extra: PersonalityType.padrao),
              },
              {
                'icon': Icons.support_agent_rounded,
                'title': 'Encontrar Psicólogos',
                'subtitle': 'Profissionais prontos para ajudar',
                'color': MetamorfoseColors.purpleNormal,
                'onTap': () => context.push('/psychologists?from=sos'),
              },
              {
                'icon': Icons.spa_outlined,
                'title': 'Exercícios de Respiração',
                'subtitle': 'Técnicas para acalmar e relaxar',
                'color': MetamorfoseColors.blueNormal,
                'onTap': () => _showBreathingExercises(context),
              },
              {
                'icon': Icons.emergency_outlined,
                'title': 'CVV - 188',
                'subtitle': 'Atendimento gratuito 24h',
                'color': MetamorfoseColors.redNormal,
                'onTap': () async {
                  final url = Uri.parse('tel:188');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              },
            ];

            final item = items[index];

            return _buildResponsiveOptionCard(
              icon: item['icon'] as IconData,
              title: item['title'] as String,
              subtitle: item['subtitle'] as String,
              color: item['color'] as Color,
              onTap: item['onTap'] as VoidCallback,
              context: context,
            );
          },
        );
      },
    );
  }

  Widget _buildResponsiveOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    required BuildContext context,
  }) {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 14.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 15.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final subtitleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 13.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 14.0),
      ],
    ).value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: MetamorfoseColors.whiteLight,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: MetamorfoseColors.shadowLight,
                offset: const Offset(0, 4),
                blurRadius: 24,
                spreadRadius: -2,
              ),
            ],
            border: Border.all(
              color: MetamorfoseColors.greyLightest2,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(spacing * 0.75),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(borderRadius * 0.6),
                ),
                child: Icon(icon, color: color, size: iconSize),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        color: MetamorfoseColors.blackLight,
                        fontWeight: FontWeight.w700,
                        fontSize: titleFontSize,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacing * 0.3),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: subtitleFontSize,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing * 0.5),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withOpacity(0.6),
                size: iconSize * 0.7,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactSection(SosState state, BuildContext context) {
    if (state.hasEmergencyContact && state.emergencyContact != null) {
      return _buildExistingContactCard(state.emergencyContact!, context);
    }
    return _buildAddContactCard(context);
  }

  Widget _buildAddContactCard(BuildContext context) {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final cardHeight = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final subtitleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showAddContactModal(context),
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: MetamorfoseColors.purpleNormal.withOpacity(0.1),
        highlightColor: MetamorfoseColors.purpleNormal.withOpacity(0.05),
        child: Container(
          constraints: BoxConstraints(minHeight: cardHeight),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: MetamorfoseColors.whiteLight,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: MetamorfoseColors.shadowLight,
                offset: const Offset(0, 4),
                blurRadius: 24,
                spreadRadius: -2,
              ),
            ],
            border: Border.all(
              color: MetamorfoseColors.greyLightest2,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing * 0.6),
                decoration: BoxDecoration(
                  color: MetamorfoseColors.blueNormal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(borderRadius * 0.6),
                ),
                child: Icon(
                  Icons.person_add,
                  color: MetamorfoseColors.blueNormal,
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contato de Emergência',
                      style: AppTypography.titleSmall.copyWith(
                        color: MetamorfoseColors.blackLight,
                        fontWeight: FontWeight.w700,
                        fontSize: titleFontSize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      'Adicione alguém de confiança',
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: subtitleFontSize,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: MetamorfoseColors.blueNormal.withOpacity(0.6),
                  size: iconSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExistingContactCard(SosContact contact, BuildContext context) {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final cardHeight = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final subtitleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Container(
      constraints: BoxConstraints(minHeight: cardHeight),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: MetamorfoseColors.whiteLight,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: MetamorfoseColors.shadowLight,
            offset: const Offset(0, 4),
            blurRadius: 24,
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
          color: MetamorfoseColors.greyLightest2,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing * 0.6),
                decoration: BoxDecoration(
                  color: MetamorfoseColors.greenNormal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(borderRadius * 0.6),
                ),
                child: Icon(
                  Icons.emergency,
                  color: MetamorfoseColors.greenNormal,
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contato de Emergência',
                      style: AppTypography.titleSmall.copyWith(
                        color: MetamorfoseColors.blackLight,
                        fontWeight: FontWeight.w700,
                        fontSize: titleFontSize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      '${contact.name} - ${contact.phoneNumber}',
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyDark,
                        fontSize: subtitleFontSize,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showEditContactModal(contact, context),
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    padding: EdgeInsets.all(spacing * 0.5),
                    child: Icon(
                      Icons.edit,
                      color: MetamorfoseColors.blueNormal,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(
                child: MetamorfeseButton(
                  onPressed: () => _enviarMensagemWhatsApp(contact),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('MENSAGEM',
                          style: TextStyle(
                              fontFamily: 'DinNext',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetamorfeseButton(
                  onPressed: () => _makeEmergencyCall(contact),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('LIGAR',
                          style: TextStyle(
                              fontFamily: 'DinNext',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _enviarMensagemWhatsApp(SosContact contact) async {
    final telefone = _formatarTelefoneParaWhatsApp(contact.phoneNumber);
    final mensagem = """
Oi, ${contact.name}! Esse é um alerta SOS do aplicativo Metamorfose.
Estou em um momento difícil e preciso de ajuda agora.
Podemos conversar?
""";

    final url = Uri.parse(
      "https://wa.me/$telefone?text=${Uri.encodeComponent(mensagem)}",
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Não foi possível abrir o WhatsApp."),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao abrir WhatsApp: $e"),
            backgroundColor: MetamorfoseColors.redNormal,
          ),
        );
      }
    }
  }

  String _formatarTelefoneParaWhatsApp(String telefone) {
    String numeros = telefone.replaceAll(RegExp(r'[^\d]'), '');
    if (numeros.length == 13) return numeros;
    if (numeros.length == 12) return '55$numeros';
    if (numeros.length == 11) return '55$numeros';
    if (numeros.length == 10) return '55$numeros';
    return numeros;
  }

  Future<void> _makeEmergencyCall(SosContact contact) async {
    final url = Uri.parse('tel:${contact.phoneNumber}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao fazer ligação: $e"),
            backgroundColor: MetamorfoseColors.redNormal,
          ),
        );
      }
    }
  }

  void _showAddContactModal(BuildContext context) {
    final bool useCompactLayout = ResponsiveBreakpoints.of(context).isMobile;

    if (useCompactLayout) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => BlocProvider.value(
          value: context.read<SosBloc>(),
          child: _EmergencyContactModal(
            useCompactLayout: useCompactLayout,
            isEditing: false,
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        useSafeArea: true,
        builder: (_) => BlocProvider.value(
          value: context.read<SosBloc>(),
          child: _EmergencyContactModal(
            useCompactLayout: useCompactLayout,
            isEditing: false,
          ),
        ),
      );
    }
  }

  void _showEditContactModal(SosContact contact, BuildContext context) {
    final bool useCompactLayout = ResponsiveBreakpoints.of(context).isMobile;

    if (useCompactLayout) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => BlocProvider.value(
          value: context.read<SosBloc>(),
          child: _EmergencyContactModal(
            useCompactLayout: useCompactLayout,
            isEditing: true,
            contact: contact,
            onContactDeleted: _forceUIUpdateAfterContactDeletion,
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        useSafeArea: true,
        builder: (_) => BlocProvider.value(
          value: context.read<SosBloc>(),
          child: _EmergencyContactModal(
            useCompactLayout: useCompactLayout,
            isEditing: true,
            contact: contact,
            onContactDeleted: _forceUIUpdateAfterContactDeletion,
          ),
        ),
      );
    }
  }

  void _showBreathingExercises(BuildContext context) {
    // TODO: Implementar modal de exercícios de respiração
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exercícios de respiração em breve!'),
        backgroundColor: MetamorfoseColors.blueNormal,
      ),
    );
  }
}

// Modal completo para contatos de emergência (copiado do sos_screen.dart original)
class _EmergencyContactModal extends StatefulWidget {
  final bool useCompactLayout;
  final bool isEditing;
  final SosContact? contact;
  final VoidCallback? onContactDeleted;

  const _EmergencyContactModal({
    required this.useCompactLayout,
    required this.isEditing,
    this.contact,
    this.onContactDeleted,
  });

  @override
  State<_EmergencyContactModal> createState() => _EmergencyContactModalState();
}

class _EmergencyContactModalState extends State<_EmergencyContactModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();

  bool _isLoading = false;
  String? _nameError;
  String? _phoneError;
  String? _relationshipError;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phoneNumber;
      _relationshipController.text = widget.contact!.message ?? '';
    }

    _nameController.addListener(_validateName);
    _phoneController.addListener(_validatePhone);
    _relationshipController.addListener(_validateRelationship);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _nameError =
          _nameController.text.trim().isEmpty ? 'Nome é obrigatório' : null;
    });
  }

  void _validatePhone() {
    setState(() {
      if (_phoneController.text.trim().isEmpty) {
        _phoneError = 'Telefone é obrigatório';
      } else {
        final cleanPhone =
            _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
        if (cleanPhone.length < 10 || cleanPhone.length > 11) {
          _phoneError = 'Digite um telefone válido (10 ou 11 dígitos)';
        } else {
          _phoneError = null;
        }
      }
    });
  }

  void _validateRelationship() {
    setState(() {
      _relationshipError = null;
    });
  }

  String _formatPhoneNumber(String phone) {
    String numbers = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (numbers.length > 11) {
      numbers = numbers.substring(0, 11);
    }
    if (numbers.length <= 2) {
      return numbers;
    } else if (numbers.length <= 7) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2)}';
    } else if (numbers.length <= 11) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    }
    return numbers;
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final sosBloc = context.read<SosBloc>();
      final sosService = SosService();

      final contact = SosContact(
        id: widget.contact?.id ?? sosService.generateContactId(),
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        message: _relationshipController.text.trim().isNotEmpty
            ? _relationshipController.text.trim()
            : null,
        isActive: true,
        createdAt: widget.contact?.createdAt ?? DateTime.now(),
      );

      if (widget.isEditing) {
        sosBloc.add(UpdateEmergencyContactEvent(contact));
      } else {
        sosBloc.add(SaveEmergencyContactEvent(contact));
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? 'Contato atualizado com sucesso!'
                  : 'Contato salvo com sucesso!',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.whiteLight,
              ),
            ),
            backgroundColor: MetamorfoseColors.greenNormal,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(24),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar contato: $e',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.whiteLight,
              ),
            ),
            backgroundColor: MetamorfoseColors.redNormal,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(24),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteContact() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MetamorfoseColors.whiteLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Excluir Contato',
          style: AppTypography.titleMedium.copyWith(
            color: MetamorfoseColors.greyDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir este contato de emergência?',
          style: AppTypography.bodyMedium.copyWith(
            color: MetamorfoseColors.greyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'CANCELAR',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.greyMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: MetamorfoseColors.redNormal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'EXCLUIR',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.whiteLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        _nameController.clear();
        _phoneController.clear();
        _relationshipController.clear();

        final sosBloc = context.read<SosBloc>();
        final emptyContact = SosContact(
          id: widget.contact!.id,
          name: '',
          phoneNumber: '',
          message: '',
          isActive: false,
          createdAt: widget.contact!.createdAt,
        );

        sosBloc.add(UpdateEmergencyContactEvent(emptyContact));

        if (mounted) {
          if (widget.onContactDeleted != null) {
            widget.onContactDeleted!();
          }
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Contato excluído com sucesso!',
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.whiteLight,
                ),
              ),
              backgroundColor: MetamorfoseColors.redNormal,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(24),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao excluir contato: $e',
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.whiteLight,
                ),
              ),
              backgroundColor: MetamorfoseColors.redNormal,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(24),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveValue<double>(
      context,
      defaultValue: 500.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: double.infinity),
        Condition.largerThan(name: TABLET, value: 600.0),
      ],
    ).value;

    if (widget.useCompactLayout) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(32),
        child: Container(
          width: maxWidth,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: MetamorfoseColors.whiteLight,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: _buildModalContent(),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: MetamorfoseColors.whiteLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _buildModalContent(),
      );
    }
  }

  Widget _buildModalContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.useCompactLayout)
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MetamorfoseColors.greyLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        Padding(
          padding: EdgeInsets.all(widget.useCompactLayout ? 32 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.isEditing
                          ? 'Editar Contato de Emergência'
                          : 'Adicionar Contato de Emergência',
                      style: AppTypography.titleLarge.copyWith(
                        color: MetamorfoseColors.greyDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (widget.useCompactLayout)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close,
                          color: MetamorfoseColors.greyMedium),
                    ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Configure um contato de confiança para emergências',
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: widget.useCompactLayout ? 32 : 24,
              ),
              children: [
                InputField(
                  hintText: 'Nome completo',
                  controller: _nameController,
                  errorText: _nameError,
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    size: 20,
                    color: MetamorfoseColors.purpleLight,
                  ),
                ),
                SizedBox(height: 16),
                InputField(
                  hintText: 'Telefone',
                  controller: _phoneController,
                  errorText: _phoneError,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: MetamorfoseColors.purpleLight,
                  ),
                  onChanged: (value) {
                    final formatted = _formatPhoneNumber(value);
                    if (formatted != value) {
                      _phoneController.value = _phoneController.value.copyWith(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                InputField(
                  hintText: 'Relacionamento (ex.: mãe, amigo, parceiro)',
                  controller: _relationshipController,
                  errorText: _relationshipError,
                  prefixIcon: const Icon(
                    Icons.favorite_outline,
                    size: 20,
                    color: MetamorfoseColors.purpleLight,
                  ),
                ),
                SizedBox(height: widget.useCompactLayout ? 32 : 24),
                _buildActionButtons(),
                SizedBox(height: widget.useCompactLayout ? 32 : 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        MetamorfeseButton(
          onPressed: _isLoading ? () {} : () => _saveContact(),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      MetamorfoseColors.whiteLight,
                    ),
                  ),
                )
              : Text(
                  widget.isEditing ? 'ATUALIZAR CONTATO' : 'SALVAR CONTATO',
                  style: TextStyle(
                    fontFamily: 'DinNext',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
        if (widget.isEditing) ...[
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: _isLoading
                  ? MetamorfoseColors.redNormal.withOpacity(0.5)
                  : MetamorfoseColors.redNormal,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: MetamorfoseColors.redNormal,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isLoading ? null : () => _deleteContact(),
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(
                    'EXCLUIR CONTATO',
                    style: TextStyle(
                      color: MetamorfoseColors.whiteLight,
                      fontSize: 15,
                      fontFamily: 'DinNext',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        SizedBox(height: 16),
        MetamorfeseSecondaryButton(
          text: 'CANCELAR',
          onPressed: _isLoading ? () {} : () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
