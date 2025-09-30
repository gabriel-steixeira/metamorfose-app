/**
 * File: user_profile_screen.dart
 * Description: Tela de perfil do usuário
 *
 * Responsabilidades:
 * - Exibir informações do usuário (nome, data de nascimento, telefone, email)
 * - Calcular e exibir idade baseada na data de nascimento
 * - Fornecer botões para atualizar cadastro, trocar senha e sair
 * - Gerenciar navegação para telas relacionadas
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 06-08-2025
 * Last modified: 31-08-2025
 * 
 * Changes:
 * - Adicionado MetamorphosisProgress. (Evelin Cordeiro)
 * 
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/text_styles.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/components/custom_button.dart';
import 'package:metamorfose_flutter/components/confirmation_dialog.dart';
import 'package:metamorfose_flutter/services/auth_service.dart';
import 'package:metamorfose_flutter/models/user_model.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
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
        final finalUserData = userData?.photoUrl != null
            ? userData
            : UserModel(
                id: userData?.id ?? user.uid,
                email: userData?.email ?? user.email ?? '',
                name: userData?.name ?? user.displayName,
                completeName: userData?.completeName ?? user.displayName,
                photoUrl: userData?.photoUrl ?? user.photoURL,
                phoneNumber: userData?.phoneNumber ?? user.phoneNumber,
                birthDate: userData?.birthDate,
                createdAt: userData?.createdAt ?? DateTime.now(),
                updatedAt: userData?.updatedAt ?? DateTime.now(),
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
  BoxDecoration get _cardDecoration => BoxDecoration(
        color: MetamorfoseColors.whiteLight,
        borderRadius: BorderRadius.circular(12),
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

  /// Constrói o header com informações básicas do usuário
  Widget _buildUserHeader() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 230, // Altura mínima para igualar ao card de informações
      ),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar do usuário
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MetamorfoseColors.purpleLight.withOpacity(0.1),
              border: Border.all(
                color: MetamorfoseColors.purpleLight,
                width: 2,
              ),
            ),
            child: _buildUserAvatar(),
          ),

          const SizedBox(height: 16),

          // Nome completo do usuário
          Text(
            _userModel?.completeName ?? 'Nome não informado',
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Username do usuário
          Text(
            _userModel?.name ?? 'Username não informado',
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Email do usuário
          Text(
            _userModel?.email ?? 'Email não informado',
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Constrói o avatar do usuário
  Widget _buildUserAvatar() {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Prioriza a foto do Firebase Auth primeiro, depois Firestore
    final photoUrl = currentUser?.photoURL ?? _userModel?.photoUrl;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          photoUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      );
    }

    return _buildDefaultAvatar();
  }

  /// Constrói o avatar padrão
  Widget _buildDefaultAvatar() {
    return const Icon(
      Icons.person,
      size: 40,
      color: MetamorfoseColors.purpleLight,
    );
  }

  /// Constrói as informações detalhadas do usuário
  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: MetamorfoseColors.purpleLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Informações Pessoais',
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Data de nascimento e idade na mesma linha
          _buildInfoRow(
            icon: Icons.cake,
            label: 'Data de Nascimento',
            value: _userModel?.birthDate != null
                ? '${_formatDate(_userModel?.birthDate)} (${_calculateAge(_userModel?.birthDate)?.toString() ?? 'Idade não calculada'} anos)'
                : 'Não informado',
          ),

          const SizedBox(height: 16),

          // Telefone
          _buildInfoRow(
            icon: Icons.phone,
            label: 'Telefone',
            value: _userModel?.phoneNumber ?? 'Não informado',
          ),

          const SizedBox(height: 16),

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 43,
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Icon(
              icon,
              color: MetamorfoseColors.purpleLight,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: MetamorfoseColors.greyMedium,
                ),
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: MetamorfoseColors.purpleLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Minha Metamorfose',
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Imagem da fase atual
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MetamorfoseColors.purpleLight.withOpacity(0.1),
                border: Border.all(
                  color: MetamorfoseColors.purpleLight,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: _getPhaseImage(currentPhase),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Título da fase
          Center(
            child: Text(
              _getPhaseTitle(currentPhase),
              style: const TextStyle(
                fontFamily: 'DinNext',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MetamorfoseColors.purpleNormal,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 8),

          // Descrição da fase
          Center(
            child: Text(
              _getPhaseDescription(currentPhase),
              style: const TextStyle(
                fontFamily: 'DinNext',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: MetamorfoseColors.greyMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // Barra de progresso
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progresso',
                    style: const TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MetamorfoseColors.greyMedium,
                    ),
                  ),
                  Text(
                    '$userProgress%',
                    style: const TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MetamorfoseColors.purpleNormal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
  Widget _getPhaseImage(MetamorphosisPhase phase) {
    switch (phase) {
      case MetamorphosisPhase.egg:
        return Image.asset(
          'assets/images/onboarding/ic_egg.png',
          fit: BoxFit.contain,
        );
      case MetamorphosisPhase.caterpillar:
        return Image.asset(
          'assets/images/onboarding/ic_caterpillar.png',
          fit: BoxFit.contain,
        );
      case MetamorphosisPhase.chrysalis:
        return Image.asset(
          'assets/images/onboarding/ic_chrysalis.png',
          fit: BoxFit.contain,
        );
      case MetamorphosisPhase.butterfly:
        return SvgPicture.asset(
          'assets/images/onboarding/ic_butterfly.svg',
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

  /// Retorna o progresso da fase (0-100)
  int _getPhaseProgress(MetamorphosisPhase phase) {
    switch (phase) {
      case MetamorphosisPhase.egg:
        return 15;
      case MetamorphosisPhase.caterpillar:
        return 45;
      case MetamorphosisPhase.chrysalis:
        return 75;
      case MetamorphosisPhase.butterfly:
        return 100;
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

        const SizedBox(height: 16),

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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: MetamorfoseColors.redNormal,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Erro desconhecido',
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 16,
              color: MetamorfoseColors.redNormal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
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
    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      appBar: AppBar(
        backgroundColor: MetamorfoseColors.whiteLight,
        elevation: 0,
        title: const Text(
          'Meu Perfil',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: 20,
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
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header com informações básicas
                        _buildUserHeader(),

                        const SizedBox(height: 20),

                        // Informações detalhadas
                        _buildUserInfo(),

                        const SizedBox(height: 20),

                        // Card de progresso da metamorfose
                        _buildMetamorphosisProgress(),

                        const SizedBox(height: 24),

                        // Botões de ação
                        _buildActionButtons(),

                        const SizedBox(height: 24),
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
