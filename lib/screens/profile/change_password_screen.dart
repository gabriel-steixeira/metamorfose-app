/**
 * File: change_password_screen.dart
 * Description: Tela para alteração de senha do usuário
 *
 * Responsabilidades:
 * - Permitir alteração da senha atual
 * - Validar senha atual antes da alteração
 * - Validar nova senha e confirmação
 * - Atualizar senha no Firebase Auth
 * - Exibir feedback de sucesso ou erro
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 06-08-2025
 * Last modified: 06-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/custom_button.dart';
import 'package:metamorfose_flutter/components/metamorfose_password_input.dart';
import 'package:metamorfose_flutter/components/metamorfose_secondary_button.dart';
import 'package:metamorfose_flutter/routes/routes.dart';

/// Tela para alteração de senha do usuário
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores dos campos
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  // Estados de visibilidade das senhas
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
    // Validar todos os campos
    _validateCurrentPassword();
    _validateNewPassword();
    _validateConfirmPassword();
    
    // Verificar se há erros
    if (_currentPasswordError != null || _newPasswordError != null || _confirmPasswordError != null) {
      return;
    }

    setState(() => _isChanging = true);

    try {
      // Primeiro, reautentica o usuário
      final isReauthenticated = await _reauthenticateUser(
        _currentPasswordController.text,
      );

      if (!isReauthenticated) {
        _showErrorSnackBar('Senha atual incorreta');
        return;
      }

      // Se a reautenticação foi bem-sucedida, altera a senha
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(_newPasswordController.text);
        
        if (mounted) {
          _showSuccessSnackBar('Senha alterada com sucesso!');
          
          // Aguarda um pouco para mostrar a mensagem e depois volta
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DinNext',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
        const SizedBox(height: 8),
        MetamorfesePasswordInput(
          hintText: hint,
          controller: controller,
          initiallyVisible: isVisible,
          onVisibilityChanged: (visible) => onToggleVisibility(),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.lock_outline,
              color: MetamorfoseColors.purpleNormal,
              size: 22,
            ),
          ),
          errorText: errorText,
        ),
      ],
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
          'Trocar Senha',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: MetamorfoseColors.greyMedium,
          ),
          onPressed: () => context.go(Routes.userProfile),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informações de segurança
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.blueLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
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
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Segurança da Conta',
                              style: const TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.greyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Para sua segurança, você precisa informar sua senha atual antes de definir uma nova senha.',
                        style: const TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 14,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Campo Senha Atual
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
                
                const SizedBox(height: 20),
                
                // Campo Nova Senha
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
                
                const SizedBox(height: 20),
                
                // Campo Confirmar Nova Senha
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
                
                const SizedBox(height: 24),
                
                // Dicas de senha
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.greenLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
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
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Dicas para uma senha segura:',
                            style: const TextStyle(
                              fontFamily: 'DinNext',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: MetamorfoseColors.greyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Pelo menos 6 caracteres\n• Combine letras e números\n• Evite informações pessoais\n• Use uma senha única',
                        style: const TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 12,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Botões
                Row(
                  children: [
                    // Botão Cancelar
                    Expanded(
                      child: MetamorfeseSecondaryButton(
                        text: 'CANCELAR',
                        onPressed: () => context.go(Routes.userProfile),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Botão Alterar Senha
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
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}