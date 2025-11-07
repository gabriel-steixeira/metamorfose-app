/// File: user_profile_screen.dart
/// Description: Tela de perfil do usuário
///
/// Responsabilidades:
/// - Exibir informações do usuário (nome, data de nascimento, telefone, email)
/// - Calcular e exibir idade baseada na data de nascimento
/// - Fornecer botões para atualizar cadastro, trocar senha e sair
/// - Gerenciar navegação para telas relacionadas
///
/// Author: Vitoria Lana
/// 
/// Changes:
/// - Adicionado MetamorphosisProgress. (Evelin Cordeiro)
/// 
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/components/custom_button.dart';
import 'package:metamorfose_flutter/services/auth_service.dart';
import 'package:metamorfose_flutter/models/user_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Enum para as fases da metamorfose
enum MetamorphosisPhase {
  egg,
  caterpillar,
  chrysalis,
  butterfly,
}

/// Tela de perfil do usuário com informações pessoais e opções de ação
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Carrega os dados do usuário atual
  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        // Se não tem foto no Firestore, usar a do Firebase Auth
        final finalUserData = userData.photoUrl != null
            ? userData
            : UserModel(
                id: userData.id,
                email: userData.email,
                name: userData.name,
                completeName: userData.completeName,
                photoUrl: userData.photoUrl,
                phoneNumber: userData.phoneNumber,
                birthDate: userData.birthDate,
                createdAt: userData.createdAt,
                updatedAt: userData.updatedAt,
              );
        setState(() {
          _userModel = finalUserData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Usuário não encontrado';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados do usuário: $e';
        _isLoading = false;
      });
    }
  }

  /// Calcula a idade baseada na data de nascimento
  int? _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return null;

    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Formata a data para exibição
  String _formatDate(DateTime? date) {
    if (date == null) return 'Não informado';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Retorna o BoxDecoration padrão com shadow para os cards
  BoxDecoration _getCardDecoration() {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return BoxDecoration(
      color: MetamorfoseColors.whiteLight,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: MetamorfoseColors.greyLightest2,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: MetamorfoseColors.defaultButtonShadow,
          blurRadius: 0,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    );
  }

  /// Constrói o header com informações básicas do usuário
  Widget _buildUserHeader() {
    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final avatarSize = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    final nameFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final subtitleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
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

    final smallSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: ResponsiveValue<double>(
          context,
          defaultValue: 230.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 200.0),
            Condition.largerThan(name: TABLET, value: 260.0),
          ],
        ).value,
      ),
      padding: EdgeInsets.all(padding),
      decoration: _getCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar do usuário
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MetamorfoseColors.purpleLight.withOpacity(0.1),
              border: Border.all(
                color: MetamorfoseColors.purpleLight,
                width: 2,
              ),
            ),
            child: _buildUserAvatar(avatarSize),
          ),

          SizedBox(height: spacing),

          // Nome completo do usuário
          Text(
            _userModel?.completeName ?? 'Nome não informado',
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: nameFontSize,
              fontWeight: FontWeight.bold,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: smallSpacing),

          // Username do usuário
          Text(
            _userModel?.name ?? 'Username não informado',
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.normal,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: smallSpacing),

          // Email do usuário
          Text(
            _userModel?.email ?? 'Email não informado',
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.normal,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Constrói o avatar do usuário
  Widget _buildUserAvatar(double size) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Prioriza a foto do Firebase Auth primeiro, depois Firestore
    final photoUrl = currentUser?.photoURL ?? _userModel?.photoUrl;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          photoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar(size);
          },
        ),
      );
    }

    return _buildDefaultAvatar(size);
  }

  /// Constrói o avatar padrão
  Widget _buildDefaultAvatar(double size) {
    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: size * 0.5,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 30.0),
        Condition.largerThan(name: TABLET, value: 50.0),
      ],
    ).value;

    return Icon(
      Icons.person,
      size: iconSize,
      color: MetamorfoseColors.purpleLight,
    );
  }

  /// Constrói as informações detalhadas do usuário
  Widget _buildUserInfo() {
    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
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

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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

    final rowSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: _getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: MetamorfoseColors.purpleLight,
                size: iconSize,
              ),
              SizedBox(width: 8),
              Text(
                'Informações Pessoais',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          SizedBox(height: spacing),

          // Data de nascimento e idade na mesma linha
          _buildInfoRow(
            icon: Icons.cake,
            label: 'Data de Nascimento',
            value: _userModel?.birthDate != null
                ? '${_formatDate(_userModel?.birthDate)} (${_calculateAge(_userModel?.birthDate)?.toString() ?? 'Idade não calculada'} anos)'
                : 'Não informado',
          ),

          SizedBox(height: rowSpacing),

          // Telefone
          _buildInfoRow(
            icon: Icons.phone,
            label: 'Telefone',
            value: _userModel?.phoneNumber ?? 'Não informado',
          ),

          SizedBox(height: rowSpacing),

          // Email
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'E-mail',
            value: _userModel?.email ?? 'Não informado',
          ),
        ],
      ),
    );
  }

  /// Constrói uma linha de informação
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final iconContainerSize = ResponsiveValue<double>(
      context,
      defaultValue: 40.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 36.0),
        Condition.largerThan(name: TABLET, value: 44.0),
      ],
    ).value;

    final iconContainerHeight = ResponsiveValue<double>(
      context,
      defaultValue: 43.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 52.0),
      ],
    ).value;

    final iconPadding = ResponsiveValue<double>(
      context,
      defaultValue: 10.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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

    final labelFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final valueFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final smallSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 4.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 3.0),
        Condition.largerThan(name: TABLET, value: 5.0),
      ],
    ).value;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: iconContainerSize,
          height: iconContainerHeight,
          padding: EdgeInsets.all(iconPadding),
          child: Center(
            child: Icon(
              icon,
              color: MetamorfoseColors.purpleLight,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.w500,
                  color: MetamorfoseColors.greyMedium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: smallSpacing),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.normal,
                  color: MetamorfoseColors.greyMedium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Constrói o card de progresso da metamorfose
  Widget _buildMetamorphosisProgress() {
    // TODO: Implementar lógica para determinar a fase atual do usuário
    // Por enquanto, vamos usar uma porcentagem fixa para demonstração
    // Aqui você pode implementar a lógica baseada em dados reais do usuário
    const userProgress = 10; // Exemplo: 75% de progresso
    final currentPhase = _getPhaseByProgress(userProgress);

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
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

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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

    final phaseTitleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    final descriptionFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final progressFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final percentageFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
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

    final smallSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final mediumSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: _getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: MetamorfoseColors.purpleLight,
                size: iconSize,
              ),
              SizedBox(width: 8),
              Text(
                'Minha Metamorfose',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          SizedBox(height: spacing),

          // Imagem da fase atual
          Center(
            child: Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MetamorfoseColors.purpleLight.withOpacity(0.1),
                border: Border.all(
                  color: MetamorfoseColors.purpleLight,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: _getPhaseImage(currentPhase, imageSize),
              ),
            ),
          ),

          SizedBox(height: mediumSpacing),

          // Título da fase
          Center(
            child: Text(
              _getPhaseTitle(currentPhase),
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: phaseTitleFontSize,
                fontWeight: FontWeight.bold,
                color: MetamorfoseColors.purpleNormal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: smallSpacing),

          // Descrição da fase
          Center(
            child: Text(
              _getPhaseDescription(currentPhase),
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: descriptionFontSize,
                fontWeight: FontWeight.normal,
                color: MetamorfoseColors.greyMedium,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: spacing),

          // Barra de progresso
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progresso',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: progressFontSize,
                      fontWeight: FontWeight.bold,
                      color: MetamorfoseColors.greyMedium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$userProgress%',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: percentageFontSize,
                      fontWeight: FontWeight.bold,
                      color: MetamorfoseColors.purpleNormal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(height: smallSpacing),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: MetamorfoseColors.greyLightest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: userProgress / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          MetamorfoseColors.purpleLight,
                          MetamorfoseColors.greenLight,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Retorna a imagem da fase atual
  Widget _getPhaseImage(MetamorphosisPhase phase, double size) {
    switch (phase) {
      case MetamorphosisPhase.egg:
        return Image.asset(
          'assets/images/onboarding/ic_egg.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        );
      case MetamorphosisPhase.caterpillar:
        return Image.asset(
          'assets/images/onboarding/ic_caterpillar.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        );
      case MetamorphosisPhase.chrysalis:
        return Image.asset(
          'assets/images/onboarding/ic_chrysalis.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        );
      case MetamorphosisPhase.butterfly:
        return SvgPicture.asset(
          'assets/images/onboarding/ic_butterfly.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
        );
    }
  }

  /// Retorna o título da fase
  String _getPhaseTitle(MetamorphosisPhase phase) {
    switch (phase) {
      case MetamorphosisPhase.egg:
        return 'Ovo';
      case MetamorphosisPhase.caterpillar:
        return 'Lagarta';
      case MetamorphosisPhase.chrysalis:
        return 'Crisálida';
      case MetamorphosisPhase.butterfly:
        return 'Borboleta';
    }
  }

  /// Retorna a descrição da fase
  String _getPhaseDescription(MetamorphosisPhase phase) {
    switch (phase) {
      case MetamorphosisPhase.egg:
        return 'Iniciando sua jornada de superação';
      case MetamorphosisPhase.caterpillar:
        return 'Sua transformação está acontecendo';
      case MetamorphosisPhase.chrysalis:
        return 'Crescendo e aprendendo a cuidar de si mesmo';
      case MetamorphosisPhase.butterfly:
        return 'Você se tornou livre e transformado!';
    }
  }


  /// Determina a fase baseada na porcentagem de progresso
  MetamorphosisPhase _getPhaseByProgress(int progress) {
    if (progress < 30) {
      return MetamorphosisPhase.egg;
    } else if (progress < 60) {
      return MetamorphosisPhase.caterpillar;
    } else if (progress < 90) {
      return MetamorphosisPhase.chrysalis;
    } else {
      return MetamorphosisPhase.butterfly;
    }
  }

  /// Constrói os botões de ação
  Widget _buildActionButtons() {
    final buttonSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Column(
      children: [
        // Botão Atualizar Cadastro
        CustomButton(
          text: 'ATUALIZAR CADASTRO',
          onPressed: () {
            // TODO: Navegar para tela de atualização de cadastro
            context.go('/update-profile');
          },
          backgroundColor: MetamorfoseColors.purpleNormal,
          textColor: MetamorfoseColors.whiteLight,
          shadowColor: MetamorfoseColors.purpleDark,
          strokeColor: MetamorfoseColors.purpleNormal,
        ),

        SizedBox(height: buttonSpacing),

        // Botão Trocar Senha
        CustomButton(
          text: 'TROCAR SENHA',
          onPressed: () {
            // TODO: Navegar para tela de troca de senha
            context.go('/change-password');
          },
          backgroundColor: MetamorfoseColors.blueNormal,
          textColor: MetamorfoseColors.whiteLight,
          shadowColor: MetamorfoseColors.blueDark,
          strokeColor: MetamorfoseColors.blueNormal,
        ),
      ],
    );
  }

  /// Constrói o estado de loading
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: MetamorfoseColors.purpleNormal,
      ),
    );
  }

  /// Constrói o estado de erro
  Widget _buildErrorState() {
    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 64.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 48.0),
        Condition.largerThan(name: TABLET, value: 80.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: iconSize,
            color: MetamorfoseColors.redNormal,
          ),
          SizedBox(height: spacing),
          Text(
            _errorMessage ?? 'Erro desconhecido',
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: fontSize,
              color: MetamorfoseColors.redNormal,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: spacing),
          CustomButton(
            text: 'TENTAR NOVAMENTE',
            onPressed: _loadUserData,
            backgroundColor: MetamorfoseColors.purpleNormal,
            textColor: MetamorfoseColors.whiteLight,
            shadowColor: MetamorfoseColors.purpleDark,
            strokeColor: MetamorfoseColors.purpleNormal,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Valores responsivos globais
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      appBar: AppBar(
        backgroundColor: MetamorfoseColors.whiteLight,
        elevation: 0,
        title: Text(
          'Meu Perfil',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header com informações básicas
                        _buildUserHeader(),

                        SizedBox(height: verticalPadding),

                        // Informações detalhadas
                        _buildUserInfo(),

                        SizedBox(height: verticalPadding),

                        // Card de progresso da metamorfose
                        _buildMetamorphosisProgress(),

                        SizedBox(height: verticalPadding + 4),

                        // Botões de ação
                        _buildActionButtons(),

                        SizedBox(height: verticalPadding),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: const BottomNavigationMenu(
        activeIndex: 1, // Perfil ativo
      ),
    );
  }
}
