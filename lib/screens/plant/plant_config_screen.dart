/**
 * File: plant_config_screen.dart
 * Description: Tela de configuração da planta virtual.
 *
 * Responsabilidades:
 * - Permitir personalização da planta virtual
 * - Configurar nome e aparência da planta
 * - Criar conexão emocional com o usuário
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:conversao_flutter/routes/routes.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/index.dart';

/// Tela de configuração da planta virtual.
/// Permite ao usuário personalizar sua planta para criar conexão emocional.
class PlantConfigScreen extends StatefulWidget {
  const PlantConfigScreen({super.key});

  @override
  State<PlantConfigScreen> createState() => _PlantConfigScreenState();
}

class _PlantConfigScreenState extends State<PlantConfigScreen> {
  final _nameController = TextEditingController();
  String? _selectedPlant;
  Color? _selectedColor;
  
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
    // Definir valores padrão
    _selectedPlant = _plantOptions.first.value;
    _selectedColor = _colorOptions.first.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleTakePhoto() {
    // Implementar funcionalidade de tirar foto
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade de foto será implementada')),
    );
  }

  void _handleSkip() {
    // Navegar para próxima tela
    context.go(Routes.voiceChat);
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
          gradient: MetamorfoseGradients.lightPurpleGradient
        ),
        child: SafeArea(
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
                flex: 4,
                child: Center(
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.35,
                    child: SvgPicture.asset(
                      'assets/images/plantsetup/plantsetup.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              // Painel inferior com configurações
              Expanded(
                flex: 4,
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
                      
                      // Campo nome da planta
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: MetamorfeseInput(
                          hintText: 'Nome da planta',
                          controller: _nameController,
                          prefixIcon: const Icon(
                            Icons.spa,
                            color: MetamorfoseColors.purpleNormal,
                            size: 20,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Select para tipo de planta
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: MetamorfeseSelect<String>(
                          hintText: 'Selecione a sua planta',
                          selectedValue: _selectedPlant,
                          options: _plantOptions,
                          modalTitle: 'Selecione sua planta',
                          prefixIcon: const Icon(
                            Icons.eco,
                            color: MetamorfoseColors.purpleNormal,
                            size: 20,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedPlant = value;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Select para cor do vaso
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: MetamorfeseSelect<Color>(
                          hintText: 'Cor do vaso',
                          selectedValue: _selectedColor,
                          options: _colorOptions,
                          modalTitle: 'Cor do vaso',
                          onChanged: (value) {
                            setState(() {
                              _selectedColor = value;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Botões
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // Botão tirar foto
                            SizedBox(
                              width: double.infinity,
                              child: MetamorfeseButton(
                                text: 'TIRAR A PRIMEIRA FOTO DE SUA PLANTA',
                                onPressed: _handleTakePhoto,
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Botão ignorar
                            SizedBox(
                              width: double.infinity,
                              child: MetamorfeseSecondaryButton(
                                text: 'IGNORAR ESSA ETAPA POR ENQUANTO',
                                onPressed: _handleSkip,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
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