/// File: auth_screen.dart
/// Description: Tela de autenticação do aplicativo Metamorfose com BLoC.
///
/// Responsabilidades:
/// - Exibir interface de login e cadastro usando BLoC
/// - Gerenciar entrada de dados do usuário via BLoC
/// - Integrar com autenticação social
/// - Preservar design original exatamente
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 29-05-2025
/// Last modified: 31-08-2025
/// 
/// Changes:
/// - UI Ajustada. (Evelin Cordeiro)
/// 
/// Version: 1.0.0
/// Squad: Metamorfose

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
import 'package:responsive_framework/responsive_framework.dart';

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
  final TextEditingController _completeNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

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

  void _showForgotPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MetamorfoseColors.whiteLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveValue<double>(
              context,
              defaultValue: 16.0,
              conditionalValues: const [
                Condition.smallerThan(name: MOBILE, value: 12.0),
                Condition.largerThan(name: TABLET, value: 20.0),
              ],
            ).value),
          ),
          title: Text(
            'Esqueceu a senha?',
            style: TextStyle(
              color: MetamorfoseColors.greyMedium,
              fontSize: ResponsiveValue<double>(
                context,
                defaultValue: 18.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 16.0),
                  Condition.largerThan(name: TABLET, value: 20.0),
                ],
              ).value,
              fontFamily: 'DIN Next for Duolingo',
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Digite seu email para receber as instruções de recuperação de senha.',
                style: TextStyle(
                  color: MetamorfoseColors.greyLight,
                  fontSize: ResponsiveValue<double>(
                    context,
                    defaultValue: 14.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 12.0),
                      Condition.largerThan(name: TABLET, value: 16.0),
                    ],
                  ).value,
                  fontFamily: 'DIN Next for Duolingo',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 16.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 12.0),
                  Condition.largerThan(name: TABLET, value: 20.0),
                ],
              ).value),
              InputField(
                hintText: 'Digite seu e-mail',
                controller: resetEmailController,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(ResponsiveValue<double>(
                    context,
                    defaultValue: 12.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 10.0),
                      Condition.largerThan(name: TABLET, value: 16.0),
                    ],
                  ).value),
                  child: SvgPicture.asset(
                    'assets/images/auth/ic_email.svg',
                    width: ResponsiveValue<double>(
                      context,
                      defaultValue: 22.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 20.0),
                        Condition.largerThan(name: TABLET, value: 24.0),
                      ],
                    ).value,
                    height: ResponsiveValue<double>(
                      context,
                      defaultValue: 22.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 20.0),
                        Condition.largerThan(name: TABLET, value: 24.0),
                      ],
                    ).value,
                    colorFilter: const ColorFilter.mode(
                      MetamorfoseColors.purpleNormal,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: MetamorfoseColors.greyLight,
                  fontSize: ResponsiveValue<double>(
                    context,
                    defaultValue: 14.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 12.0),
                      Condition.largerThan(name: TABLET, value: 16.0),
                    ],
                  ).value,
                  fontFamily: 'DIN Next for Duolingo',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                final email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  context
                      .read<AuthBloc>()
                      .add(AuthResetPasswordEvent(email: email));
                  Navigator.of(context).pop();

                  // Mostrar mensagem de sucesso
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Email de recuperação enviado! Verifique sua caixa de entrada.',
                        style: TextStyle(
                          fontFamily: 'DIN Next for Duolingo',
                          fontSize: ResponsiveValue<double>(
                            context,
                            defaultValue: 14.0,
                            conditionalValues: const [
                              Condition.smallerThan(name: MOBILE, value: 12.0),
                              Condition.largerThan(name: TABLET, value: 16.0),
                            ],
                          ).value,
                        ),
                      ),
                      backgroundColor: MetamorfoseColors.greenNormal,
                    ),
                  );
                }
              },
              child: Text(
                'Enviar',
                style: TextStyle(
                  color: MetamorfoseColors.purpleLight,
                  fontSize: ResponsiveValue<double>(
                    context,
                    defaultValue: 14.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 12.0),
                      Condition.largerThan(name: TABLET, value: 16.0),
                    ],
                  ).value,
                  fontFamily: 'DIN Next for Duolingo',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _completeNameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Widget _buildCustomTabBar() {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous.mode != current.mode,
      builder: (context, state) {
        // Valores responsivos para o tab bar
        final height = ResponsiveValue<double>(
          context,
          defaultValue: 43.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 40.0),
            Condition.largerThan(name: TABLET, value: 52.0),
          ],
        ).value;

        final horizontalMargin = ResponsiveValue<double>(
          context,
          defaultValue: 24.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 16.0),
            Condition.largerThan(name: TABLET, value: 32.0),
          ],
        ).value;

        final padding = ResponsiveValue<double>(
          context,
          defaultValue: 4.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 3.0),
            Condition.largerThan(name: TABLET, value: 6.0),
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

        final fontSize = ResponsiveValue<double>(
          context,
          defaultValue: 16.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 14.0),
            Condition.largerThan(name: TABLET, value: 18.0),
          ],
        ).value;

        return Container(
          width: double.infinity,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          padding: EdgeInsets.all(padding),
          decoration: ShapeDecoration(
            color: MetamorfoseColors.greyLightest2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthToggleModeEvent(AuthScreenMode.login));
                  },
                  child: Container(
                    height: height - (padding * 2),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveValue<double>(
                        context,
                        defaultValue: 16.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 12.0),
                          Condition.largerThan(name: TABLET, value: 20.0),
                        ],
                      ).value,
                      vertical: ResponsiveValue<double>(
                        context,
                        defaultValue: 8.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 6.0),
                          Condition.largerThan(name: TABLET, value: 10.0),
                        ],
                      ).value,
                    ),
                    decoration: state.mode == AuthScreenMode.login
                        ? ShapeDecoration(
                            color: MetamorfoseColors.whiteLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
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
                          fontSize: fontSize,
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
              SizedBox(
                width: ResponsiveValue<double>(
                  context,
                  defaultValue: 4.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 3.0),
                    Condition.largerThan(name: TABLET, value: 6.0),
                  ],
                ).value,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.read<AuthBloc>().add(
                        const AuthToggleModeEvent(AuthScreenMode.register));
                  },
                  child: Container(
                    height: height - (padding * 2),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveValue<double>(
                        context,
                        defaultValue: 16.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 12.0),
                          Condition.largerThan(name: TABLET, value: 20.0),
                        ],
                      ).value,
                      vertical: ResponsiveValue<double>(
                        context,
                        defaultValue: 8.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 6.0),
                          Condition.largerThan(name: TABLET, value: 10.0),
                        ],
                      ).value,
                    ),
                    decoration: state.mode == AuthScreenMode.register
                        ? ShapeDecoration(
                            color: MetamorfoseColors.whiteLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
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
                          fontSize: fontSize,
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
        // Valores responsivos para o formulário
        final topSpacing = ResponsiveValue<double>(
          context,
          defaultValue: 32.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 24.0),
            Condition.largerThan(name: TABLET, value: 40.0),
          ],
        ).value;

        final horizontalPadding = ResponsiveValue<double>(
          context,
          defaultValue: 24.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 16.0),
            Condition.largerThan(name: TABLET, value: 32.0),
          ],
        ).value;

        final fieldSpacing = ResponsiveValue<double>(
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

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: topSpacing),

              // Campo de email
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: InputField(
                  hintText: 'Digite seu e-mail',
                  controller: _emailController,
                  errorText: state.loginState.emailError.isNotEmpty
                      ? state.loginState.emailError
                      : null,
                  prefixIcon: SvgPicture.asset(
                    'assets/images/auth/ic_email.svg',
                    width: iconSize,
                    height: iconSize,
                    colorFilter: const ColorFilter.mode(
                      MetamorfoseColors.purpleLight,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              SizedBox(height: fieldSpacing),

              // Campo de senha
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: PasswordInputField(
                  hintText: 'Senha',
                  controller: _passwordController,
                  errorText: state.loginState.passwordError.isNotEmpty
                      ? state.loginState.passwordError
                      : null,
                  onVisibilityChanged: (isVisible) {
                    context
                        .read<AuthBloc>()
                        .add(AuthToggleEyesEvent(!isVisible));
                  },
                  prefixIcon: SvgPicture.asset(
                    'assets/images/auth/ic_lock.svg',
                    width: iconSize,
                    height: iconSize,
                    colorFilter: const ColorFilter.mode(
                      MetamorfoseColors.purpleLight,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              SizedBox(height: fieldSpacing),

              // Esqueceu a senha
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      _showForgotPasswordDialog();
                    },
                    child: Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        color: MetamorfoseColors.purpleLight,
                        fontSize: ResponsiveValue<double>(
                          context,
                          defaultValue: 14.0,
                          conditionalValues: const [
                            Condition.smallerThan(name: MOBILE, value: 12.0),
                            Condition.largerThan(name: TABLET, value: 16.0),
                          ],
                        ).value,
                        fontFamily: 'DIN Next for Duolingo',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),

              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 32.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 24.0),
                  Condition.largerThan(name: TABLET, value: 40.0),
                ],
              ).value),

              // Botão Entrar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: MetamorfeseButton(
                  text: state.loginState.isLoading ? 'ENTRANDO...' : 'ENTRAR',
                  onPressed: state.loginState.isLoading
                      ? () {}
                      : () {
                          context.read<AuthBloc>().add(AuthSubmitLoginEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                                rememberMe: false,
                              ));
                        },
                ),
              ),

              // Exibir erro se houver
              if (state.loginState.errorMessage != null) ...[
                SizedBox(height: fieldSpacing),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveValue<double>(
                      context,
                      defaultValue: 12.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 10.0),
                        Condition.largerThan(name: TABLET, value: 16.0),
                      ],
                    ).value),
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.redLight,
                      borderRadius: BorderRadius.circular(ResponsiveValue<double>(
                        context,
                        defaultValue: 8.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 6.0),
                          Condition.largerThan(name: TABLET, value: 12.0),
                        ],
                      ).value),
                      border: Border.all(color: MetamorfoseColors.redNormal),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: MetamorfoseColors.redNormal,
                          size: iconSize,
                        ),
                        SizedBox(width: ResponsiveValue<double>(
                          context,
                          defaultValue: 8.0,
                          conditionalValues: const [
                            Condition.smallerThan(name: MOBILE, value: 6.0),
                            Condition.largerThan(name: TABLET, value: 12.0),
                          ],
                        ).value),
                        Expanded(
                          child: Text(
                            state.loginState.errorMessage!,
                            style: TextStyle(
                              color: MetamorfoseColors.redNormal,
                              fontSize: ResponsiveValue<double>(
                                context,
                                defaultValue: 14.0,
                                conditionalValues: const [
                                  Condition.smallerThan(name: MOBILE, value: 12.0),
                                  Condition.largerThan(name: TABLET, value: 16.0),
                                ],
                              ).value,
                              fontFamily: 'DIN Next for Duolingo',
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 24.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 16.0),
                  Condition.largerThan(name: TABLET, value: 32.0),
                ],
              ).value),

              // Divisor OU
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: MetamorfoseColors.whiteDark,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveValue<double>(
                        context,
                        defaultValue: 16.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 12.0),
                          Condition.largerThan(name: TABLET, value: 20.0),
                        ],
                      ).value),
                      child: Text(
                        'OU',
                        style: TextStyle(
                          color: MetamorfoseColors.greyLight,
                          fontSize: ResponsiveValue<double>(
                            context,
                            defaultValue: 14.0,
                            conditionalValues: const [
                              Condition.smallerThan(name: MOBILE, value: 12.0),
                              Condition.largerThan(name: TABLET, value: 16.0),
                            ],
                          ).value,
                          fontFamily: 'DIN Next for Duolingo',
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 24.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 16.0),
                  Condition.largerThan(name: TABLET, value: 32.0),
                ],
              ).value),

              // Botões de login social
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: MetamorfoseSocialButton(
                        text: 'GOOGLE',
                        iconPath: 'assets/images/auth/ic_google_logo.svg',
                        onPressed: state.loginState.isLoading
                            ? () {}
                            : () {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthSignInWithGoogleEvent());
                              },
                        textColor: MetamorfoseColors.blueNormal,
                      ),
                    ),
                    SizedBox(width: ResponsiveValue<double>(
                      context,
                      defaultValue: 50.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 32.0),
                        Condition.largerThan(name: TABLET, value: 64.0),
                      ],
                    ).value),
                    Expanded(
                      child: MetamorfoseSocialButton(
                        text: 'FACEBOOK',
                        iconPath: 'assets/images/auth/ic_facebook_logo.svg',
                        onPressed: state.loginState.isLoading
                            ? () {}
                            : () {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthSignInWithFacebookEvent());
                              },
                        textColor: MetamorfoseColors.blueDark,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 24.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 16.0),
                  Condition.largerThan(name: TABLET, value: 32.0),
                ],
              ).value),

              // Termos e Política de Privacidade
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: MetamorfoseColors.greyLight,
                      fontSize: ResponsiveValue<double>(
                        context,
                        defaultValue: 16.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 14.0),
                          Condition.largerThan(name: TABLET, value: 18.0),
                        ],
                      ).value,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' e '),
                      TextSpan(
                        text: 'Política de Privacidade',
                        style: TextStyle(
                          color: MetamorfoseColors.purpleLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 24.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 16.0),
                  Condition.largerThan(name: TABLET, value: 32.0),
                ],
              ).value),
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
        // Valores responsivos para o formulário de registro
        final topSpacing = ResponsiveValue<double>(
          context,
          defaultValue: 32.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 24.0),
            Condition.largerThan(name: TABLET, value: 40.0),
          ],
        ).value;

        final horizontalPadding = ResponsiveValue<double>(
          context,
          defaultValue: 24.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 16.0),
            Condition.largerThan(name: TABLET, value: 32.0),
          ],
        ).value;

        final fieldSpacing = ResponsiveValue<double>(
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

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: topSpacing),

              // Campo de username
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: InputField(
                  hintText: 'Username',
                  controller: _usernameController,
                  errorText: state.registerState.usernameError.isNotEmpty
                      ? state.registerState.usernameError
                      : null,
                  prefixIcon: SvgPicture.asset(
                    'assets/images/auth/ic_user.svg',
                    width: iconSize,
                    height: iconSize,
                    colorFilter: const ColorFilter.mode(
                      MetamorfoseColors.purpleLight,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              SizedBox(height: fieldSpacing),

              // Campo de telefone
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: InputField(
                  hintText: 'Telefone',
                  controller: _phoneController,
                  errorText: state.registerState.phoneError.isNotEmpty
                      ? state.registerState.phoneError
                      : null,
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    size: iconSize,
                    color: MetamorfoseColors.purpleLight,
                  ),
                ),
              ),

              SizedBox(height: fieldSpacing),

              // Campo de nome completo
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: InputField(
                  hintText: 'Nome Completo',
                  controller: _completeNameController,
                  errorText: state.registerState.completeNameError.isNotEmpty
                      ? state.registerState.completeNameError
                      : null,
                  onChanged: (value) => _onCompleteNameChanged(),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    size: iconSize,
                    color: MetamorfoseColors.purpleLight,
                  ),
                ),
              ),

              SizedBox(height: fieldSpacing),

              // Campo de data de nascimento
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: InputField(
                  hintText: 'Data de Nascimento',
                  controller: _birthDateController,
                  errorText: state.registerState.birthDateError.isNotEmpty
                      ? state.registerState.birthDateError
                      : null,
                  readOnly: true,
                  onTap: () => _selectBirthDate(),
                  prefixIcon: Icon(
                    Icons.calendar_today_outlined,
                    size: iconSize,
                    color: MetamorfoseColors.purpleLight,
                  ),
                ),
              ),

              SizedBox(height: fieldSpacing),

              // Campo de email
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: InputField(
                  hintText: 'E-mail',
                  controller: _emailController,
                  errorText: state.registerState.emailError.isNotEmpty
                      ? state.registerState.emailError
                      : null,
                  prefixIcon: SvgPicture.asset(
                    'assets/images/auth/ic_email.svg',
                    width: iconSize,
                    height: iconSize,
                    colorFilter: const ColorFilter.mode(
                      MetamorfoseColors.purpleLight,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              SizedBox(height: fieldSpacing),

              // Campo de senha
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: PasswordInputField(
                  hintText: 'Senha',
                  controller: _passwordController,
                  errorText: state.registerState.passwordError.isNotEmpty
                      ? state.registerState.passwordError
                      : null,
                  onVisibilityChanged: (isVisible) {
                    context
                        .read<AuthBloc>()
                        .add(AuthToggleEyesEvent(!isVisible));
                  },
                  prefixIcon: SvgPicture.asset(
                    'assets/images/auth/ic_lock.svg',
                    width: iconSize,
                    height: iconSize,
                    colorFilter: const ColorFilter.mode(
                      MetamorfoseColors.purpleLight,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 32.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 24.0),
                  Condition.largerThan(name: TABLET, value: 40.0),
                ],
              ).value),

              // Botão Criar Conta
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                                completeName: _completeNameController.text,
                                birthDate: _birthDateController.text,
                              ));
                        },
                ),
              ),

              if (state.registerState.errorMessage != null) ...[
                SizedBox(height: fieldSpacing),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveValue<double>(
                      context,
                      defaultValue: 12.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 10.0),
                        Condition.largerThan(name: TABLET, value: 16.0),
                      ],
                    ).value),
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.redLight,
                      borderRadius: BorderRadius.circular(ResponsiveValue<double>(
                        context,
                        defaultValue: 8.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 6.0),
                          Condition.largerThan(name: TABLET, value: 12.0),
                        ],
                      ).value),
                      border: Border.all(color: MetamorfoseColors.redNormal),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: MetamorfoseColors.redNormal,
                          size: iconSize,
                        ),
                        SizedBox(width: ResponsiveValue<double>(
                          context,
                          defaultValue: 8.0,
                          conditionalValues: const [
                            Condition.smallerThan(name: MOBILE, value: 6.0),
                            Condition.largerThan(name: TABLET, value: 12.0),
                          ],
                        ).value),
                        Expanded(
                          child: Text(
                            state.registerState.errorMessage!,
                            style: TextStyle(
                              color: MetamorfoseColors.redNormal,
                              fontSize: ResponsiveValue<double>(
                                context,
                                defaultValue: 14.0,
                                conditionalValues: const [
                                  Condition.smallerThan(name: MOBILE, value: 12.0),
                                  Condition.largerThan(name: TABLET, value: 16.0),
                                ],
                              ).value,
                              fontFamily: 'DIN Next for Duolingo',
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 24.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 16.0),
                  Condition.largerThan(name: TABLET, value: 32.0),
                ],
              ).value),
              // Divisor OU
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: MetamorfoseColors.whiteDark,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveValue<double>(
                        context,
                        defaultValue: 16.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 12.0),
                          Condition.largerThan(name: TABLET, value: 20.0),
                        ],
                      ).value),
                      child: Text(
                        'OU',
                        style: TextStyle(
                          color: MetamorfoseColors.greyLight,
                          fontSize: ResponsiveValue<double>(
                            context,
                            defaultValue: 14.0,
                            conditionalValues: const [
                              Condition.smallerThan(name: MOBILE, value: 12.0),
                              Condition.largerThan(name: TABLET, value: 16.0),
                            ],
                          ).value,
                          fontFamily: 'DIN Next for Duolingo',
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 24.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 16.0),
                  Condition.largerThan(name: TABLET, value: 32.0),
                ],
              ).value),
              // Botões de login social
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: MetamorfoseSocialButton(
                        text: 'GOOGLE',
                        iconPath: 'assets/images/auth/ic_google_logo.svg',
                        onPressed: state.registerState.isLoading
                            ? () {}
                            : () {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthSignInWithGoogleEvent());
                              },
                        textColor: MetamorfoseColors.blueNormal,
                      ),
                    ),
                    SizedBox(width: ResponsiveValue<double>(
                      context,
                      defaultValue: 50.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 32.0),
                        Condition.largerThan(name: TABLET, value: 64.0),
                      ],
                    ).value),
                    Expanded(
                      child: MetamorfoseSocialButton(
                        text: 'FACEBOOK',
                        iconPath: 'assets/images/auth/ic_facebook_logo.svg',
                        onPressed: state.registerState.isLoading
                            ? () {}
                            : () {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthSignInWithFacebookEvent());
                              },
                        textColor: MetamorfoseColors.blueDark,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 24.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 16.0),
                  Condition.largerThan(name: TABLET, value: 32.0),
                ],
              ).value),
              // Termos e Política de Privacidade
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: MetamorfoseColors.greyLight,
                      fontSize: ResponsiveValue<double>(
                        context,
                        defaultValue: 16.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 14.0),
                          Condition.largerThan(name: TABLET, value: 18.0),
                        ],
                      ).value,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' e '),
                      TextSpan(
                        text: 'Política de Privacidade',
                        style: TextStyle(
                          color: MetamorfoseColors.purpleLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveValue<double>(
                context,
                defaultValue: 24.0,
                conditionalValues: const [
                  Condition.smallerThan(name: MOBILE, value: 16.0),
                  Condition.largerThan(name: TABLET, value: 32.0),
                ],
              ).value),
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
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveValue<double>(
                    context,
                    defaultValue: 56.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 48.0),
                      Condition.largerThan(name: TABLET, value: 64.0),
                    ],
                  ).value,
                  child: Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/arrow_back.svg',
                          width: ResponsiveValue<double>(
                            context,
                            defaultValue: 34.0,
                            conditionalValues: const [
                              Condition.smallerThan(name: MOBILE, value: 28.0),
                              Condition.largerThan(name: TABLET, value: 40.0),
                            ],
                          ).value,
                          height: ResponsiveValue<double>(
                            context,
                            defaultValue: 34.0,
                            conditionalValues: const [
                              Condition.smallerThan(name: MOBILE, value: 28.0),
                              Condition.largerThan(name: TABLET, value: 40.0),
                            ],
                          ).value,
                        ),
                        onPressed: () => context.go(Routes.onboarding),
                      ),
                    ],
                  ),
                ),

                // Personagem robô (reativo ao estado dos olhos)
                Expanded(
                  flex: ResponsiveValue<int>(
                    context,
                    defaultValue: 2,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 1),
                      Condition.largerThan(name: TABLET, value: 3),
                    ],
                  ).value,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) =>
                        previous.eyesOpen != current.eyesOpen,
                    builder: (context, state) {
                      // Valores responsivos para o personagem
                      final leftMargin = ResponsiveValue<double>(
                        context,
                        defaultValue: state.eyesOpen ? 0.175 : 0.2375,
                        conditionalValues: [
                          Condition.smallerThan(name: MOBILE, value: state.eyesOpen ? 0.15 : 0.2),
                          Condition.largerThan(name: TABLET, value: state.eyesOpen ? 0.2 : 0.25),
                        ],
                      ).value;

                      final imageWidth = ResponsiveValue<double>(
                        context,
                        defaultValue: state.eyesOpen ? 0.65 : 0.525,
                        conditionalValues: [
                          Condition.smallerThan(name: MOBILE, value: state.eyesOpen ? 0.7 : 0.6),
                          Condition.largerThan(name: TABLET, value: state.eyesOpen ? 0.6 : 0.5),
                        ],
                      ).value;

                      final bottomOffset = ResponsiveValue<double>(
                        context,
                        defaultValue: -50.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: -40.0),
                          Condition.largerThan(name: TABLET, value: -60.0),
                        ],
                      ).value;

                      return Stack(
                        children: [
                          Positioned(
                            bottom: bottomOffset,
                            left: screenWidth * leftMargin,
                            right: screenWidth * leftMargin,
                            child: Image.asset(
                              state.eyesOpen
                                  ? 'assets/images/auth/ivy_eyes_open.png'
                                  : 'assets/images/auth/ivy_eyes_closed.png',
                              width: screenWidth * imageWidth,
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
                  flex: ResponsiveValue<int>(
                    context,
                    defaultValue: isSmallScreen ? 4 : 5,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 3),
                      Condition.largerThan(name: TABLET, value: 6),
                    ],
                  ).value,
                  child: Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: MetamorfoseColors.whiteLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ResponsiveValue<double>(
                            context,
                            defaultValue: 32.0,
                            conditionalValues: const [
                              Condition.smallerThan(name: MOBILE, value: 24.0),
                              Condition.largerThan(name: TABLET, value: 40.0),
                            ],
                          ).value),
                          topRight: Radius.circular(ResponsiveValue<double>(
                            context,
                            defaultValue: 32.0,
                            conditionalValues: const [
                              Condition.smallerThan(name: MOBILE, value: 24.0),
                              Condition.largerThan(name: TABLET, value: 40.0),
                            ],
                          ).value),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: ResponsiveValue<double>(
                          context,
                          defaultValue: 32.0,
                          conditionalValues: const [
                            Condition.smallerThan(name: MOBILE, value: 24.0),
                            Condition.largerThan(name: TABLET, value: 40.0),
                          ],
                        ).value),

                        // Custom Tab Bar
                        _buildCustomTabBar(),

                        // Formulário
                        Expanded(
                          child: BlocBuilder<AuthBloc, AuthState>(
                            buildWhen: (previous, current) =>
                                previous.mode != current.mode,
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

  void _onCompleteNameChanged() {
    if (mounted) {
      context.read<AuthBloc>().add(AuthUpdateRegisterFieldEvent(
            completeName: _completeNameController.text,
          ));
    }
  }

  void _onBirthDateChanged() {
    if (mounted) {
      context.read<AuthBloc>().add(AuthUpdateRegisterFieldEvent(
            birthDate: _birthDateController.text,
          ));
    }
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      _birthDateController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      _onBirthDateChanged();
    }
  }
}
