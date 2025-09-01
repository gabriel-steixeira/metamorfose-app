/**
 * File: avatar.dart
 * Description: Componente de avatar reutilizável com design padronizado para usuários e plantas.
 *
 * Responsabilidades:
 * - Renderizar avatares para usuários com foto de perfil ou iniciais
 * - Renderizar avatares para plantas com imagem real ou SVG
 * - Fornecer fallbacks para casos de erro ou dados ausentes
 * - Manter design responsivo e consistente
 * - Suportar diferentes tipos e tamanhos de avatar
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Last modified: 31-08-2025
*
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/utils/responsive_utils.dart';

enum AvatarType { user, plant, generic }

class Avatar extends StatelessWidget {
  final AvatarType type;
  final String? imageUrl;
  final String? svgPath;
  final String? initials;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? size;
  final IconData? fallbackIcon;

  const Avatar({
    super.key,
    required this.type,
    this.imageUrl,
    this.svgPath,
    this.initials,
    this.backgroundColor,
    this.borderColor,
    this.size,
    this.fallbackIcon,
  });

  factory Avatar.user({
    String? photoUrl,
    String? initials,
    double? size,
  }) {
    return Avatar(
      type: AvatarType.user,
      imageUrl: photoUrl,
      initials: initials,
      backgroundColor: MetamorfoseColors.purpleNormal,
      borderColor: MetamorfoseColors.purpleNormal,
      size: size,
      fallbackIcon: Icons.person,
    );
  }

  factory Avatar.plant({
    String? svgPath,
    String? plantImageUrl,
    double? size,
  }) {
    return Avatar(
      type: AvatarType.plant,
      imageUrl: plantImageUrl, // Priorizar foto real da planta
      svgPath: svgPath, // Fallback para SVG
      backgroundColor: MetamorfoseColors.greenNormal,
      borderColor: MetamorfoseColors.greenNormal,
      size: size,
      fallbackIcon: Icons.eco,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsiveSize =
        size ?? ResponsiveUtils.getResponsiveSpacing(context, 32);
    final borderWidth = ResponsiveUtils.getResponsiveSpacing(context, 2);
    final fontSize = ResponsiveUtils.getResponsiveFontSize(context, 12);

    return Container(
      width: responsiveSize,
      height: responsiveSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor?.withOpacity(0.1),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: ClipOval(
        child: _buildAvatarContent(responsiveSize, fontSize),
      ),
    );
  }

  Widget _buildAvatarContent(double size, double fontSize) {
    // Se tem imagem URL (para usuários)
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackContent(size, fontSize);
        },
      );
    }

    // Se tem SVG (para plantas)
    if (svgPath != null && svgPath!.isNotEmpty) {
      return SvgPicture.asset(
        svgPath!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    // Fallback para initials ou ícone
    return _buildFallbackContent(size, fontSize);
  }

  Widget _buildFallbackContent(double size, double fontSize) {
    // Se tem iniciais
    if (initials != null && initials!.isNotEmpty) {
      return Container(
        color: backgroundColor ?? MetamorfoseColors.greyMedium,
        child: Center(
          child: Text(
            initials!,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'DinNext',
            ),
          ),
        ),
      );
    }

    // Ícone genérico
    return Container(
      color: backgroundColor ?? MetamorfoseColors.greyMedium,
      child: Icon(
        fallbackIcon ?? Icons.person,
        size: size * 0.5,
        color: Colors.white,
      ),
    );
  }
}
