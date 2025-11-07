/**
 * File: psychologists_screen.dart
 * Description: Tela responsável por exibir, filtrar e navegar entre psicólogos disponíveis.
 *
 * Responsabilidades:
 * - Buscar psicólogos através do PsychologistService.
 * - Exibir lista filtrável e responsiva de psicólogos.
 * - Aplicar filtros por vício, método, gênero e experiência.
 * - Navegar para detalhes de cada psicólogo.
 *
 * Author: Evelin Cordeiro
 * Created on: 03-11-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:metamorfose_flutter/services/psychologist_service.dart';
import 'package:metamorfose_flutter/models/psychologist.dart';
import 'package:metamorfose_flutter/theme/typography.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PsychologistsScreen extends StatefulWidget {
  final String? from;
  const PsychologistsScreen({Key? key, this.from}) : super(key: key);

  @override
  State<PsychologistsScreen> createState() => _PsychologistsScreenState();
}

class _PsychologistsScreenState extends State<PsychologistsScreen> {
  final PsychologistService _service = PsychologistService();
  String _filter = '';
  List<Psychologist> _filtered = [];
  bool _loading = false;
  final TextEditingController _controller = TextEditingController();
  String? _selectedAddiction;
  String? _selectedMethod;
  String? _selectedGender;
  int? _minExperience;

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  void _applyFilter() async {
    setState(() => _loading = true);
    final results = await _service.searchAndSortByRelevance(_filter);
    List<Psychologist> filtered = results;
    if (_selectedAddiction != null && _selectedAddiction!.isNotEmpty) {
      filtered = filtered
          .where((p) => p.addictions.contains(_selectedAddiction))
          .toList();
    }
    if (_selectedMethod != null && _selectedMethod!.isNotEmpty) {
      filtered =
          filtered.where((p) => p.methods.contains(_selectedMethod)).toList();
    }
    if (_selectedGender != null && _selectedGender!.isNotEmpty) {
      filtered = filtered.where((p) => p.gender == _selectedGender).toList();
    }
    if (_minExperience != null) {
      filtered =
          filtered.where((p) => p.experienceYears >= _minExperience!).toList();
    }
    setState(() {
      _filtered = filtered;
      _loading = false;
    });
  }

  BoxDecoration _getCardDecoration({bool isBestMatch = false}) {
    return BoxDecoration(
      color: MetamorfoseColors.whiteLight,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isBestMatch
            ? MetamorfoseColors.greenNormal
            : MetamorfoseColors.greyLightest2,
        width: isBestMatch ? 2 : 1,
      ),
      boxShadow: const [
        BoxShadow(
          color: MetamorfoseColors.defaultButtonShadow,
          blurRadius: 0,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> allAddictions =
        _filtered.expand((p) => p.addictions).toSet().toList()..sort();
    final List<String> allMethods =
        _filtered.expand((p) => p.methods).toSet().toList()..sort();
    final List<String> allGenders =
        _filtered.map((p) => p.gender).toSet().toList()..sort();
    final maxMatch = _filtered.isNotEmpty ? _filtered.first : null;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
        Condition.largerThan(name: DESKTOP, value: 64.0),
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
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      appBar: AppBar(
        backgroundColor: MetamorfoseColors.whiteLight,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/arrow_back.svg',
            width: iconSize,
            height: iconSize,
          ),
          onPressed: () {
            if (widget.from == 'home') {
              context.go('/home');
            } else {
              context.go('/sos');
            }
          },
        ),
        title: Text(
          'Psicólogos',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barra de busca e filtros (sem card)
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                spacing,
                horizontalPadding,
                spacing * 0.5,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: MetamorfoseColors.whiteLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: MetamorfoseColors.greyLightest2,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: MetamorfoseColors.defaultButtonShadow,
                            blurRadius: 0,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 15,
                          color: MetamorfoseColors.blackLight,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Buscar por nome, especialidade...',
                          hintStyle: TextStyle(
                            fontFamily: 'DinNext',
                            fontSize: 15,
                            color: MetamorfoseColors.greyMedium,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: MetamorfoseColors.purpleNormal,
                            size: 22,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (v) {
                          _filter = v;
                          _applyFilter();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: spacing * 0.75),
                  GestureDetector(
                    onTap: () => _showFilterDialog(
                      context,
                      allAddictions,
                      allMethods,
                      allGenders,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: MetamorfoseColors.purpleNormal,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: MetamorfoseColors.purpleNormal,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: MetamorfoseColors.purpleDark,
                            blurRadius: 0,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 20,
                          ),
                          if (_hasActiveFilters()) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: MetamorfoseColors.whiteLight,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _activeFilterCount().toString(),
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: MetamorfoseColors.purpleNormal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contador de resultados
            if (_filtered.isNotEmpty && !_loading)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: spacing * 0.5,
                ),
                child: Text(
                  '${_filtered.length} ${_filtered.length == 1 ? 'psicólogo encontrado' : 'psicólogos encontrados'}',
                  style: TextStyle(
                    fontFamily: 'DinNext',
                    fontSize: 14,
                    color: MetamorfoseColors.greyMedium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Lista de psicólogos
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: MetamorfoseColors.purpleNormal,
                        ),
                      )
                    : _filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: MetamorfoseColors.purpleLight
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.search_off,
                                    size: 56,
                                    color: MetamorfoseColors.purpleLight,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Nenhum psicólogo encontrado',
                                  style: TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: MetamorfoseColors.greyMedium,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tente ajustar os filtros ou\nrealizar uma nova busca',
                                  style: TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 14,
                                    color: MetamorfoseColors.greyMedium,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        : isWide
                            ? GridView.builder(
                                padding:
                                    EdgeInsets.symmetric(vertical: spacing),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: MediaQuery.of(context)
                                              .size
                                              .width >
                                          1400
                                      ? 3
                                      : MediaQuery.of(context).size.width > 1200
                                          ? 2
                                          : 2,
                                  mainAxisSpacing: spacing,
                                  crossAxisSpacing: spacing,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width > 1200
                                          ? 4.2
                                          : 3.8,
                                ),
                                itemCount: _filtered.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final p = _filtered[index];
                                  final isBestMatch =
                                      maxMatch != null && p.id == maxMatch.id;
                                  return _psychologistCard(
                                    context,
                                    p,
                                    isBestMatch: isBestMatch,
                                  );
                                },
                              )
                            : ListView.separated(
                                padding:
                                    EdgeInsets.symmetric(vertical: spacing),
                                itemCount: _filtered.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: spacing),
                                itemBuilder: (context, index) {
                                  final p = _filtered[index];
                                  final isBestMatch =
                                      maxMatch != null && p.id == maxMatch.id;
                                  return _psychologistCard(
                                    context,
                                    p,
                                    isBestMatch: isBestMatch,
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedAddiction != null ||
        _selectedMethod != null ||
        _selectedGender != null ||
        _minExperience != null;
  }

  int _activeFilterCount() {
    return [
      _selectedAddiction,
      _selectedMethod,
      _selectedGender,
      _minExperience,
    ].where((f) => f != null).length;
  }

  void _showFilterDialog(
    BuildContext context,
    List<String> addictions,
    List<String> methods,
    List<String> genders,
  ) {
    String? tempAddiction = _selectedAddiction;
    String? tempMethod = _selectedMethod;
    String? tempGender = _selectedGender;
    int? tempExperience = _minExperience;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: MetamorfoseColors.whiteLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius * 1.5),
                    topRight: Radius.circular(borderRadius * 1.5),
                  ),
                ),
                child: Column(
                  children: [
                    // Handle
                    Container(
                      width: 48,
                      height: 5,
                      margin: const EdgeInsets.only(top: 14, bottom: 8),
                      decoration: BoxDecoration(
                        color: MetamorfoseColors.greyLight.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 16, 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MetamorfoseColors.purpleLight
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.tune,
                              color: MetamorfoseColors.purpleNormal,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Filtrar psicólogos',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.greyMedium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 26,
                              color: MetamorfoseColors.greyMedium,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        children: [
                          _buildFilterSection(
                            'Especialidades em vícios',
                            addictions,
                            tempAddiction,
                            (value) =>
                                setModalState(() => tempAddiction = value),
                            borderRadius,
                          ),
                          const SizedBox(height: 28),
                          _buildFilterSection(
                            'Métodos de atendimento',
                            methods,
                            tempMethod,
                            (value) => setModalState(() => tempMethod = value),
                            borderRadius,
                          ),
                          const SizedBox(height: 28),
                          _buildFilterSection(
                            'Gênero do profissional',
                            genders,
                            tempGender,
                            (value) => setModalState(() => tempGender = value),
                            borderRadius,
                          ),
                          const SizedBox(height: 28),
                          _buildExperienceSection(
                            tempExperience,
                            (value) =>
                                setModalState(() => tempExperience = value),
                            borderRadius,
                          ),
                        ],
                      ),
                    ),

                    // Footer
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: MetamorfoseColors.whiteLight,
                        border: Border(
                          top: BorderSide(
                            color: MetamorfoseColors.greyLightest2,
                            width: 1,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  tempAddiction = null;
                                  tempMethod = null;
                                  tempGender = null;
                                  tempExperience = null;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: MetamorfoseColors.whiteLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: MetamorfoseColors.greyLightest2,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Limpar',
                                    style: TextStyle(
                                      fontFamily: 'DinNext',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: MetamorfoseColors.greyMedium,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedAddiction = tempAddiction;
                                  _selectedMethod = tempMethod;
                                  _selectedGender = tempGender;
                                  _minExperience = tempExperience;
                                });
                                _applyFilter();
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: MetamorfoseColors.purpleNormal,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: MetamorfoseColors.purpleNormal,
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: MetamorfoseColors.purpleDark,
                                      blurRadius: 0,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Aplicar filtros',
                                    style: TextStyle(
                                      fontFamily: 'DinNext',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String? selected,
    Function(String?) onSelect,
    double borderRadius,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selected == option;
            return GestureDetector(
              onTap: () => onSelect(isSelected ? null : option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? MetamorfoseColors.purpleNormal
                      : MetamorfoseColors.whiteLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? MetamorfoseColors.purpleNormal
                        : MetamorfoseColors.greyLightest2,
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                MetamorfoseColors.purpleLight.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontFamily: 'DinNext',
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : MetamorfoseColors.greyMedium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExperienceSection(
    int? selected,
    Function(int?) onSelect,
    double borderRadius,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experiência mínima',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [1, 3, 5, 10].map((years) {
            final isSelected = selected == years;
            return GestureDetector(
              onTap: () => onSelect(isSelected ? null : years),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? MetamorfoseColors.purpleNormal
                      : MetamorfoseColors.whiteLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? MetamorfoseColors.purpleNormal
                        : MetamorfoseColors.greyLightest2,
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                MetamorfoseColors.purpleLight.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  '$years+ anos',
                  style: TextStyle(
                    fontFamily: 'DinNext',
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : MetamorfoseColors.greyMedium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _psychologistCard(
    BuildContext context,
    Psychologist p, {
    bool isBestMatch = false,
  }) {
    return GestureDetector(
      onTap: () =>
          context.go('/psychologists/${p.id}?from=${widget.from ?? "sos"}'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: _getCardDecoration(isBestMatch: isBestMatch),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: isBestMatch
                        ? [
                            BoxShadow(
                              color: MetamorfoseColors.greenNormal
                                  .withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        MetamorfoseColors.purpleLight.withOpacity(0.15),
                    backgroundImage:
                        p.photoUrl != null ? NetworkImage(p.photoUrl!) : null,
                    child: p.photoUrl == null
                        ? Icon(
                            Icons.person,
                            color: MetamorfoseColors.purpleNormal,
                            size: 32,
                          )
                        : null,
                  ),
                ),
                if (isBestMatch)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MetamorfoseColors.greenNormal,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.stars,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          style: TextStyle(
                            fontFamily: 'DinNext',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MetamorfoseColors.blackLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isBestMatch)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                MetamorfoseColors.greenNormal.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: MetamorfoseColors.greenNormal
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 12,
                                color: MetamorfoseColors.greenNormal,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Top Match',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: MetamorfoseColors.greenNormal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.specialty,
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: MetamorfoseColors.purpleNormal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: MetamorfoseColors.greyMedium,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          p.location,
                          style: TextStyle(
                            fontFamily: 'DinNext',
                            fontSize: 13,
                            color: MetamorfoseColors.greyMedium,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: p.addictions.take(3).map((a) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              MetamorfoseColors.purpleLight.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                MetamorfoseColors.purpleLight.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          a,
                          style: TextStyle(
                            fontFamily: 'DinNext',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: MetamorfoseColors.purpleNormal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MetamorfoseColors.purpleLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: MetamorfoseColors.purpleNormal,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
