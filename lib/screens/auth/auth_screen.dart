/**
 * File: auth_screen.dart
 * Description: Tela de autenticação do aplicativo Metamorfose com BLoC.
 *
 * Responsabilidades:
 * - Exibir interface de login e cadastro usando BLoC
 * - Gerenciar entrada de dados do usuário via BLoC
 * - Integrar com autenticação social
 * - Preservar design original exatamente
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/index.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/blocs/auth_bloc.dart';
import 'package:metamorfose_flutter/state/auth/auth_state.dart';
import 'package:metamorfose_flutter/state/auth/auth_events.dart';

/// Tela de autenticação com opções de login e cadastro usando BLoC
class AuthScreen extends StatefulWidget {
  final String? initialMode;
  
  const AuthScreen({super.key, this.initialMode});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Adicionar listeners para validação em tempo real
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _usernameController.addListener(_onUsernameChanged);
    _phoneController.addListener(_onPhoneChanged);
    
    // Inicializar BLoC
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Determinar modo inicial baseado no parâmetro
        final mode = widget.initialMode == 'register' 
            ? AuthScreenMode.register 
            : AuthScreenMode.login;
        context.read<AuthBloc>().add(AuthToggleModeEvent(mode));
      }
    });
  }

  void _onEmailChanged() {
    if (mounted) {
      final currentState = context.read<AuthBloc>().state;
      if (currentState.mode == AuthScreenMode.login) {
        context.read<AuthBloc>().add(AuthUpdateLoginFieldEvent(
          email: _emailController.text,
        ));
      } else {
        context.read<AuthBloc>().add(AuthUpdateRegisterFieldEvent(
          email: _emailController.text,
        ));
      }
    }
  }

  void _onPasswordChanged() {
    if (mounted) {
      final currentState = context.read<AuthBloc>().state;
      if (currentState.mode == AuthScreenMode.login) {
        context.read<AuthBloc>().add(AuthUpdateLoginFieldEvent(
          password: _passwordController.text,
        ));
      } else {
        context.read<AuthBloc>().add(AuthUpdateRegisterFieldEvent(
          password: _passwordController.text,
        ));
      }
    }
  }

  void _onUsernameChanged() {
    if (mounted) {
      final currentState = context.read<AuthBloc>().state;
      if (currentState.mode == AuthScreenMode.register) {
        context.read<AuthBloc>().add(AuthUpdateRegisterFieldEvent(
          username: _usernameController.text,
        ));
      }
    }
  }

  void _onPhoneChanged() {
    if (mounted) {
      final currentState = context.read<AuthBloc>().state;
      if (currentState.mode == AuthScreenMode.register) {
        // Formatar telefone automaticamente
        final formattedPhone = _formatPhoneNumber(_phoneController.text);
        if (formattedPhone != _phoneController.text) {
          _phoneController.value = _phoneController.value.copyWith(
            text: formattedPhone,
            selection: TextSelection.collapsed(offset: formattedPhone.length),
          );
        }
        
        context.read<AuthBloc>().add(AuthUpdateRegisterFieldEvent(
          phone: _phoneController.text,
        ));
      }
    }
  }

  String _formatPhoneNumber(String phone) {
    // Remove todos os caracteres não numéricos
    String numbers = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limita a 11 dígitos (DDD + 9 dígitos)
    if (numbers.length > 11) {
      numbers = numbers.substring(0, 11);
    }
    
    // Aplica formatação baseada no comprimento
    if (numbers.length <= 2) {
      return numbers;
    } else if (numbers.length <= 7) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2)}';
    } else if (numbers.length <= 11) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    }
    
    return numbers;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildCustomTabBar() {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous.mode != current.mode,
      builder: (context, state) {
    return Container(
      width: double.infinity,
      height: 43,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: MetamorfoseColors.greyLightest2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                    context.read<AuthBloc>().add(const AuthToggleModeEvent(AuthScreenMode.login));
              },
              child: Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: state.mode == AuthScreenMode.login
                    ? ShapeDecoration(
                        color: MetamorfoseColors.whiteLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: MetamorfoseColors.shadowLight,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      )
                    : null,
                child: Center(
                  child: Text(
                    'Entrar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                          color: state.mode == AuthScreenMode.login 
                          ? MetamorfoseColors.greyMedium 
                          : MetamorfoseColors.greyLight,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                          fontWeight: state.mode == AuthScreenMode.login 
                          ? FontWeight.w700 
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: () {
                    context.read<AuthBloc>().add(const AuthToggleModeEvent(AuthScreenMode.register));
              },
              child: Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: state.mode == AuthScreenMode.register
                    ? ShapeDecoration(
                        color: MetamorfoseColors.whiteLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: MetamorfoseColors.shadowLight,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      )
                    : null,
                child: Center(
                  child: Text(
                    'Cadastrar-se',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                          color: state.mode == AuthScreenMode.register 
                          ? MetamorfoseColors.greyMedium 
                          : MetamorfoseColors.greyLight,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                          fontWeight: state.mode == AuthScreenMode.register 
                          ? FontWeight.w700 
                          : FontWeight.w400,
                      height: 1.40,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          
          // Campo de email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: MetamorfeseInput(
              hintText: 'Digite seu e-mail',
              controller: _emailController,
              errorText: state.loginState.emailError.isNotEmpty
                  ? state.loginState.emailError
                  : null,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/images/auth/ic_email.svg',
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    MetamorfoseColors.purpleNormal,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Campo de senha
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: MetamorfesePasswordInput(
              hintText: 'Senha',
              controller: _passwordController,
              errorText: state.loginState.passwordError.isNotEmpty
                  ? state.loginState.passwordError
                  : null,
              onVisibilityChanged: (isVisible) {
                     context.read<AuthBloc>().add(AuthToggleEyesEvent(!isVisible));
              },
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/images/auth/ic_lock.svg',
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    MetamorfoseColors.purpleNormal,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lembrar-me e Esqueceu a senha
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                        context.read<AuthBloc>().add(AuthUpdateLoginFieldEvent(
                          rememberMe: !state.loginState.rememberMe,
                        ));
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                              color: state.loginState.rememberMe 
                              ? MetamorfoseColors.purpleLight 
                              : MetamorfoseColors.transparent,
                          border: Border.all(
                                color: state.loginState.rememberMe 
                                ? MetamorfoseColors.purpleLight 
                                : MetamorfoseColors.whiteDark,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                            child: state.loginState.rememberMe
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: MetamorfoseColors.whiteLight,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Lembrar-me',
                        style: TextStyle(
                          color: MetamorfoseColors.greyLight,
                          fontSize: 14,
                          fontFamily: 'DIN Next for Duolingo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Implementar ação de esqueceu a senha
                  },
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      color: MetamorfoseColors.purpleLight,
                      fontSize: 14,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Botão Entrar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: MetamorfeseButton(
                  text: state.loginState.isLoading ? 'ENTRANDO...' : 'ENTRAR',
                  onPressed: state.loginState.isLoading 
                      ? () {} 
                      : () {
                          context.read<AuthBloc>().add(AuthSubmitLoginEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                            rememberMe: state.loginState.rememberMe,
                          ));
                        },
                ),
              ),
              
              // Botão de Login Rápido (para desenvolvimento)
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MetamorfeseSecondaryButton(
                  text: 'LOGIN RÁPIDO (DEV)',
                  onPressed: state.loginState.isLoading 
                      ? () {} 
                      : () {
                          context.read<AuthBloc>().add(AuthQuickLoginEvent());
                        },
                ),
              ),
              
              // Exibir erro se houver
              if (state.loginState.errorMessage != null) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.redLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: MetamorfoseColors.redNormal),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: MetamorfoseColors.redNormal,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.loginState.errorMessage!,
                            style: const TextStyle(
                              color: MetamorfoseColors.redNormal,
                              fontSize: 14,
                              fontFamily: 'DIN Next for Duolingo',
                            ),
            ),
          ),
                      ],
                    ),
                  ),
                ),
              ],
          
          const SizedBox(height: 24),
          
          // Divisor OU
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: MetamorfoseColors.whiteDark,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OU',
                    style: TextStyle(
                      color: MetamorfoseColors.greyLight,
                      fontSize: 14,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: MetamorfoseColors.whiteDark,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botões de login social
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: MetamorfoseSocialButton(
                    text: 'GOOGLE',
                    iconPath: 'assets/images/auth/ic_google_logo.svg',
                    onPressed: state.loginState.isLoading
                        ? () {}
                        : () {
                            context.read<AuthBloc>().add(AuthSignInWithGoogleEvent());
                          },
                    textColor: MetamorfoseColors.blueNormal,
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: MetamorfoseSocialButton(
                    text: 'FACEBOOK',
                    iconPath: 'assets/images/auth/ic_facebook_logo.svg',
                    onPressed: state.loginState.isLoading
                        ? () {}
                        : () {
                            context.read<AuthBloc>().add(AuthSignInWithFacebookEvent());
                          },
                    textColor: MetamorfoseColors.blueDark,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Termos e Política de Privacidade
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: MetamorfoseColors.greyLight,
                  fontSize: 14,
                  fontFamily: 'DIN Next for Duolingo',
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(text: 'Ao entrar no Metamorfose, você concorda com os nossos '),
                  TextSpan(
                    text: 'Termos',
                    style: TextStyle(
                      color: MetamorfoseColors.purpleLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: ' e '),
                  TextSpan(
                    text: 'Política de Privacidade',
                    style: TextStyle(
                      color: MetamorfoseColors.purpleLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
        );
      },
    );
  }

  Widget _buildRegisterForm() {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          previous.registerState != current.registerState,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              // Campo de username
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MetamorfeseInput(
                  hintText: 'Username',
                  controller: _usernameController,
                  errorText: state.registerState.usernameError.isNotEmpty
                      ? state.registerState.usernameError
                      : null,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/images/auth/ic_user.svg',
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        MetamorfoseColors.purpleNormal,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo de telefone
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MetamorfeseInput(
                  hintText: 'Telefone',
                  controller: _phoneController,
                  errorText: state.registerState.phoneError.isNotEmpty
                      ? state.registerState.phoneError
                      : null,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.phone_outlined,
                      size: 22,
                      color: MetamorfoseColors.purpleNormal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo de email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MetamorfeseInput(
                  hintText: 'E-mail',
                  controller: _emailController,
                  errorText: state.registerState.emailError.isNotEmpty
                      ? state.registerState.emailError
                      : null,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/images/auth/ic_email.svg',
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        MetamorfoseColors.purpleNormal,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo de senha
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MetamorfesePasswordInput(
                  hintText: 'Senha',
                  controller: _passwordController,
                  errorText: state.registerState.passwordError.isNotEmpty
                      ? state.registerState.passwordError
                      : null,
                  onVisibilityChanged: (isVisible) {
                    context.read<AuthBloc>().add(AuthToggleEyesEvent(!isVisible));
                  },
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/images/auth/ic_lock.svg',
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        MetamorfoseColors.purpleNormal,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Botão Criar Conta
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MetamorfeseButton(
                  text: state.registerState.isLoading
                      ? 'CRIANDO CONTA...'
                      : 'CRIAR CONTA',
                  onPressed: state.registerState.isLoading
                      ? () {}
                      : () {
                          context.read<AuthBloc>().add(AuthSubmitRegisterEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                                username: _usernameController.text,
                                phone: _phoneController.text,
                              ));
                        },
                ),
              ),

              if (state.registerState.errorMessage != null) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.redLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: MetamorfoseColors.redNormal),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: MetamorfoseColors.redNormal,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.registerState.errorMessage!,
                            style: const TextStyle(
                              color: MetamorfoseColors.redNormal,
                              fontSize: 14,
                              fontFamily: 'DIN Next for Duolingo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              // Divisor OU
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: MetamorfoseColors.whiteDark,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OU',
                        style: TextStyle(
                          color: MetamorfoseColors.greyLight,
                          fontSize: 14,
                          fontFamily: 'DIN Next for Duolingo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: MetamorfoseColors.whiteDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Botões de login social
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: MetamorfoseSocialButton(
                        text: 'GOOGLE',
                        iconPath: 'assets/images/auth/ic_google_logo.svg',
                        onPressed: state.registerState.isLoading
                            ? () {}
                            : () {
                                context.read<AuthBloc>().add(AuthSignInWithGoogleEvent());
                              },
                        textColor: MetamorfoseColors.blueNormal,
                      ),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: MetamorfoseSocialButton(
                        text: 'FACEBOOK',
                        iconPath: 'assets/images/auth/ic_facebook_logo.svg',
                        onPressed: state.registerState.isLoading
                            ? () {}
                            : () {
                                context.read<AuthBloc>().add(AuthSignInWithFacebookEvent());
                              },
                        textColor: MetamorfoseColors.blueDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Termos e Política de Privacidade
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      color: MetamorfoseColors.greyLight,
                      fontSize: 14,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                          text:
                              'Ao entrar no Metamorfose, você concorda com os nossos '),
                      TextSpan(
                        text: 'Termos',
                        style: TextStyle(
                          color: MetamorfoseColors.purpleLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(text: ' e '),
                      TextSpan(
                        text: 'Política de Privacidade',
                        style: TextStyle(
                          color: MetamorfoseColors.purpleLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Navegar para home quando login ou registro for bem-sucedido
        if (state.user != null) {
          context.go(Routes.plantConfig);
        }
      },
      child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: MetamorfoseGradients.lightPurpleGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header com botão voltar
              Container(
                width: double.infinity,
                height: 56,
                child: Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/arrow_back.svg',
                        width: 34,
                        height: 34,
                      ),
                         onPressed: () => context.go(Routes.onboarding),
                    ),
                  ],
                ),
              ),
              
                // Personagem robô (reativo ao estado dos olhos)
              Expanded(
                flex: 2,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) => previous.eyesOpen != current.eyesOpen,
                    builder: (context, state) {
                      return Stack(
                  children: [
                    Positioned(
                      bottom: -50, // 5% da imagem ficará atrás da parte branca
                            left: state.eyesOpen 
                                    ? screenWidth * 0.175
                                    : screenWidth * 0.2375, // 15% de margem esquerda
                            right: state.eyesOpen 
                                    ? screenWidth * 0.175
                                    : screenWidth * 0.2375, // 15% de margem direita
                      child: Image.asset(
                              state.eyesOpen 
                                  ? 'assets/images/auth/ivy_eyes_open.png'
                                  : 'assets/images/auth/ivy_eyes_closed.png',
                        width: 
                                state.eyesOpen 
                                    ? screenWidth * 0.65
                                    : screenWidth * 0.525, // 70% da largura da tela
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                      );
                    },
                ),
              ),
              
              // Container branco com formulário
              Expanded(
                flex: isSmallScreen ? 4 : 5,
                child: Container(
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                    color: MetamorfoseColors.whiteLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      
                      // Custom Tab Bar
                      _buildCustomTabBar(),
                      
                      // Formulário
                      Expanded(
                          child: BlocBuilder<AuthBloc, AuthState>(
                            buildWhen: (previous, current) => previous.mode != current.mode,
                            builder: (context, state) {
                              return state.mode == AuthScreenMode.login 
                            ? _buildLoginForm() 
                                  : _buildRegisterForm();
                            },
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}