/**
 * File: map_screen_bloc.dart
 * Description: Tela de mapa com BLoC implementada.
 *
 * Responsabilidades:
 * - Exibir mapa com floriculturas próximas usando BLoC
 * - Listar floriculturas em formato de lista
 * - Interface de busca reativa
 * - Gerenciar localização do usuário via BLoC
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metamorfose_flutter/blocs/map_bloc.dart';
import 'package:metamorfose_flutter/state/map/map_state.dart';
import 'package:metamorfose_flutter/services/map_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/services/map_service.dart'; // Import MapService para usar Floricultura

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
    
    // Opcional: listener para limpar o ícone de 'clear' quando o texto for apagado
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
        if (state.locationState.hasError && state.locationState.shouldShowError) {
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
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('Floriculturas Próximas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MetamorfoseColors.blackNormal, fontFamily: 'DIN Next for Duolingo')),
          const SizedBox(height: 16),
          Container(
            height: 56,
            decoration: ShapeDecoration(
              color: MetamorfoseColors.whiteLight,
              shape: RoundedRectangleBorder(side: const BorderSide(width: 1, color: MetamorfoseColors.whiteDark), borderRadius: BorderRadius.circular(16)),
              shadows: const [BoxShadow(color: MetamorfoseColors.shadowLight, blurRadius: 8, offset: Offset(0, 2), spreadRadius: 0)],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.read<MapBloc>().add(MapSearchWithQueryEvent(value.trim()));
                }
              },
              decoration: InputDecoration(
                hintText: 'Buscar floricultura...',
                hintStyle: const TextStyle(color: MetamorfoseColors.greyLight, fontSize: 16, fontFamily: 'DIN Next for Duolingo', fontWeight: FontWeight.w400),
                prefixIcon: const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.search, color: MetamorfoseColors.purpleNormal, size: 22)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: MetamorfoseColors.greyMedium, size: 22),
                        onPressed: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                          context.read<MapBloc>().add(MapClearSearchEvent());
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, MapState state) {
    return Container(
      width: double.infinity,
      height: 43,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(color: MetamorfoseColors.greyLightest2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      child: Row(
        children: [
          _buildTabItem(context, 'Mapa', MapTabIndex.map, state.selectedTab),
          const SizedBox(width: 4),
          _buildTabItem(context, 'Lista', MapTabIndex.list, state.selectedTab),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String title, MapTabIndex tabIndex, MapTabIndex selectedTab) {
    final isSelected = tabIndex == selectedTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<MapBloc>().add(MapChangeTabEvent(tabIndex)),
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: isSelected
              ? ShapeDecoration(
                  color: MetamorfoseColors.whiteLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  shadows: const [BoxShadow(color: MetamorfoseColors.shadowLight, blurRadius: 2, offset: Offset(0, 1), spreadRadius: 0)],
                )
              : null,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? MetamorfoseColors.greyMedium : MetamorfoseColors.greyLight,
                fontSize: 16,
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
    if (state.locationState.isLoading) {
      return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(color: MetamorfoseColors.purpleNormal), SizedBox(height: 16), Text('Obtendo sua localização...', style: TextStyle(color: MetamorfoseColors.greyMedium, fontFamily: 'DIN Next for Duolingo'))]));
    }
    if (state.locationState.hasError) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.location_off, size: 64, color: MetamorfoseColors.greyLight),
        const SizedBox(height: 16),
        Text(state.locationState.errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: MetamorfoseColors.greyMedium, fontFamily: 'DIN Next for Duolingo')),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () => context.read<MapBloc>().add(MapReloadLocationEvent()), child: const Text('Tentar Novamente')),
      ]));
    }
    if (state.locationState.position != null) {
      return Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: MetamorfoseColors.shadowLight, blurRadius: 8, offset: Offset(0, 2), spreadRadius: 0)]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) => context.read<MapBloc>().add(MapGoogleMapReadyEvent(controller)),
                initialCameraPosition: CameraPosition(target: LatLng(state.locationState.position!.latitude, state.locationState.position!.longitude), zoom: 14.0),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: state.mapState.markers,
                zoomControlsEnabled: false,
              ),
              if (state.searchState.isSearching)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
                ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildListView(BuildContext context, MapState state) {
    if (state.locationState.isLoading || state.searchState.isSearching) {
      return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(color: MetamorfoseColors.purpleNormal), SizedBox(height: 16), Text('Buscando floriculturas...', style: TextStyle(color: MetamorfoseColors.greyMedium, fontFamily: 'DIN Next for Duolingo'))]));
    }
    final floriculturas = state.searchState.displayResults;
    if (floriculturas.isEmpty) {
      String message = 'Nenhuma floricultura encontrada próxima a você.';
      if (state.searchState.currentQuery.isNotEmpty) {
        message = 'Nenhum resultado para "${state.searchState.currentQuery}".';
      }
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.local_florist, size: 64, color: MetamorfoseColors.greyLight),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(color: MetamorfoseColors.greyMedium, fontFamily: 'DIN Next for Duolingo')),
      ]));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: floriculturas.length,
      itemBuilder: (context, index) {
        final floricultura = floriculturas[index];
        return _buildFloriculturaCard(context, floricultura);
      },
    );
  }

  Widget _buildFloriculturaCard(BuildContext context, Floricultura floricultura) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: MetamorfoseColors.whiteLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadows: const [BoxShadow(color: MetamorfoseColors.shadowLight, blurRadius: 8, offset: Offset(0, 2), spreadRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(floricultura.nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MetamorfoseColors.blackNormal, fontFamily: 'DIN Next for Duolingo'))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: floricultura.isOpen ? MetamorfoseColors.greenLight : MetamorfoseColors.redLight, borderRadius: BorderRadius.circular(12)),
                child: Text(floricultura.isOpen ? 'Aberto' : 'Fechado', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: floricultura.isOpen ? MetamorfoseColors.greenDarken : MetamorfoseColors.redNormal, fontFamily: 'DIN Next for Duolingo')),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(floricultura.endereco, style: const TextStyle(fontSize: 14, color: MetamorfoseColors.greyMedium, fontFamily: 'DIN Next for Duolingo')),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: MetamorfoseColors.purpleNormal),
              const SizedBox(width: 4),
              Text('${floricultura.distancia.toStringAsFixed(1)} km de distância', style: const TextStyle(fontSize: 14, color: MetamorfoseColors.greyMedium, fontFamily: 'DIN Next for Duolingo')),
              const Spacer(),
              const Icon(Icons.local_florist, size: 16, color: MetamorfoseColors.greenNormal),
              const SizedBox(width: 4),
              Text(floricultura.tiposAceitos, style: const TextStyle(fontSize: 12, color: MetamorfoseColors.greyMedium, fontFamily: 'DIN Next for Duolingo')),
            ],
          ),
        ],
      ),
    );
  }
} 