/**
 * File: sos_service.dart
 * Description: Serviço para funcionalidades do SOS do Metamorfose
 *
 * Responsabilidades:
 * - Gerenciar contato de emergência único
 * - Controlar exercícios de respiração
 * - Integrar com WhatsApp e chamadas
 * - Gerenciar dados locais
 *
 * Author: Gabriel Teixeira
 * Created on: 19-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:metamorfose_flutter/models/sos_contact.dart';
import 'package:metamorfose_flutter/models/breathing_exercise.dart';

class SosService {
  static const String _emergencyContactKey = 'sos_emergency_contact';
  static const String _exercisesKey = 'sos_exercises';
  static const String _defaultMessage = '''Oi, [NOME]! Esse é um alerta SOS do aplicativo Metamorfose.
Estou em um momento difícil e preciso de ajuda agora.
Podemos conversar?''';

  /// Carrega contato de emergência salvo localmente
  Future<List<SosContact>> loadContacts() async {
    try {
      debugPrint('🔍 SOS Service - Carregando contatos do SharedPreferences...');
      
      final prefs = await SharedPreferences.getInstance();
      final contactJson = prefs.getString(_emergencyContactKey);
      
      debugPrint('🔍 SOS Service - JSON encontrado: ${contactJson != null ? 'sim' : 'não'}');
      
      if (contactJson != null) {
        final contact = SosContact.fromJson(jsonDecode(contactJson));
        debugPrint('🔍 SOS Service - Contato carregado: ${contact.name} (ativo: ${contact.isActive})');
        
        if (contact.isActive) {
          debugPrint('🔍 SOS Service - Retornando contato ativo');
          return [contact];
        } else {
          debugPrint('🔍 SOS Service - Contato inativo, retornando lista vazia');
          return [];
        }
      }
      
      debugPrint('🔍 SOS Service - Nenhum contato encontrado');
      return [];
    } catch (e) {
      debugPrint('🔍 SOS Service - Erro ao carregar contato: $e');
      throw Exception('Erro ao carregar contato de emergência: $e');
    }
  }

  /// Salva contato de emergência localmente
  Future<void> saveContacts(List<SosContact> contacts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (contacts.isNotEmpty) {
        final contactJson = jsonEncode(contacts.first.toJson());
        await prefs.setString(_emergencyContactKey, contactJson);
      } else {
        await prefs.remove(_emergencyContactKey);
      }
    } catch (e) {
      throw Exception('Erro ao salvar contato de emergência: $e');
    }
  }

  /// Adiciona um novo contato de emergência (substitui o anterior se existir)
  Future<void> addContact(SosContact contact) async {
    try {
      debugPrint('🔍 SOS Service - Adicionando contato: ${contact.name}');
      
      // Remove contato anterior se existir
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_emergencyContactKey);
      debugPrint('🔍 SOS Service - Contato anterior removido');
      
      // Salva o novo contato
      final contactJson = jsonEncode(contact.toJson());
      await prefs.setString(_emergencyContactKey, contactJson);
      debugPrint('🔍 SOS Service - Novo contato salvo com sucesso');
    } catch (e) {
      debugPrint('🔍 SOS Service - Erro ao adicionar contato: $e');
      throw Exception('Erro ao adicionar contato de emergência: $e');
    }
  }

  /// Remove o contato de emergência
  Future<void> removeContact(String contactId) async {
    try {
      debugPrint('🗑️ SOS Service - Removendo contato com ID: $contactId');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_emergencyContactKey);
      debugPrint('🗑️ SOS Service - Contato removido com sucesso do SharedPreferences');
    } catch (e) {
      debugPrint('🗑️ SOS Service - Erro ao remover contato: $e');
      throw Exception('Erro ao remover contato de emergência: $e');
    }
  }

  /// Atualiza o contato de emergência
  Future<void> updateContact(SosContact updatedContact) async {
    try {
      debugPrint('🔍 SOS Service - Atualizando contato: ${updatedContact.name} (ativo: ${updatedContact.isActive})');
      
      final prefs = await SharedPreferences.getInstance();
      final contactJson = jsonEncode(updatedContact.toJson());
      await prefs.setString(_emergencyContactKey, contactJson);
      
      debugPrint('🔍 SOS Service - Contato atualizado com sucesso');
    } catch (e) {
      debugPrint('🔍 SOS Service - Erro ao atualizar contato: $e');
      throw Exception('Erro ao atualizar contato de emergência: $e');
    }
  }

  /// Carrega exercícios de respiração padrão
  Future<List<BreathingExercise>> loadExercises() async {
    try {
      // Exercícios padrão pré-definidos
      return [
        const BreathingExercise(
          id: '4-7-8',
          name: 'Respiração 4-7-8',
          description: 'Técnica de respiração para relaxamento e sono',
          instructions: 'Inspire por 4 segundos, segure por 7, expire por 8',
          inhaleSeconds: 4,
          holdSeconds: 7,
          exhaleSeconds: 8,
          cycles: 4,
        ),
        const BreathingExercise(
          id: 'square',
          name: 'Respiração Quadrada',
          description: 'Técnica para equilibrar o sistema nervoso',
          instructions: 'Inspire, segure, expire e segure por tempos iguais',
          inhaleSeconds: 4,
          holdSeconds: 4,
          exhaleSeconds: 4,
          cycles: 6,
        ),
        const BreathingExercise(
          id: 'belly',
          name: 'Respiração Abdominal',
          description: 'Respiração profunda para reduzir ansiedade',
          instructions: 'Respire profundamente expandindo o abdômen',
          inhaleSeconds: 5,
          holdSeconds: 3,
          exhaleSeconds: 6,
          cycles: 5,
        ),
      ];
    } catch (e) {
      throw Exception('Erro ao carregar exercícios: $e');
    }
  }

  /// Abre WhatsApp com mensagem para contato
  Future<void> openWhatsApp(SosContact contact, {String? customMessage}) async {
    try {
      String message = customMessage ?? contact.message ?? _defaultMessage;
      
      // Substituir placeholder [NOME] pelo nome real do contato
      message = message.replaceAll('[NOME]', contact.name);
      
      // Limpar número de telefone (remover caracteres especiais)
      String cleanPhone = contact.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      
      // Formatação para WhatsApp brasileiro
      String formattedNumber;
      if (cleanPhone.startsWith('55')) {
        // Já tem código do país
        formattedNumber = cleanPhone;
      } else if (cleanPhone.length == 11) {
        // DDD + 9 dígitos (formato brasileiro)
        formattedNumber = '55$cleanPhone';
      } else if (cleanPhone.length == 10) {
        // DDD + 8 dígitos (formato antigo)
        formattedNumber = '55$cleanPhone';
      } else {
        // Formato inválido
        throw Exception('Formato de telefone inválido: ${contact.phoneNumber}');
      }
      
      debugPrint('📱 SOS Service - Abrindo WhatsApp para: ${contact.name}');
      debugPrint('📱 SOS Service - Telefone original: ${contact.phoneNumber}');
      debugPrint('📱 SOS Service - Telefone limpo: $cleanPhone');
      debugPrint('📱 SOS Service - Telefone formatado: $formattedNumber');
      debugPrint('📱 SOS Service - Mensagem: $message');
      
      // URL principal do WhatsApp (mais confiável)
      final url = 'https://wa.me/$formattedNumber?text=${Uri.encodeComponent(message)}';
      debugPrint('📱 SOS Service - URL final: $url');
      
      // Verificar se a URL pode ser aberta
      if (await canLaunchUrl(Uri.parse(url))) {
        debugPrint('📱 SOS Service - URL pode ser aberta, executando...');
        
        try {
          // Tentar abrir com modo external (abre em app externo)
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
          debugPrint('📱 SOS Service - WhatsApp aberto com sucesso (modo external)');
        } catch (e) {
          debugPrint('📱 SOS Service - Erro no modo external: $e');
          
          try {
            // Fallback: tentar modo padrão
            await launchUrl(Uri.parse(url));
            debugPrint('📱 SOS Service - WhatsApp aberto com sucesso (modo padrão)');
          } catch (e2) {
            debugPrint('📱 SOS Service - Erro no modo padrão: $e2');
            
            // Última tentativa: abrir app diretamente
            final directUrl = 'whatsapp://send?phone=$formattedNumber&text=${Uri.encodeComponent(message)}';
            debugPrint('📱 SOS Service - Tentando URL direta: $directUrl');
            
            if (await canLaunchUrl(Uri.parse(directUrl))) {
              await launchUrl(Uri.parse(directUrl));
              debugPrint('📱 SOS Service - WhatsApp aberto diretamente com sucesso');
            } else {
              throw Exception('Não foi possível abrir o WhatsApp de nenhuma forma');
            }
          }
        }
      } else {
        debugPrint('📱 SOS Service - URL não pode ser aberta: $url');
        
        // Tentar URL alternativa
        final altUrl = 'https://api.whatsapp.com/send?phone=$formattedNumber&text=${Uri.encodeComponent(message)}';
        debugPrint('📱 SOS Service - Tentando URL alternativa: $altUrl');
        
        if (await canLaunchUrl(Uri.parse(altUrl))) {
          await launchUrl(Uri.parse(altUrl), mode: LaunchMode.externalApplication);
          debugPrint('📱 SOS Service - WhatsApp aberto com URL alternativa');
        } else {
          throw Exception('Não foi possível abrir o WhatsApp. Verifique se está instalado.');
        }
      }
      
    } catch (e) {
      debugPrint('📱 SOS Service - Erro final ao abrir WhatsApp: $e');
      throw Exception('Erro ao abrir WhatsApp: $e');
    }
  }

  /// Faz chamada para contato de emergência
  Future<void> makeCall(SosContact contact) async {
    try {
      final phoneNumber = contact.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      final url = 'tel:$phoneNumber';
      
      debugPrint('📞 SOS Service - Fazendo chamada para: ${contact.name} - $phoneNumber');
      debugPrint('📞 SOS Service - URL: $url');
      
      if (await canLaunchUrl(Uri.parse(url))) {
        debugPrint('📞 SOS Service - URL pode ser aberta, executando...');
        await launchUrl(Uri.parse(url));
        debugPrint('📞 SOS Service - Chamada executada com sucesso');
      } else {
        debugPrint('📞 SOS Service - URL não pode ser aberta');
        throw Exception('Não foi possível fazer a chamada');
      }
    } catch (e) {
      debugPrint('📞 SOS Service - Erro na chamada: $e');
      throw Exception('Erro ao fazer chamada: $e');
    }
  }

  /// Envia mensagem SMS para contato
  Future<void> sendSMS(SosContact contact, {String? customMessage}) async {
    try {
      final message = customMessage ?? contact.message ?? _defaultMessage;
      final phoneNumber = contact.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      final url = 'sms:$phoneNumber?body=${Uri.encodeComponent(message)}';
      
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw Exception('Não foi possível abrir SMS');
      }
    } catch (e) {
      throw Exception('Erro ao enviar SMS: $e');
    }
  }

  /// Abre mapa com psicólogos próximos
  Future<void> openNearbyPsychologists() async {
    try {
      // Abrir Google Maps com busca por psicólogos
      const url = 'https://www.google.com/maps/search/psic%C3%B3logos+near+me';
      
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Não foi possível abrir o mapa');
      }
    } catch (e) {
      throw Exception('Erro ao abrir mapa: $e');
    }
  }

  /// Gera ID único para contatos
  String generateContactId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
