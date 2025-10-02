/// File: change_password_screen.dart
/// Description: Tela para alteração de senha do usuário
///
/// Responsabilidades:
/// - Permitir alteração da senha atual
/// - Validar senha atual antes da alteração
/// - Validar nova senha e confirmação
/// - Atualizar senha no Firebase Auth
/// - Exibir feedback de sucesso ou erro
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 06-08-2025
/// Last modified: 06-08-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/custom_button.dart';
import 'package:metamorfose_flutter/components/password_input_field.dart';
import 'package:metamorfose_flutter/components/secondary_button.dart';
import 'package:metamorfose_flutter/routes/routes.dart';

/// Tela para alteração de senha do usuário
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _isChanging = false;
  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Valida a senha atual
  void _validateCurrentPassword() {
    final value = _currentPasswordController.text;
    setState(() {
      if (value.isEmpty) {
        _currentPasswordError = 'Senha atual é obrigatória';
      } else {
        _currentPasswordError = null;
      }
    });
  }

  /// Valida a nova senha
  void _validateNewPassword() {
    final value = _newPasswordController.text;
    setState(() {
      if (value.isEmpty) {
        _newPasswordError = 'Nova senha é obrigatória';
      } else if (value.length < 6) {
        _newPasswordError = 'Senha deve ter pelo menos 6 caracteres';
      } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(value)) {
        _newPasswordError = 'Senha deve conter letras e números';
      } else if (value == _currentPasswordController.text) {
        _newPasswordError = 'Nova senha deve ser diferente da atual';
      } else {
        _newPasswordError = null;
      }
    });
  }

  /// Valida a confirmação da senha
  void _validateConfirmPassword() {
    final value = _confirmPasswordController.text;
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = 'Confirmação de senha é obrigatória';
      } else if (value != _newPasswordController.text) {
        _confirmPasswordError = 'Senhas não coincidem';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  /// Reautentica o usuário com a senha atual
  Future<bool> _reauthenticateUser(String currentPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        throw Exception('Usuário não encontrado');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Altera a senha do usuário
  Future<void> _changePassword() async {
    _validateCurrentPassword();
    _validateNewPassword();
    _validateConfirmPassword();

    if (_currentPasswordError != null ||
        _newPasswordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() => _isChanging = true);

    try {
      final isReauthenticated = await _reauthenticateUser(
        _currentPasswordController.text,
      );

      if (!isReauthenticated) {
        _showErrorSnackBar('Senha atual incorreta');
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(_newPasswordController.text);

        if (mounted) {
          _showSuccessSnackBar('Senha alterada com sucesso!');

          await Future.delayed(const Duration(seconds: 2));

          if (mounted) {
            context.go(Routes.userProfile);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'A senha é muito fraca';
          break;
        case 'wrong-password':
          errorMessage = 'Senha atual incorreta';
          break;
        case 'too-many-requests':
          errorMessage = 'Muitas tentativas. Tente novamente mais tarde';
          break;
        case 'network-request-failed':
          errorMessage = 'Erro de conexão. Verifique sua internet';
          break;
        default:
          errorMessage = 'Erro ao alterar senha: ${e.message}';
      }

      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar('Erro inesperado: $e');
    } finally {
      setState(() => _isChanging = false);
    }
  }

  /// Exibe snackbar de sucesso
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: MetamorfoseColors.greenNormal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Exibe snackbar de erro
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: MetamorfoseColors.redNormal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Constrói um campo de senha
  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? errorText,
  }) {
    final labelFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
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

    final spacingSmall = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
            color: MetamorfoseColors.greyMedium,
          ),
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: spacingSmall),
        PasswordInputField(
          hintText: hint,
          controller: controller,
          initiallyVisible: isVisible,
          onVisibilityChanged: (visible) => onToggleVisibility(),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: MetamorfoseColors.purpleLight,
            size: iconSize,
          ),
          errorText: errorText,
        ),
      ],
    );
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


    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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

    final containerPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final spacingSmall = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final spacingMedium = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final spacingLarge = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final spacingXLarge = ResponsiveValue<double>(
      context,
      defaultValue: 32.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 40.0),
      ],
    ).value;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      appBar: AppBar(
        backgroundColor: MetamorfoseColors.whiteLight,
        elevation: 0,
        title: Text(
          'Trocar Senha',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MetamorfoseColors.greyMedium,
            size: iconSize,
          ),
          onPressed: () => context.go(Routes.userProfile),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(containerPadding),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.blueLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: MetamorfoseColors.blueLight.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: MetamorfoseColors.blueNormal,
                            size: iconSize,
                          ),
                          SizedBox(width: spacingSmall),
                          Expanded(
                            child: Text(
                              'Segurança da Conta',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: titleFontSize * 0.8,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.greyMedium,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacingSmall),
                      Text(
                        'Para sua segurança, você precisa informar sua senha atual antes de definir uma nova senha.',
                        style: TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: titleFontSize * 0.7,
                          color: MetamorfoseColors.greyMedium,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: spacingLarge),

                _buildPasswordField(
                  label: 'Senha Atual *',
                  hint: 'Digite sua senha atual',
                  controller: _currentPasswordController,
                  isVisible: _isCurrentPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                    });
                  },
                  errorText: _currentPasswordError,
                ),

                SizedBox(height: spacingMedium),

                _buildPasswordField(
                  label: 'Nova Senha *',
                  hint: 'Digite sua nova senha',
                  controller: _newPasswordController,
                  isVisible: _isNewPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                  errorText: _newPasswordError,
                ),

                SizedBox(height: spacingMedium),

                _buildPasswordField(
                  label: 'Confirmar Nova Senha *',
                  hint: 'Digite novamente sua nova senha',
                  controller: _confirmPasswordController,
                  isVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  errorText: _confirmPasswordError,
                ),

                SizedBox(height: spacingLarge),

                Container(
                  padding: EdgeInsets.all(containerPadding),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.greenLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: MetamorfoseColors.greenLight.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tips_and_updates,
                            color: MetamorfoseColors.greenNormal,
                            size: iconSize,
                          ),
                          SizedBox(width: spacingSmall),
                          Text(
                            'Dicas para uma senha segura:',
                            style: TextStyle(
                              fontFamily: 'DinNext',
                              fontSize: titleFontSize * 0.7,
                              fontWeight: FontWeight.bold,
                              color: MetamorfoseColors.greyMedium,
                            ),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: spacingSmall),
                      Text(
                        '• Pelo menos 6 caracteres\n• Combine letras e números\n• Evite informações pessoais\n• Use uma senha única',
                        style: TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: titleFontSize * 0.6,
                          color: MetamorfoseColors.greyMedium,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: spacingXLarge),

                Row(
                  children: [
                    Expanded(
                      child: MetamorfeseSecondaryButton(
                        text: 'CANCELAR',
                        onPressed: () => context.go(Routes.userProfile),
                      ),
                    ),

                    SizedBox(width: spacingSmall * 2),

                    Expanded(
                      child: CustomButton(
                        text: _isChanging ? 'ALTERANDO...' : 'ALTERAR SENHA',
                        onPressed: _isChanging ? () {} : _changePassword,
                        backgroundColor: MetamorfoseColors.blueNormal,
                        textColor: MetamorfoseColors.whiteLight,
                        shadowColor: MetamorfoseColors.blueDark,
                        strokeColor: MetamorfoseColors.blueNormal,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: spacingLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
