/// File: carousel_item.dart
/// Description: Componente de carousel horizontal reutilizável com suporte a itens customizados.
///
/// Responsabilidades:
/// - Exibir lista horizontal scrollável de itens (Carousel)
/// - Renderizar itens individuais com gradiente e ícones (CarouselItem)
/// - Suportar estado "Em breve" com overlay e badge
/// - Aplicar sombras e bordas arredondadas seguindo design system
/// - Permitir customização de dimensões, padding e gradientes
///
/// Author: Evelin Cordeiro
/// Created on: 19-08-2025
/// Last modified: 19-08-2025
///
/// Version: 1.0.0
/// Squad: Metamorfose
/// 
import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/typography.dart';

class Carousel extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final double height;
  final double itemExtent;
  final EdgeInsets padding;

  const Carousel({
    super.key,
    required this.title,
    required this.items,
    this.height = 200,
    this.itemExtent = 164,
    this.padding = const EdgeInsets.only(left: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: AppTypography.titleLarge.copyWith(
              color: MetamorfoseColors.whiteLight,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: padding,
            itemCount: items.length,
            itemExtent: itemExtent,
            itemBuilder: (context, index) {
              return items[index];
            },
          ),
        ),
      ],
    );
  }
}

class CarouselItem extends StatelessWidget {
  final String title;
  final String? image;
  final IconData? icon;
  final bool isComingSoon;
  final VoidCallback? onTap;
  final LinearGradient? gradient;
  final Color? shadowColor;
  final double width;
  final double height;

  const CarouselItem({
    super.key,
    required this.title,
    this.image,
    this.icon,
    this.isComingSoon = true,
    this.onTap,
    this.gradient,
    this.shadowColor,
    this.width = 180,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            _buildContainer(),
            _buildContent(),
            if (isComingSoon) _buildComingSoonOverlay(),
            if (isComingSoon) _buildComingSoonBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: gradient ?? _getDefaultGradient(),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? _getDefaultShadowColor(),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background image/pattern
            Container(
              width: double.infinity,
              height: double.infinity,
              child: _buildBackground(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              color: MetamorfoseColors.whiteLight,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        // Decorative shapes
        Positioned(
          top: -30,
          right: -30,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MetamorfoseColors.whiteLight.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          left: -20,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MetamorfoseColors.whiteLight.withOpacity(0.08),
            ),
          ),
        ),
        // Icon
        if (icon != null)
          Center(
            child: Icon(
              icon!,
              size: 60,
              color: MetamorfoseColors.whiteLight.withOpacity(0.9),
            ),
          ),
      ],
    );
  }

  Widget _buildComingSoonOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.black.withOpacity(0.4),
      ),
    );
  }

  Widget _buildComingSoonBadge() {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: MetamorfoseColors.greyDark.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: MetamorfoseColors.greyLightest.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          'EM BREVE',
          style: AppTypography.bodySmall.copyWith(
            color: MetamorfoseColors.whiteLight,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  LinearGradient _getDefaultGradient() {
    if (isComingSoon) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          MetamorfoseColors.greyLight,
          MetamorfoseColors.greyMedium,
        ],
      );
    }
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        MetamorfoseColors.purpleNormal,
        MetamorfoseColors.purpleDark,
      ],
    );
  }

  Color _getDefaultShadowColor() {
    if (isComingSoon) {
      return MetamorfoseColors.greyLight.withOpacity(0.3);
    }
    return MetamorfoseColors.purpleNormal.withOpacity(0.3);
  }
}