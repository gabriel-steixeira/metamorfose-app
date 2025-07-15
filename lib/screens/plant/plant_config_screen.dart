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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/index.dart';
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
  
  final List<SelectOption<String>> _plantOptions = [
    const SelectOption(
      value: 'suculenta',
      label: 'Suculenta',
      icon: Icon(Icons.spa, color: MetamorfoseColors.purpleNormal),
    ),
    const SelectOption(
      value: 'samambaia',
      label: 'Samambaia',
      icon: Icon(Icons.eco, color: MetamorfoseColors.purpleNormal),
    ),
    const SelectOption(
      value: 'cacto',
      label: 'Cacto',
      icon: Icon(Icons.park, color: MetamorfoseColors.purpleNormal),
    ),
  ];
  
  final List<SelectOption<Color>> _colorOptions = [
    SelectOption(
      value: MetamorfoseColors.purpleNormal,
      label: 'Roxo',
      icon: Container(
        width: 24,
        height: 24,
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
        width: 24,
        height: 24,
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
        width: 24,
        height: 24,
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
        width: 24,
        height: 24,
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

  void _handleTakePhoto() {
    print('Botão TIRAR FOTO pressionado - navegando para home');
    context.go(Routes.home);
  }

  void _handleSkip() {
    print('Botão IGNORAR pressionado - navegando para home');
    context.go(Routes.home);
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
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
          // Limpar erro após mostrar
          context.read<PlantConfigBloc>().add(ClearErrorEvent());
        }
      },
      builder: (context, state) {
        // Debug do estado atual
        print('🔄 Builder executado - Estado: ${state.validationState}, canSave: ${state.canSave}, nome: "${state.plantName}"');
        
        // Sincronizar controller com o estado de forma otimizada
        _updateControllerSafely(state.plantName);
        
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: MetamorfoseGradients.lightPurpleGradient
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header com botão de voltar (fixo)
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
                  
                  // Área da planta visual (fixa)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
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
                  
                  // Espaçamento adicionado
                  const SizedBox(height: 24),

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
                            minHeight: MediaQuery.of(context).size.height * 0.6,
                          ),
                          padding: const EdgeInsets.only(
                            top: 32,
                            left: 24,
                            right: 24,
                            bottom: 24,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                                  context.read<PlantConfigBloc>().add(
                                    SelectPlantTypeEvent(value!),
                                  );
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
                                  context.read<PlantConfigBloc>().add(
                                    SelectPlantColorEvent(value!),
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Botões
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: MetamorfeseButton(
                                      text: 'TIRAR A PRIMEIRA FOTO DE SUA PLANTA',
                                      onPressed: _handleTakePhoto,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: MetamorfeseSecondaryButton(
                                      text: 'IGNORAR ESSA ETAPA POR ENQUANTO',
                                      onPressed: _handleSkip,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
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