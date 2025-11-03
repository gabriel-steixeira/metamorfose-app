/**
 * File: psychologist_service.dart
 * Description: Serviço responsável por gerenciar dados de psicólogos.
 *
 * Responsabilidades:
 * - Simular o carregamento de dados de psicólogos (mock local).
 * - Fornecer métodos para busca, listagem e obtenção de detalhes individuais.
 * - Servir como base para futura integração com API real ou Firestore.
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:async';

import 'package:metamorfose_flutter/models/psychologist.dart';

/// Minimal service that would fetch psychologists.
/// Replace with real API / Firestore integration when available.
class PsychologistService {
  Future<List<Psychologist>> fetchNearbyPsychologists() async {
    // simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Dados completos e realistas
    return [
      Psychologist(
        id: 'p1',
        name: 'Dra. Ana Souza',
        specialty: 'Terapia Cognitivo-Comportamental',
        phone: '+55 11 99999-9999',
        description:
            'Especialista em dependência química e transtornos de ansiedade.',
        about:
            'Psicóloga apaixonada por ajudar pessoas a superarem desafios emocionais e comportamentais. Atendo adultos e adolescentes, com foco em vícios e ansiedade.',
        addictions: ['Álcool', 'Tabaco', 'Ansiedade', 'Depressão'],
        formation: 'PUC-SP, CRP 06/123456',
        experienceYears: 12,
        methods: ['TCC', 'Mindfulness', 'Entrevista Motivacional'],
        location: 'São Paulo - SP',
        gender: 'Feminino',
        testimonial:
            'Acredito que cada pessoa tem potencial para mudar sua história. Meu papel é apoiar, acolher e guiar esse processo com empatia e técnica.',
        photoUrl: null,
      ),
      Psychologist(
        id: 'p2',
        name: 'Dr. João Pereira',
        specialty: 'Psicoterapia Infantil',
        phone: '+55 11 98888-8888',
        description:
            'Atende crianças e adolescentes, com experiência em vício em jogos e redes sociais.',
        about:
            'Meu trabalho é ajudar jovens e famílias a lidarem com desafios modernos, como vício em tecnologia, bullying e dificuldades escolares.',
        addictions: ['Jogos', 'Redes Sociais', 'Bullying'],
        formation: 'USP, CRP 06/654321',
        experienceYears: 8,
        methods: ['Ludoterapia', 'Terapia Familiar'],
        location: 'São Paulo - SP',
        gender: 'Masculino',
        testimonial:
            'A infância e adolescência são fases delicadas. O acolhimento e o diálogo são essenciais para o desenvolvimento saudável.',
        photoUrl: null,
      ),
      Psychologist(
        id: 'p3',
        name: 'Dra. Maria Lima',
        specialty: 'Psicologia Clínica',
        phone: '+55 11 97777-7777',
        description:
            'Experiência em dependência de substâncias e transtornos alimentares.',
        about:
            'Atendo adultos em busca de autoconhecimento e superação de vícios. Trabalho com intervenções breves e acompanhamento contínuo.',
        addictions: ['Álcool', 'Transtornos Alimentares', 'Tabaco'],
        formation: 'Mackenzie, CRP 06/789012',
        experienceYears: 15,
        methods: ['Psicodinâmica', 'TCC'],
        location: 'São Paulo - SP',
        gender: 'Feminino',
        testimonial:
            'A mudança é possível quando há vontade e apoio. Estou aqui para caminhar junto com você.',
        photoUrl: null,
      ),
    ];
  }

  Future<Psychologist?> getById(String id) async {
    final list = await fetchNearbyPsychologists();
    try {
      return list.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns the list sorted by best match to the keyword(s).
  /// Each keyword increases relevance if found in specialty, name, or description.
  Future<List<Psychologist>> searchAndSortByRelevance(String query) async {
    final list = await fetchNearbyPsychologists();
    if (query.trim().isEmpty) return list;
    final keywords = query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((k) => k.isNotEmpty)
        .toList();
    int score(Psychologist p) {
      int s = 0;
      for (final k in keywords) {
        if (p.specialty.toLowerCase().contains(k)) s += 3;
        if (p.name.toLowerCase().contains(k)) s += 2;
        if (p.description.toLowerCase().contains(k)) s += 1;
      }
      return -s; // negative for descending sort
    }

    final sorted = [...list]..sort((a, b) => score(a).compareTo(score(b)));
    return sorted;
  }
}
