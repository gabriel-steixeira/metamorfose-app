import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

enum ChatMode {
  voice,
  text,
}

class ModeSwitcher extends StatelessWidget {
  final ChatMode currentMode;
  final Function(ChatMode) onModeChanged;

  const ModeSwitcher({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: MetamorfoseColors.greenLight.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: MetamorfoseColors.greenLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(
            mode: ChatMode.voice,
            icon: Icons.mic,
            label: 'Voz',
            isActive: currentMode == ChatMode.voice,
          ),
          _buildModeButton(
            mode: ChatMode.text,
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            isActive: currentMode == ChatMode.text,
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required ChatMode mode,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onModeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? MetamorfoseColors.greenLight : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: isActive 
              ? Border.all(
                  color: MetamorfoseColors.greenNormal,
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? MetamorfoseColors.whiteLight : MetamorfoseColors.greyMedium,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'DinNext',
                color: isActive ? MetamorfoseColors.whiteLight : MetamorfoseColors.greyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
