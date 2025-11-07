/// File: plant_config_screen.dart
/// Description: Versão BLoC da tela de configuração da planta virtual.
///
/// Responsabilidades:
/// - Permitir personalização da planta virtual
/// - Configurar nome e aparência da planta
/// - Criar conexão emocional com o usuário
/// - Usar BLoC pattern para gerenciamento de estado
///
/// Author: Evelin Brandão
/// Version: 2.0.0 (BLoC)
/// Squad: Metamorfose  

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

  List<SelectOption<String>> _getPlantOptions(double iconSize) => [
    SelectOption(
      value: 'suculenta',
      label: 'Suculenta',
      icon: Icon(Icons.spa, color: MetamorfoseColors.purpleLight, size: iconSize),
    ),
    SelectOption(
      value: 'samambaia',
      label: 'Samambaia',
      icon: Icon(Icons.eco, color: MetamorfoseColors.purpleLight, size: iconSize),
    ),
    SelectOption(
      value: 'cacto',
      label: 'Cacto',
      icon: Icon(Icons.park, color: MetamorfoseColors.purpleLight, size: iconSize),
    ),
       SelectOption(
      value: 'orquidea',
      label: 'Orquídea',
      icon: Icon(Icons.local_florist, color: MetamorfoseColors.purpleLight, size: iconSize),
    ),
  ];

  List<SelectOption<Color>> _getColorOptions(double iconSize) => [
    SelectOption(
      value: MetamorfoseColors.purpleNormal,
      label: 'Roxo',
      icon: Container(
        width: iconSize,
        height: iconSize,
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
        width: iconSize,
        height: iconSize,
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
        width: iconSize,
        height: iconSize,
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
        width: iconSize,
        height: iconSize,
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
    context.read<PlantConfigBloc>().add(InitializePlantConfigEvent());
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
    final headerHeight = ResponsiveValue<double>(
      context,
      defaultValue: 48.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 44.0),
        Condition.largerThan(name: TABLET, value: 52.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 28.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final plantIconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 32.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 40.0),
      ],
    ).value;

    final containerPadding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final spacingSmall = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final spacingMedium = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final spacingLarge = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final spacingBottom = ResponsiveValue<double>(
      context,
      defaultValue: 32.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 40.0),
      ],
    ).value;

    return BlocConsumer<PlantConfigBloc, PlantConfigState>(
      listener: (context, state) {
        if (state.loadingState == LoadingState.navigating) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.go(Routes.home);
            }
          });
        }
      },
      builder: (context, state) {
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
                  Container(
                    width: double.infinity,
                    height: headerHeight,
                    child: Row(
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/arrow_back.svg',
                            width: iconSize,
                            height: iconSize,
                          ),
                          onPressed: () => context.go(Routes.auth),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: _buildFramedPlant(state.selectedColor),
                      ),
                    ),
                  ),

                  SizedBox(height: spacingMedium),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        color: MetamorfoseColors.whiteLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadius),
                            topRight: Radius.circular(borderRadius),
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          padding: EdgeInsets.only(
                            top: containerPadding,
                            left: containerPadding,
                            right: containerPadding,
                            bottom: spacingBottom,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InputField(
                                hintText: 'Nome da planta',
                                controller: _nameController,
                                prefixIcon: Icon(
                                  Icons.spa,
                                  color: MetamorfoseColors.purpleLight,
                                  size: plantIconSize,
                                ),
                                errorText: state.nameError,
                              ),

                              SizedBox(height: spacingSmall),

                              SelectField<String>(
                                hintText: 'Selecione a sua planta',
                                selectedValue: state.selectedPlant,
                                options: _getPlantOptions(plantIconSize),
                                modalTitle: 'Selecione sua planta',
                                prefixIcon: Icon(
                                  Icons.eco,
                                  color: MetamorfoseColors.purpleLight,
                                  size: plantIconSize,
                                ),
                                onChanged: (value) {
                                  context.read<PlantConfigBloc>().add(
                                        SelectPlantTypeEvent(value),
                                      );
                                },
                              ),

                              SizedBox(height: spacingSmall),

                              SelectField<Color>(
                                hintText: 'Cor do vaso',
                                selectedValue: state.selectedColor,
                                options: _getColorOptions(plantIconSize),
                                modalTitle: 'Cor do vaso',
                                onChanged: (value) {
                                  context.read<PlantConfigBloc>().add(
                                        SelectPlantColorEvent(value),
                                      );
                                },
                              ),

                              SizedBox(height: spacingLarge),

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
                                          ? SizedBox(
                                              width: iconSize,
                                              height: iconSize,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(MetamorfoseColors.whiteLight),
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

                              SizedBox(height: spacingMedium),

                              GestureDetector(
                                onTap: () {
                                  context.push(Routes.map);
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: MetamorfoseColors.greyMedium,
                                      fontSize: fontSize,
                                      fontFamily: 'DIN Next for Duolingo',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: const [
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
                                  padding: EdgeInsets.only(top: spacingMedium),
                                  child: Text(
                                    state.errorMessage ??
                                        'Erro desconhecido. Tente novamente mais tarde.',
                                    style: TextStyle(
                                      color: MetamorfoseColors.redNormal,
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
