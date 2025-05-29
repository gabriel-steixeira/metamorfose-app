/**
 * File: auth_screen.dart
 * Description: Tela de autenticação do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Exibir interface de login e cadastro
 * - Gerenciar entrada de dados do usuário
 * - Integrar com autenticação social
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/index.dart';

/// Tela de autenticação com opções de login e cadastro
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _rememberMe = false;
  int _selectedTabIndex = 0; // 0 = Entrar, 1 = Cadastrar
  bool _isPasswordVisible = false; // Controla a imagem dos olhos do personagem

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildCustomTabBar() {
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
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: _selectedTabIndex == 0
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
                      color: _selectedTabIndex == 0 
                          ? MetamorfoseColors.greyMedium 
                          : MetamorfoseColors.greyLight,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: _selectedTabIndex == 0 
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
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: _selectedTabIndex == 1
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
                      color: _selectedTabIndex == 1 
                          ? MetamorfoseColors.greyMedium 
                          : MetamorfoseColors.greyLight,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: _selectedTabIndex == 1 
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
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          
          // Campo de email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: MetamorfeseInput(
              hintText: 'E-mail, telefone ou nome de usuário',
              controller: _emailController,
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
              onVisibilityChanged: (isVisible) {
                setState(() {
                  _isPasswordVisible = isVisible;
                });
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
                    setState(() {
                      _rememberMe = !_rememberMe;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _rememberMe 
                              ? MetamorfoseColors.purpleLight 
                              : MetamorfoseColors.transparent,
                          border: Border.all(
                            color: _rememberMe 
                                ? MetamorfoseColors.purpleLight 
                                : MetamorfoseColors.whiteDark,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _rememberMe
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
              text: 'ENTRAR',
              onPressed: () {
                // Implementar ação de login
              },
            ),
          ),
          
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
                    onPressed: () {
                      // Implementar login com Google
                    },
                    textColor: MetamorfoseColors.blueNormal,
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: MetamorfoseSocialButton(
                    text: 'FACEBOOK',
                    iconPath: 'assets/images/auth/ic_facebook_logo.svg',
                    onPressed: () {
                      // Implementar login com Facebook
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
                  fontSize: 18,
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
  }

  Widget _buildRegisterForm() {
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
              keyboardType: TextInputType.phone,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
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
              keyboardType: TextInputType.emailAddress,
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
              onVisibilityChanged: (isVisible) {
                setState(() {
                  _isPasswordVisible = isVisible;
                });
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
              text: 'CRIAR CONTA',
              onPressed: () {
                // Implementar ação de cadastro
              },
            ),
          ),
          
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
                    onPressed: () {
                      // Implementar cadastro com Google
                    },
                    textColor: MetamorfoseColors.blueNormal,
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: MetamorfoseSocialButton(
                    text: 'FACEBOOK',
                    iconPath: 'assets/images/auth/ic_facebook_logo.svg',
                    onPressed: () {
                      // Implementar cadastro com Facebook
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
                  fontSize: 18,
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
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    
    return Scaffold(
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              
              // Personagem robô
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -50, // 5% da imagem ficará atrás da parte branca
                      left: _isPasswordVisible 
                              ? screenWidth * 0.2375
                              : screenWidth * 0.175, // 15% de margem esquerda
                      right: _isPasswordVisible 
                              ? screenWidth * 0.2375
                              : screenWidth * 0.175, // 15% de margem direita
                      child: Image.asset(
                        _isPasswordVisible 
                            ? 'assets/images/auth/ivy_eyes_closed.png'
                            : 'assets/images/auth/ivy_eyes_open.png',
                        width: 
                          _isPasswordVisible 
                              ? screenWidth * 0.525
                              : screenWidth * 0.65, // 70% da largura da tela
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
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
                        child: _selectedTabIndex == 0 
                            ? _buildLoginForm() 
                            : _buildRegisterForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 