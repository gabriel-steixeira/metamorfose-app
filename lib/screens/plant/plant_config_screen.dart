/**
 * File: plant_config_screen.dart
 * Description: Versão BLoC da tela de configuração da planta virtual.
 *
 * Responsabilidades:
 * - Permitir personalização da planta virtual
 * - Configurar nome e aparência da planta
 * - Criar conexão emocional com o usuário
 * - Usar BLoC pattern para gerenciamento de estado
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 2.0.0 (BLoC)
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/index.dart';
import 'package:metamorfose_flutter/components/input_field.dart';
import 'package:metamorfose_flutter/components/select_field.dart';
import 'package:metamorfose_flutter/blocs/plant_config_bloc.dart';
import 'package:metamorfose_flutter/state/plant_config/plant_config_state.dart';

/// Tela de configuração da planta virtual com BLoC.
/// Permite ao usuário personalizar sua planta para criar conexão emocional.
class PlantConfigScreen extends StatefulWidget {
  const PlantConfigScreen({super.key});

  @override
  State<PlantConfigScreen> createState() => _PlantConfigScreenState();
}

class _PlantConfigScreenState extends State<PlantConfigScreen> {
  final _nameController = TextEditingController();
  bool _isUpdatingController = false;
  String _lastKnownText = '';

  String _getPlantSvgAsset(Color color) {
    if (color == MetamorfoseColors.blueNormal)
      return 'assets/images/plantsetup/plantsetup_blue.svg';
    if (color == MetamorfoseColors.greenNormal)
      return 'assets/images/plantsetup/plantsetup_green.svg';
    if (color == MetamorfoseColors.pinkNormal)
      return 'assets/images/plantsetup/plantsetup_pink.svg';
    return 'assets/images/plantsetup/plantsetup.svg';
  }

  Widget _buildFramedPlant(Color color) {
    return SvgPicture.asset(
      _getPlantSvgAsset(color),
      fit: BoxFit.contain,
    );
  }

  final List<SelectOption<String>> _plantOptions = [
    const SelectOption(
      value: 'suculenta',
      label: 'Suculenta',
      icon: Icon(Icons.spa, color: MetamorfoseColors.purpleLight, size: 20),
    ),
    const SelectOption(
      value: 'samambaia',
      label: 'Samambaia',
      icon: Icon(Icons.eco, color: MetamorfoseColors.purpleLight, size: 20),
    ),
    const SelectOption(
      value: 'cacto',
      label: 'Cacto',
      icon: Icon(Icons.park, color: MetamorfoseColors.purpleLight, size: 20),
    ),
  ];

  final List<SelectOption<Color>> _colorOptions = [
    SelectOption(
      value: MetamorfoseColors.purpleNormal,
      label: 'Roxo',
      icon: Container(
        width: 20,
        height: 20,
        decoration: const ShapeDecoration(
          color: MetamorfoseColors.purpleNormal,
          shape: OvalBorder(),
        ),
      ),
    ),
    SelectOption(
      value: MetamorfoseColors.greenNormal,
      label: 'Verde',
      icon: Container(
        width: 20,
        height: 20,
        decoration: const ShapeDecoration(
          color: MetamorfoseColors.greenNormal,
          shape: OvalBorder(),
        ),
      ),
    ),
    SelectOption(
      value: MetamorfoseColors.blueNormal,
      label: 'Azul',
      icon: Container(
        width: 20,
        height: 20,
        decoration: const ShapeDecoration(
          color: MetamorfoseColors.blueNormal,
          shape: OvalBorder(),
        ),
      ),
    ),
    SelectOption(
      value: MetamorfoseColors.pinkNormal,
      label: 'Rosa',
      icon: Container(
        width: 20,
        height: 20,
        decoration: const ShapeDecoration(
          color: MetamorfoseColors.pinkNormal,
          shape: OvalBorder(),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Inicializar o BLoC
    context.read<PlantConfigBloc>().add(InitializePlantConfigEvent());

    // Adicionar listener ao controller para detectar mudanças manuais
    _nameController.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onControllerChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!_isUpdatingController && _nameController.text != _lastKnownText) {
      _lastKnownText = _nameController.text;
      print('📝 Nome da planta alterado: "${_nameController.text}"');
      // Só enviar evento se a mudança veio do usuário
      context.read<PlantConfigBloc>().add(
            UpdatePlantNameEvent(_nameController.text),
          );
    }
  }

  void _updateControllerSafely(String newText) {
    if (_nameController.text != newText && newText != _lastKnownText) {
      _isUpdatingController = true;
      _lastKnownText = newText;
      _nameController.text = newText;
      _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
      _isUpdatingController = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<PlantConfigBloc, PlantConfigState>(
      listener: (context, state) {
        // Navegar quando o processamento for concluído
        if (state.loadingState == LoadingState.navigating) {
          // Pequeno delay para mostrar o estado antes de navegar
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              print('Navegando para ${Routes.home}');
              context.go(Routes.home);
            }
          });
        }

        // Mostrar erros se houver
      },
      builder: (context, state) {
        // Debug do estado atual
        print(
            '🔄 Builder executado - Estado: ${state.validationState}, canSave: ${state.canSave}, nome: "${state.plantName}"');

        // Sincronizar controller com o estado de forma otimizada
        _updateControllerSafely(state.plantName);

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                gradient: MetamorfoseGradients.lightPurpleGradient),
            child: SafeArea(
              child: Column(
                children: [
                  // Header com botão de voltar (fixo)
                  Container(
                    width: double.infinity,
                    height: 48,
                    child: Row(
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/arrow_back.svg',
                            width: 28,
                            height: 28,
                          ),
                          onPressed: () => context.go(Routes.auth),
                        ),
                      ],
                    ),
                  ),

                  // Área da planta visual (fixa)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Center(
                      child: SizedBox(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.25,
                        child: _buildFramedPlant(state.selectedColor),
                      ),
                    ),
                  ),

                  // Espaçamento adicionado
                  const SizedBox(height: 16),

                  // Painel inferior com configurações (fixado no final da tela)
                  Expanded(
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
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          padding: const EdgeInsets.only(
                            top: 24,
                            left: 24,
                            right: 24,
                            bottom: 32,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Campo nome da planta
                              InputField(
                                hintText: 'Nome da planta',
                                controller: _nameController,
                                prefixIcon: const Icon(
                                  Icons.spa,
                                  color: MetamorfoseColors.purpleLight,
                                  size: 20,
                                ),
                                errorText: state.nameError,
                              ),

                              const SizedBox(height: 12),

                              // Select para tipo de planta
                              SelectField<String>(
                                hintText: 'Selecione a sua planta',
                                selectedValue: state.selectedPlant,
                                options: _plantOptions,
                                modalTitle: 'Selecione sua planta',
                                prefixIcon: const Icon(
                                  Icons.eco,
                                  color: MetamorfoseColors.purpleLight,
                                  size: 20,
                                ),
                                onChanged: (value) {
                                  context.read<PlantConfigBloc>().add(
                                        SelectPlantTypeEvent(value!),
                                      );
                                },
                              ),

                              const SizedBox(height: 12),

                              // Select para cor do vaso
                              SelectField<Color>(
                                hintText: 'Cor do vaso',
                                selectedValue: state.selectedColor,
                                options: _colorOptions,
                                modalTitle: 'Cor do vaso',
                                onChanged: (value) {
                                  context.read<PlantConfigBloc>().add(
                                        SelectPlantColorEvent(value!),
                                      );
                                },
                              ),

                              const SizedBox(height: 24),

                              // Botão para finalizar configuração
                              SizedBox(
                                width: double.infinity,
                                child: IgnorePointer(
                                  ignoring: !state.canSave ||
                                      state.loadingState == LoadingState.saving,
                                  child: Opacity(
                                    opacity: (state.canSave &&
                                            state.loadingState !=
                                                LoadingState.saving)
                                        ? 1.0
                                        : 0.5,
                                    child: MetamorfeseButton(
                                      text: state.loadingState ==
                                              LoadingState.saving
                                          ? null
                                          : 'FINALIZAR CONFIGURAÇÃO',
                                      child: state.loadingState ==
                                              LoadingState.saving
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : null,
                                      onPressed: () {
                                        if (!state.canSave) return;
                                        if (state.loadingState ==
                                            LoadingState.saving) return;

                                        context.read<PlantConfigBloc>().add(
                                              FinishConfigurationEvent(),
                                            );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Texto para acessar o mapa de floriculturas
                              GestureDetector(
                                onTap: () {
                                  // Navegar para a tela de mapa
                                  context.push(Routes.map);
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                      color: MetamorfoseColors.greyMedium,
                                      fontSize: 16,
                                      fontFamily: 'DIN Next for Duolingo',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '🌸 Ainda não tem uma planta?\n',
                                        style: TextStyle(
                                          color: MetamorfoseColors.purpleLight,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Encontre uma floricultura perto de você!',
                                        style: TextStyle(
                                          color: MetamorfoseColors.purpleLight,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    state.errorMessage ??
                                        'Erro desconhecido. Tente novamente mais tarde.',
                                    style: TextStyle(
                                      color: MetamorfoseColors.redNormal,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
