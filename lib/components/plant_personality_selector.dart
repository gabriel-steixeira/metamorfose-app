/**
 * File: personality_selector.dart
 * Description: Componente visual para seleção da personalidade do assistente.
 *
 * Responsabilidades:
 * - Exibir opções de personalidade como botões interativos
 * - Destacar a personalidade atualmente selecionada
 * - Emitir callback ao usuário selecionar uma personalidade diferente
 * - Usar enum PersonalityType para listar e identificar personalidades
 * - Aplicar cores, ícones e labels específicos para cada personalidade
 *
 * Author: Evelin Cordeiro
 * Created on: 08-08-2025
 * Last modified: 08-08-2025
 * 
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import '../services/gemini_service.dart';

/// Widget que exibe uma linha de botões para o usuário escolher a personalidade do assistente.
class PersonalitySelector extends StatelessWidget {
  /// Personalidade atualmente selecionada
  final PersonalityType currentPersonality;

  /// Callback acionado ao selecionar uma nova personalidade
  final Function(PersonalityType) onPersonalityChanged;

  /// Construtor com propriedades obrigatórias para controle da seleção
  const PersonalitySelector({
    Key? key,
    required this.currentPersonality,
    required this.onPersonalityChanged,
  }) : super(key: key);

  /// Retorna o ícone associado à personalidade
  IconData _getPersonalityIcon(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.padrao:
        return Icons.balance;
      case PersonalityType.sarcastica:
        return Icons.psychology_outlined;
      case PersonalityType.engracada:
        return Icons.sentiment_very_satisfied;
      case PersonalityType.persistente:
        return Icons.local_fire_department;
    }
  }

  /// Retorna a cor associada à personalidade
  Color _getPersonalityColor(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.padrao:
        return const Color(0xFF4CAF50);
      case PersonalityType.sarcastica:
        return const Color(0xFF9C27B0);
      case PersonalityType.engracada:
        return const Color(0xFFFF9800);
      case PersonalityType.persistente:
        return const Color(0xFFF44336);
    }
  }

  /// Extrai o texto da label da personalidade removendo emoji inicial
  String _getPersonalityLabel(PersonalityType personality) {
    return personality.label.substring(2); 
  }

  @override
  Widget build(BuildContext context) {
    final personalities = PersonalityType.values;
    
    return Container(
      height: 40,
      child: Row(
        children: personalities.asMap().entries.map((entry) {
          final index = entry.key;
          final personality = entry.value;
          final isSelected = personality == currentPersonality;
          final color = _getPersonalityColor(personality);
          final icon = _getPersonalityIcon(personality);
          final label = _getPersonalityLabel(personality);
          
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 4,
                right: index == personalities.length - 1 ? 16 : 4,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onPersonalityChanged(personality),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? color
                        : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected 
                        ? null
                        : Border.all(
                            color: Colors.grey.shade300,
                            width: 0.5,
                          ),
                      boxShadow: isSelected 
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: isSelected ? Colors.white : color,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected 
                                ? Colors.white 
                                : Colors.grey.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
