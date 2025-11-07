/**
 * File: psychologist_profile_screen.dart
 * Description: Tela responsável por exibir o perfil detalhado de um psicólogo.
 *
 * Responsabilidades:
 * - Carregar dados do psicólogo selecionado a partir do PsychologistService.
 * - Exibir informações completas (foto, especialidade, contato, formação, métodos, etc).
 * - Apresentar métricas visuais de compatibilidade e botões de ação (agendar, mensagem).
 * - Adaptar o layout dinamicamente para diferentes tamanhos de tela (responsividade).
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:metamorfose_flutter/components/metamorfose_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:metamorfose_flutter/services/psychologist_service.dart';
import 'package:metamorfose_flutter/models/psychologist.dart';
import 'package:metamorfose_flutter/theme/typography.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PsychologistProfileScreen extends StatelessWidget {
  final String id;
  final String? from;

  const PsychologistProfileScreen({
    Key? key,
    required this.id,
    this.from,
  }) : super(key: key);

  BoxDecoration _getCardDecoration() {
    return BoxDecoration(
      color: MetamorfoseColors.whiteLight,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: MetamorfoseColors.greyLightest2,
        width: 1,
      ),
      boxShadow: const [
        BoxShadow(
          color: MetamorfoseColors.defaultButtonShadow,
          blurRadius: 0,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = PsychologistService();

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
        Condition.largerThan(name: DESKTOP, value: 80.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
        Condition.largerThan(name: DESKTOP, value: 40.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
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

    return FutureBuilder<Psychologist?>(
      future: service.getById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: MetamorfoseColors.whiteLight,
            body: Center(
              child: CircularProgressIndicator(
                color: MetamorfoseColors.purpleNormal,
              ),
            ),
          );
        }

        final p = snapshot.data;
        if (p == null) {
          return Scaffold(
            backgroundColor: MetamorfoseColors.whiteLight,
            appBar: AppBar(
              backgroundColor: MetamorfoseColors.whiteLight,
              elevation: 0,
              title: Text(
                'Psicólogo',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: MetamorfoseColors.greyLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Perfil não encontrado',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MetamorfoseColors.greyMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final score = (_hashToScore(p.id));
        final isWide = MediaQuery.of(context).size.width > 700;

        return Scaffold(
          backgroundColor: MetamorfoseColors.whiteLight,
          appBar: AppBar(
            backgroundColor: MetamorfoseColors.whiteLight,
            elevation: 0,
            leading: IconButton(
              onPressed: () =>
                  context.go('/psychologists?from=${from ?? "sos"}'),
              icon: SvgPicture.asset(
                'assets/images/arrow_back.svg',
                width: iconSize,
                height: iconSize,
              ),
            ),
            title: Text(
              'Perfil do Psicólogo',
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: ResponsiveValue<double>(
                  context,
                  defaultValue: 20.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 18.0),
                    Condition.largerThan(name: TABLET, value: 22.0),
                  ],
                ).value,
                fontWeight: FontWeight.bold,
                color: MetamorfoseColors.greyMedium,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final content = [
                  // Card principal com foto e informações básicas
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: _getCardDecoration(),
                      margin: EdgeInsets.only(bottom: spacing),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: MetamorfoseColors.purpleLight
                                          .withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: isWide ? 56 : 48,
                                  backgroundColor: MetamorfoseColors.purpleLight
                                      .withOpacity(0.15),
                                  backgroundImage: p.photoUrl != null
                                      ? NetworkImage(p.photoUrl!)
                                      : null,
                                  child: p.photoUrl == null
                                      ? Icon(
                                          Icons.person,
                                          color: MetamorfoseColors.purpleNormal,
                                          size: isWide ? 56 : 48,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(width: spacing),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: TextStyle(
                                        fontFamily: 'DinNext',
                                        fontSize: isWide ? 24 : 20,
                                        fontWeight: FontWeight.bold,
                                        color: MetamorfoseColors.blackLight,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: MetamorfoseColors.purpleLight
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: MetamorfoseColors.purpleLight
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        p.specialty,
                                        style: TextStyle(
                                          fontFamily: 'DinNext',
                                          fontSize: isWide ? 15 : 14,
                                          fontWeight: FontWeight.w600,
                                          color: MetamorfoseColors.purpleNormal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Informações de contato
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoChip(
                                  Icons.location_on,
                                  p.location,
                                  MetamorfoseColors.redNormal,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoChip(
                                  Icons.phone,
                                  p.phone,
                                  MetamorfoseColors.greenNormal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Card de compatibilidade
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: _getCardDecoration(),
                      margin: EdgeInsets.only(bottom: spacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: MetamorfoseColors.greenNormal
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color: MetamorfoseColors.greenNormal,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Compatibilidade',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: MetamorfoseColors.greyMedium,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: score / 100,
                                    color: MetamorfoseColors.greenNormal,
                                    backgroundColor:
                                        MetamorfoseColors.greyLightest2,
                                    minHeight: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: MetamorfoseColors.greenNormal
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${score.toInt()}%',
                                  style: TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: MetamorfoseColors.greenNormal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sobre mim
                  _buildSectionTitle('Sobre mim', Icons.person_outline),
                  SizedBox(height: spacing * 0.75),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: _getCardDecoration(),
                      child: Text(
                        p.about,
                        style: TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 15,
                          color: MetamorfoseColors.greyMedium,
                          height: 1.6,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),

                  // Especialidades
                  _buildSectionTitle(
                    'Especialidades',
                    Icons.medical_services_outlined,
                  ),
                  SizedBox(height: spacing * 0.75),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: _getCardDecoration(),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: p.addictions
                            .map((a) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MetamorfoseColors.redLight
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: MetamorfoseColors.redLight
                                          .withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    a,
                                    style: TextStyle(
                                      fontFamily: 'DinNext',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: MetamorfoseColors.redNormal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),

                  // Métodos de atendimento
                  _buildSectionTitle(
                    'Métodos de atendimento',
                    Icons.psychology_outlined,
                  ),
                  SizedBox(height: spacing * 0.75),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: _getCardDecoration(),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: p.methods
                            .map((m) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MetamorfoseColors.greenLight
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: MetamorfoseColors.greenLight
                                          .withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    m,
                                    style: TextStyle(
                                      fontFamily: 'DinNext',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: MetamorfoseColors.greenNormal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),

                  // Formação e experiência
                  _buildSectionTitle('Formação', Icons.school_outlined),
                  SizedBox(height: spacing * 0.75),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: _getCardDecoration(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: MetamorfoseColors.purpleLight
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.school,
                                  color: MetamorfoseColors.purpleNormal,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  p.formation,
                                  style: TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: MetamorfoseColors.blackLight,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: MetamorfoseColors.purpleLight
                                  .withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: MetamorfoseColors.purpleNormal,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${p.experienceYears} anos de experiência',
                                  style: TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: MetamorfoseColors.purpleNormal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),

                  // Mensagem do profissional
                  _buildSectionTitle(
                    'Mensagem do profissional',
                    Icons.chat_bubble_outline,
                  ),
                  SizedBox(height: spacing * 0.75),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: _getCardDecoration(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: MetamorfoseColors.purpleLight,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              p.testimonial,
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: 15,
                                color: MetamorfoseColors.greyMedium,
                                fontStyle: FontStyle.italic,
                                height: 1.6,
                              ),
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: spacing * 1.5),

                  // Botões de ação
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MetamorfeseButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Agendar',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: spacing * 0.75),
                        MetamorfeseButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Enviar Mensagem',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ];

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: content.sublist(0, 2),
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: content.sublist(2),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: content,
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MetamorfoseColors.purpleLight.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: MetamorfoseColors.purpleNormal,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MetamorfoseColors.blackLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static double _hashToScore(String id) {
    var sum = 0;
    for (var i = 0; i < id.length; i++) {
      sum += id.codeUnitAt(i);
    }
    final v = 70 + (sum % 29);
    return v.toDouble();
  }
}
