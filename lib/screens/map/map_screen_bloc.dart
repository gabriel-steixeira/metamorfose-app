/// File: map_screen_bloc.dart
/// Description: Tela de mapa com BLoC implementada.
///
/// Responsabilidades:
/// - Exibir mapa com floriculturas próximas usando BLoC
/// - Listar floriculturas em formato de lista
/// - Interface de busca reativa
/// - Gerenciar localização do usuário via BLoC
///
/// Author: Gabriel Teixeira
/// Created on: 31-08-2025
/// 
/// Changes:
/// - UI Ajustada. (Evelin Cordeiro)
/// 
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metamorfose_flutter/blocs/map_bloc.dart';
import 'package:metamorfose_flutter/state/map/map_state.dart';
import 'package:metamorfose_flutter/services/map_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/components/input_field.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

class MapScreenBloc extends StatelessWidget {
  const MapScreenBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(
        MapService(), // Injeta a dependência
      )..add(MapInitializeEvent()),
      child: const MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final TextEditingController _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        // Mostra erro de localização se houver
        if (state.locationState.hasError &&
            state.locationState.shouldShowError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.locationState.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
              action: SnackBarAction(
                label: 'TENTAR NOVAMENTE',
                textColor: MetamorfoseColors.whiteLight,
                onPressed: () {
                  context.read<MapBloc>().add(MapReloadLocationEvent());
                },
              ),
            ),
          );
        }

        // Mostra erro de busca se houver
        if (state.searchState.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.searchState.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MetamorfoseColors.whiteLight,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                _buildTabBar(context, state),
                Expanded(
                  child: IndexedStack(
                    index: state.selectedTab.index,
                    children: [
                      _buildMapView(context, state),
                      _buildListView(context, state),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavigationMenu(activeIndex: 2),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 22.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final iconPadding = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 14.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          Text(
            'Floriculturas Próximas',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: MetamorfoseColors.blackNormal,
              fontFamily: 'DIN Next for Duolingo',
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: spacing),
          InputField(
            hintText: 'Buscar floricultura...',
            controller: _searchController,
            prefixIcon: Padding(
              padding: EdgeInsets.all(iconPadding),
              child: Icon(
                Icons.search,
                color: MetamorfoseColors.purpleNormal,
                size: iconSize,
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: MetamorfoseColors.greyMedium,
                      size: iconSize,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                      context.read<MapBloc>().add(MapClearSearchEvent());
                    },
                  )
                : null,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context
                    .read<MapBloc>()
                    .add(MapSearchWithQueryEvent(value.trim()));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, MapState state) {
    final height = ResponsiveValue<double>(
      context,
      defaultValue: 43.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 52.0),
      ],
    ).value;

    final margin = ResponsiveValue<double>(
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

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 4.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 3.0),
        Condition.largerThan(name: TABLET, value: 6.0),
      ],
    ).value;

    return Container(
      width: double.infinity,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: margin),
      padding: EdgeInsets.all(padding),
      decoration: ShapeDecoration(
        color: MetamorfoseColors.greyLightest2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      ),
      child: Row(
        children: [
          _buildTabItem(context, 'Mapa', MapTabIndex.map, state.selectedTab),
          SizedBox(width: spacing),
          _buildTabItem(context, 'Lista', MapTabIndex.list, state.selectedTab),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String title, MapTabIndex tabIndex,
      MapTabIndex selectedTab) {
    final isSelected = tabIndex == selectedTab;
    
    final height = ResponsiveValue<double>(
      context,
      defaultValue: 35.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 32.0),
        Condition.largerThan(name: TABLET, value: 42.0),
      ],
    ).value;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
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

    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<MapBloc>().add(MapChangeTabEvent(tabIndex)),
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: isSelected
              ? ShapeDecoration(
                  color: MetamorfoseColors.whiteLight,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius)),
                  shadows: const [
                    BoxShadow(
                        color: MetamorfoseColors.shadowLight,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        spreadRadius: 0)
                  ],
                )
              : null,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? MetamorfoseColors.greyMedium
                    : MetamorfoseColors.greyLight,
                fontSize: fontSize,
                fontFamily: 'DIN Next for Duolingo',
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapView(BuildContext context, MapState state) {
    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 64.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 48.0),
        Condition.largerThan(name: TABLET, value: 80.0),
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

    final margin = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    if (state.locationState.isLoading) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const CircularProgressIndicator(color: MetamorfoseColors.purpleNormal),
        SizedBox(height: spacing),
        Text(
          'Obtendo sua localização...',
          style: TextStyle(
            color: MetamorfoseColors.greyMedium,
            fontFamily: 'DIN Next for Duolingo',
            fontSize: fontSize,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ]));
    }
    if (state.locationState.hasError) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.location_off,
          size: iconSize,
          color: MetamorfoseColors.greyLight,
        ),
        SizedBox(height: spacing),
        Text(
          state.locationState.errorMessage!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MetamorfoseColors.greyMedium,
            fontFamily: 'DIN Next for Duolingo',
            fontSize: fontSize,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: spacing),
        ElevatedButton(
            onPressed: () =>
                context.read<MapBloc>().add(MapReloadLocationEvent()),
            child: const Text('Tentar Novamente')),
      ]));
    }
    if (state.locationState.position != null) {
      return Container(
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: const [
              BoxShadow(
                  color: MetamorfoseColors.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                  spreadRadius: 0)
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) => context
                    .read<MapBloc>()
                    .add(MapGoogleMapReadyEvent(controller)),
                initialCameraPosition: CameraPosition(
                    target: LatLng(state.locationState.position!.latitude,
                        state.locationState.position!.longitude),
                    zoom: 14.0),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: state.mapState.markers,
                zoomControlsEnabled: false,
              ),
              if (state.searchState.isSearching)
                Container(
                  color: MetamorfoseColors.blackNormal.withOpacity(0.3),
                  child: const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(MetamorfoseColors.whiteLight))),
                ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildListView(BuildContext context, MapState state) {
    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 64.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 48.0),
        Condition.largerThan(name: TABLET, value: 80.0),
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

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    if (state.locationState.isLoading || state.searchState.isSearching) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const CircularProgressIndicator(color: MetamorfoseColors.purpleNormal),
        SizedBox(height: spacing),
        Text(
          'Buscando floriculturas...',
          style: TextStyle(
            color: MetamorfoseColors.greyMedium,
            fontFamily: 'DIN Next for Duolingo',
            fontSize: fontSize,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ]));
    }
    final floriculturas = state.searchState.displayResults;
    if (floriculturas.isEmpty) {
      String message = 'Nenhuma floricultura encontrada próxima a você.';
      if (state.searchState.currentQuery.isNotEmpty) {
        message = 'Nenhum resultado para "${state.searchState.currentQuery}".';
      }
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.local_florist,
          size: iconSize,
          color: MetamorfoseColors.greyLight,
        ),
        SizedBox(height: spacing),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MetamorfoseColors.greyMedium,
            fontFamily: 'DIN Next for Duolingo',
            fontSize: fontSize,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ]));
    }
    return ListView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: floriculturas.length,
      itemBuilder: (context, index) {
        final floricultura = floriculturas[index];
        return _buildFloriculturaCard(context, floricultura);
      },
    );
  }

  Widget _buildFloriculturaCard(
      BuildContext context, Floricultura floricultura) {
    final margin = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final bodyFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final smallFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 14.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final statusPadding = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final statusBorderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Container(
      margin: EdgeInsets.only(bottom: margin),
      padding: EdgeInsets.all(padding),
      decoration: ShapeDecoration(
        color: MetamorfoseColors.whiteLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        shadows: const [
          BoxShadow(
              color: MetamorfoseColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
              spreadRadius: 0)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                    floricultura.nome,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: MetamorfoseColors.blackNormal,
                      fontFamily: 'DIN Next for Duolingo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: statusPadding, vertical: statusPadding / 2),
                decoration: BoxDecoration(
                    color: floricultura.isOpen
                        ? MetamorfoseColors.greenLight
                        : MetamorfoseColors.redLight,
                    borderRadius: BorderRadius.circular(statusBorderRadius)),
                child: Text(
                  floricultura.isOpen ? 'Aberto' : 'Fechado',
                  style: TextStyle(
                    fontSize: smallFontSize,
                    fontWeight: FontWeight.w600,
                    color: floricultura.isOpen
                        ? MetamorfoseColors.greenDarken
                        : MetamorfoseColors.redNormal,
                    fontFamily: 'DIN Next for Duolingo',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          Text(
            floricultura.endereco,
            style: TextStyle(
              fontSize: bodyFontSize,
              color: MetamorfoseColors.greyMedium,
              fontFamily: 'DIN Next for Duolingo',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: iconSize,
                color: MetamorfoseColors.purpleNormal,
              ),
              SizedBox(width: spacing / 2),
              Expanded(
                child: Text(
                  '${floricultura.distancia.toStringAsFixed(1)} km de distância',
                  style: TextStyle(
                    fontSize: bodyFontSize,
                    color: MetamorfoseColors.greyMedium,
                    fontFamily: 'DIN Next for Duolingo',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              Icon(
                Icons.local_florist,
                size: iconSize,
                color: MetamorfoseColors.greenNormal,
              ),
              SizedBox(width: spacing / 2),
              Expanded(
                child: Text(
                  floricultura.tiposAceitos,
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: MetamorfoseColors.greyMedium,
                    fontFamily: 'DIN Next for Duolingo',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
