/**
 * File: chat_bubble.dart
 * Description: Componente de bubble de chat reutilizável com design padronizado para mensagens de usuário e IA.
 *
 * Responsabilidades:
 * - Renderizar bubbles de chat para mensagens de usuário e IA
 * - Manter design responsivo e consistente com cores diferenciadas
 * - Suportar avatares opcionais para identificação visual
 * - Adaptar layout baseado no tipo de mensagem (usuário vs IA)
 * - Fornecer customização de cores e estilos
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Last modified: 31-08-2025
 * 
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/utils/responsive_utils.dart';
import 'package:metamorfose_flutter/models/chat_message.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Widget? avatar;
  final Color? bubbleColor;
  final Color? textColor;

  const ChatBubble({
    super.key,
    required this.message,
    this.avatar,
    this.bubbleColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    
    // Valores responsivos usando responsive_framework
    final responsivePadding = rf.ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        rf.Condition.smallerThan(name: rf.MOBILE, value: 12.0),
        rf.Condition.largerThan(name: rf.TABLET, value: 20.0),
      ],
    ).value;

    final responsiveFontSize = rf.ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        rf.Condition.smallerThan(name: rf.MOBILE, value: 14.0),
        rf.Condition.largerThan(name: rf.TABLET, value: 18.0),
      ],
    ).value;

    final responsiveBorderRadius = rf.ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        rf.Condition.smallerThan(name: rf.MOBILE, value: 12.0),
        rf.Condition.largerThan(name: rf.TABLET, value: 20.0),
      ],
    ).value;

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = rf.ResponsiveBreakpoints.of(context).isMobile;

    // Calcular largura máxima do bubble baseada no dispositivo
    final bubbleMaxWidth = isMobile ? screenWidth * 0.8 : screenWidth * 0.6;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: rf.ResponsiveValue<double>(
            context,
            defaultValue: 12.0,
            conditionalValues: [
              rf.Condition.smallerThan(name: rf.MOBILE, value: 8.0),
              rf.Condition.largerThan(name: rf.TABLET, value: 16.0),
            ],
          ).value,
        ),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Avatar para mensagens da IA
            if (!isUser && avatar != null) ...[
              avatar!,
              SizedBox(width: rf.ResponsiveValue<double>(
                context,
                defaultValue: 8.0,
                conditionalValues: [
                  rf.Condition.smallerThan(name: rf.MOBILE, value: 6.0),
                  rf.Condition.largerThan(name: rf.TABLET, value: 12.0),
                ],
              ).value),
            ],

            // Bubble de mensagem
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
                padding: EdgeInsets.all(responsivePadding * 0.75),
                decoration: BoxDecoration(
                  color: bubbleColor ??
                      (isUser
                          ? MetamorfoseColors.purpleNormal
                          : MetamorfoseColors.greyExtraLight),
                  borderRadius:
                      BorderRadius.circular(responsiveBorderRadius).copyWith(
                    bottomRight: isUser ? const Radius.circular(4) : null,
                    bottomLeft: !isUser ? const Radius.circular(4) : null,
                  ),
                ),
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: textColor ??
                        (isUser ? Colors.white : MetamorfoseColors.greyMedium),
                    fontSize: responsiveFontSize,
                    fontFamily: 'DinNext',
                  ),
                ),
              ),
            ),

            // Avatar para mensagens do usuário
            if (isUser && avatar != null) ...[
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
              avatar!,
            ],
          ],
        ),
      ),
    );
  }
}
