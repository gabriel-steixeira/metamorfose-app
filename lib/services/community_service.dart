/**
 * File: community_service.dart
 * Description: Serviço para gerenciamento de dados da comunidade
 *
 * Responsabilidades:
 * - Carregar posts da comunidade
 * - Carregar lista de amigos
 * - Gerenciar interações sociais
 *
 * Author: Evelin Cordeiro
 * Created on: 06-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

/// Serviço para gerenciamento de dados da comunidade
class CommunityService {
  /// Carrega posts da comunidade
  /// Por enquanto retorna lista vazia para simular "sem posts"
  Future<List<dynamic>> loadPosts() async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1000));

    // Retorna lista vazia para simular que não há posts
    return [];
  }

  /// Carrega lista de amigos
  /// Por enquanto retorna lista vazia para simular "sem amigos"
  Future<List<dynamic>> loadFriends() async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1000));

    // Retorna lista vazia para simular que não há amigos
    return [];
  }

  /// Compartilha um post com a comunidade
  Future<bool> sharePost(Map<String, dynamic> postData) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1500));

    // Simular sucesso
    return true;
  }
}
