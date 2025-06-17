/**
 * File: plant_config_screen_bloc.dart
 * Description: Tela de configuração da planta virtual com arquitetura BLoC.
 *
 * Responsabilidades:
 * - Interface para personalização da planta virtual
 * - Formulário reativo com validação em tempo real
 * - Integração com BLoC para gerenciamento de estado
 * - Navegação para captura de foto ou home
 *
 * Author: Gabriel Teixeira
 * Created on: 01-01-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:conversao_flutter/routes/routes.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/index.dart';
import 'package:conversao_flutter/blocs/plant_config_bloc.dart';
import 'package:conversao_flutter/state/plant_config/plant_config_state.dart';

/// Tela de configuração da planta virtual com BLoC.
/// Interface reativa para personalização da planta.
class PlantConfigScreenBloc extends StatelessWidget {
  const PlantConfigScreenBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantConfigBloc()..add(InitializePlantConfigEvent()),
      child: const _PlantConfigView(),
    );
  }
}

class _PlantConfigView extends StatefulWidget {
  const _PlantConfigView();

  @override
  State<_PlantConfigView> createState() => _PlantConfigViewState();
}

class _PlantConfigViewState extends State<_PlantConfigView> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Escutar mudanças no campo de nome para sincronizar com BLoC
    _nameController.addListener(() {
      context.read<PlantConfigBloc>().add(
        UpdatePlantNameEvent(_nameController.text),
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Converte PlantOption para SelectOption<String>
  List<SelectOption<String>> get _plantOptions {
    return PlantOption.values.map((option) => SelectOption(
      value: option.value,
      label: option.label,
      icon: Icon(option.icon, color: MetamorfoseColors.purpleNormal),
    )).toList();
  }

  // Converte ColorOption para SelectOption<Color>
  List<SelectOption<Color>> get _colorOptions {
    return ColorOption.values.map((option) => SelectOption(
      value: option.value,
      label: option.label,
      icon: Container(
        width: 24,
        height: 24,
        decoration: ShapeDecoration(
          color: option.value,
          shape: const OvalBorder(),
        ),
      ),
    )).toList();
  }

  void _handleTakePhoto(BuildContext context) {
    context.read<PlantConfigBloc>().add(TakeFirstPhotoEvent());
  }

  void _handleSkip(BuildContext context) {
    context.read<PlantConfigBloc>().add(SkipPhotoEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: MetamorfoseGradients.lightPurpleGradient,
        ),
        child: SafeArea(
          child: BlocListener<PlantConfigBloc, PlantConfigState>(
            listener: (context, state) {
              // Sincronizar controller com estado do BLoC
              if (_nameController.text != state.plantName) {
                _nameController.text = state.plantName;
              }

              // Mostrar erros
              if (state.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: MetamorfoseColors.redNormal,
                    action: SnackBarAction(
                      label: 'OK',
                      textColor: MetamorfoseColors.whiteLight,
                      onPressed: () {
                        context.read<PlantConfigBloc>().add(ClearErrorEvent());
                      },
                    ),
                  ),
                );
              }

              // Navegar quando processo for concluído
              if (state.loadingState == LoadingState.idle && 
                  !state.hasError && 
                  (state.plantName.isNotEmpty && state.isValid)) {
                // Delay para permitir que loading seja exibido
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    context.go(Routes.home);
                  }
                });
              }
            },
            child: Column(
              children: [
                // Header com botão de voltar
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
                        onPressed: () => context.go(Routes.auth),
                      ),
                    ],
                  ),
                ),
                
                // Área da planta visual
                Expanded(
                  flex: 3,
                  child: Center(
                    child: SizedBox(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.3,
                      child: SvgPicture.asset(
                        'assets/images/plantsetup/plantsetup.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                
                // Painel inferior com formulário
                Expanded(
                  flex: 5,
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
                    child: BlocBuilder<PlantConfigBloc, PlantConfigState>(
                      buildWhen: (previous, current) {
                        // Rebuild quando necessário para performance
                        return previous.selectedPlant != current.selectedPlant ||
                               previous.selectedColor != current.selectedColor ||
                               previous.validationState != current.validationState ||
                               previous.loadingState != current.loadingState ||
                               previous.errorMessage != current.errorMessage;
                      },
                      builder: (context, state) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              
                              // Campo nome da planta
                              MetamorfeseInput(
                                hintText: 'Nome da planta',
                                controller: _nameController,
                                prefixIcon: const Icon(
                                  Icons.spa,
                                  color: MetamorfoseColors.purpleNormal,
                                  size: 20,
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Select para tipo de planta
                              MetamorfeseSelect<String>(
                                hintText: 'Selecione a sua planta',
                                selectedValue: state.selectedPlant,
                                options: _plantOptions,
                                modalTitle: 'Selecione sua planta',
                                prefixIcon: const Icon(
                                  Icons.eco,
                                  color: MetamorfoseColors.purpleNormal,
                                  size: 20,
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<PlantConfigBloc>().add(
                                      SelectPlantTypeEvent(value),
                                    );
                                  }
                                },
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Select para cor do vaso
                              MetamorfeseSelect<Color>(
                                hintText: 'Cor do vaso',
                                selectedValue: state.selectedColor,
                                options: _colorOptions,
                                modalTitle: 'Cor do vaso',
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<PlantConfigBloc>().add(
                                      SelectPlantColorEvent(value),
                                    );
                                  }
                                },
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Indicador de validação
                              if (state.validationState == ValidationState.invalid && 
                                  state.errorMessage != null) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: MetamorfoseColors.redLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: MetamorfoseColors.redNormal,
                                    ),
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
                                          state.errorMessage!,
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
                                const SizedBox(height: 16),
                              ],
                              
                              // Indicador de validação positiva
                              if (state.isValid) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: MetamorfoseColors.blueLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: MetamorfoseColors.greenNormal,
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: MetamorfoseColors.greenNormal,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Configuração válida! Você pode continuar.',
                                          style: TextStyle(
                                            color: MetamorfoseColors.greenNormal,
                                            fontSize: 14,
                                            fontFamily: 'DIN Next for Duolingo',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              
                              // Botões
                              Column(
                                children: [
                                  // Botão tirar foto
                                  SizedBox(
                                    width: double.infinity,
                                    child: MetamorfeseButton(
                                      text: state.isSaving
                                          ? 'SALVANDO...'
                                          : state.isNavigating
                                              ? 'PREPARANDO...'
                                              : 'TIRAR A PRIMEIRA FOTO DE SUA PLANTA',
                                      onPressed: state.isLoading
                                          ? () {} // Função vazia quando desabilitado
                                          : () => _handleTakePhoto(context),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Botão ignorar
                                  SizedBox(
                                    width: double.infinity,
                                    child: MetamorfeseSecondaryButton(
                                      text: state.isLoading
                                          ? 'PROCESSANDO...'
                                          : 'IGNORAR ESSA ETAPA POR ENQUANTO',
                                      onPressed: state.isLoading
                                          ? () {} // Função vazia quando desabilitado
                                          : () => _handleSkip(context),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Texto para acessar o mapa de floriculturas
                              GestureDetector(
                                onTap: () {
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
                                        text: 'Encontre uma floricultura perto de você!',
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
                              
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      },
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