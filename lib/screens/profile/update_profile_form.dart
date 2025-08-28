/**
 * File: update_profile_form.dart
 * Description: Formulário para atualização dos dados do usuário
 *
 * Responsabilidades:
 * - Permitir edição dos dados pessoais do usuário
 * - Validar campos obrigatórios
 * - Salvar alterações no Firebase
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/custom_button.dart';
import 'package:metamorfose_flutter/components/metamorfose_input.dart';
import 'package:metamorfose_flutter/components/metamorfose_secondary_button.dart';
import 'package:metamorfose_flutter/services/auth_service.dart';
import 'package:metamorfose_flutter/models/user_model.dart';
import 'package:metamorfose_flutter/utils/auth_validators.dart';
import 'package:metamorfose_flutter/routes/routes.dart';

/// Formulário para atualização dos dados do perfil do usuário
class UpdateProfileForm extends StatefulWidget {
  const UpdateProfileForm({super.key});

  @override
  State<UpdateProfileForm> createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  
  // Controladores dos campos
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _completeNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  
  UserModel? _userModel;
  bool _isLoading = true;
  bool _isSaving = false;
  DateTime? _selectedBirthDate;
  String? _usernameError;
  String? _completeNameError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _completeNameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  /// Carrega os dados atuais do usuário
  Future<void> _loadUserData() async {
    try {
      setState(() => _isLoading = true);
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        
        // Buscar dados adicionais do Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        final userDocData = userDoc.data();
        
        setState(() {
          _userModel = userData;
          _usernameController.text = userData.name ?? '';
          _completeNameController.text = userDocData?['completeName'] ?? '';
          
          // Aplicar máscara no telefone
          final phone = userData.phoneNumber ?? '';
          _phoneController.text = phone.isNotEmpty ? _formatPhone(phone) : '';
          
          // Carregar data de nascimento do Firestore
          if (userDocData?['birthDate'] != null) {
            final birthDateTimestamp = userDocData!['birthDate'] as Timestamp;
            _selectedBirthDate = birthDateTimestamp.toDate();
            _birthDateController.text = _formatDate(_selectedBirthDate!);
          }
          
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Erro ao carregar dados: $e');
    }
  }

  /// Valida o nome de usuário
  void _validateUsername() {
    final value = _usernameController.text;
    setState(() {
      _usernameError = AuthValidators.validateUsername(value);
    });
  }

  /// Valida o nome completo
  void _validateCompleteName() {
    final value = _completeNameController.text;
    setState(() {
      if (value.trim().isEmpty) {
        _completeNameError = 'Nome completo é obrigatório';
      } else if (value.trim().length < 2) {
        _completeNameError = 'Nome completo deve ter pelo menos 2 caracteres';
      } else {
        _completeNameError = null;
      }
    });
  }

  /// Valida o telefone
  void _validatePhone() {
    final value = _phoneController.text;
    setState(() {
      if (value.isEmpty) {
        _phoneError = 'Telefone é obrigatório';
      } else {
        // Remove formatação para validar
        final cleanPhone = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (cleanPhone.length != 11) {
          _phoneError = 'Telefone deve ter 11 dígitos';
        } else {
          _phoneError = null;
        }
      }
    });
  }

  /// Formata o telefone durante a digitação
  String _formatPhone(String value) {
    final cleanPhone = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanPhone.length <= 2) {
      return cleanPhone;
    } else if (cleanPhone.length <= 7) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2)}';
    } else if (cleanPhone.length <= 10) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 6)}-${cleanPhone.substring(6)}';
    } else {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 7)}-${cleanPhone.substring(7, 11)}';
    }
  }

  /// Seleciona data de nascimento
  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: MetamorfoseColors.purpleNormal,
              onPrimary: MetamorfoseColors.whiteLight,
              surface: MetamorfoseColors.whiteLight,
              onSurface: MetamorfoseColors.greyMedium,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = _formatDate(picked);
      });
    }
  }

  /// Formata a data para exibição
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Salva as alterações
  Future<void> _saveProfile() async {
    // Validar campos
    _validateUsername();
    _validateCompleteName();
    _validatePhone();
    
    // Verificar se há erros
    if (_usernameError != null || _completeNameError != null || _phoneError != null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não encontrado');
      }

      // Atualiza o nome de usuário no Firebase Auth
      await user.updateDisplayName(_usernameController.text.trim());

      // Atualiza os dados no Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': _usernameController.text.trim(), // Nome de usuário
        'completeName': _completeNameController.text.trim(), // Nome completo
        'phoneNumber': _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        'updatedAt': Timestamp.now(),
        if (_selectedBirthDate != null) 'birthDate': Timestamp.fromDate(_selectedBirthDate!),
      });

      if (mounted) {
        _showSuccessSnackBar('Dados atualizados com sucesso!');
        context.go(Routes.userProfile); // Volta para a tela de perfil
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao salvar: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  /// Exibe snackbar de sucesso
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: MetamorfoseColors.greenNormal,
        behavior: SnackBarBehavior.floating,
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
          'Atualizar Cadastro',
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
          onPressed: () {
            context.go(Routes.userProfile);
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: MetamorfoseColors.purpleNormal,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Informações atuais
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: MetamorfoseColors.purpleLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: MetamorfoseColors.purpleLight.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: MetamorfoseColors.purpleNormal,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Atualize suas informações pessoais abaixo',
                                style: const TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: 14,
                                  color: MetamorfoseColors.greyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Campo Nome de Usuário
                      const Text(
                        'Nome de Usuário *',
                        style: TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      MetamorfeseInput(
                        hintText: 'Digite seu nome de usuário',
                        controller: _usernameController,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.alternate_email,
                            color: MetamorfoseColors.purpleNormal,
                            size: 22,
                          ),
                        ),
                        errorText: _usernameError,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Campo Nome Completo
                      const Text(
                        'Nome Completo *',
                        style: TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      MetamorfeseInput(
                        hintText: 'Digite seu nome completo',
                        controller: _completeNameController,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.person_outline,
                            color: MetamorfoseColors.purpleNormal,
                            size: 22,
                          ),
                        ),
                        errorText: _completeNameError,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Campo Telefone
                      const Text(
                        'Telefone',
                        style: TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      MetamorfeseInput(
                        hintText: '(11) 99999-9999',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          final formatted = _formatPhone(value);
                          if (formatted != value) {
                            _phoneController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                offset: formatted.length,
                              ),
                            );
                          }
                        },
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.phone_outlined,
                            color: MetamorfoseColors.purpleNormal,
                            size: 22,
                          ),
                        ),
                        errorText: _phoneError,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Campo Data de Nascimento
                      const Text(
                        'Data de Nascimento',
                        style: TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      MetamorfeseInput(
                        hintText: 'DD/MM/AAAA',
                        controller: _birthDateController,
                        readOnly: true,
                        onTap: _selectBirthDate,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.cake_outlined,
                            color: MetamorfoseColors.purpleNormal,
                            size: 22,
                          ),
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.calendar_today,
                            color: MetamorfoseColors.purpleNormal,
                            size: 20,
                          ),
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
                              onPressed: _isSaving ? () {} : () {
                                context.go(Routes.userProfile);
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // Botão Salvar
                          Expanded(
                            child: CustomButton(
                              text: _isSaving ? 'SALVANDO...' : 'SALVAR',
                              onPressed: _isSaving ? () {} : _saveProfile,
                              backgroundColor: MetamorfoseColors.purpleNormal,
                              textColor: MetamorfoseColors.whiteLight,
                              shadowColor: MetamorfoseColors.purpleDark,
                              strokeColor: MetamorfoseColors.purpleNormal,
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