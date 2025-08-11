import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:conversao_flutter/models/user_memory.dart';

/// Resultado de operação de memória
class MemoryResult {
  final bool success;
  final String? error;
  final List<UserMemory>? memories;

  const MemoryResult({
    required this.success,
    this.error,
    this.memories,
  });

  factory MemoryResult.success([List<UserMemory>? memories]) {
    return MemoryResult(
      success: true,
      memories: memories,
    );
  }

  factory MemoryResult.error(String error) {
    return MemoryResult(
      success: false,
      error: error,
    );
  }
}

/// Serviço para gerenciamento de memória do usuário
/// Combina armazenamento local e na nuvem para persistência
class MemoryService {
  static const String _localStorageKey = 'user_memories';
  static const String _lastSyncKey = 'last_memory_sync';
  static const String _userIdKey = 'current_user_id';
  
  // Configuração da API de memória na nuvem
  static const String _cloudApiUrl = 'https://api.metamorfose.app/memories'; // Exemplo
  static const String _cloudApiKey = 'YOUR_CLOUD_API_KEY'; // Configurar
  
  final Dio _dio = Dio();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Cache local para performance
  List<UserMemory> _localMemories = [];
  String? _currentUserId;

  /// Inicializa o serviço
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      print('[MemoryService] Inicializando...');
      
      _prefs = await SharedPreferences.getInstance();
      _currentUserId = _prefs.getString(_userIdKey);
      
      // Carrega memórias locais
      await _loadLocalMemories();
      
      // Sincroniza com a nuvem se houver usuário
      if (_currentUserId != null) {
        await _syncWithCloud();
      }
      
      _isInitialized = true;
      print('[MemoryService] Inicializado com sucesso');
      return true;
    } catch (e) {
      print('[MemoryService] Erro na inicialização: $e');
      return false;
    }
  }

  /// Define o usuário atual
  Future<void> setCurrentUser(String userId) async {
    _currentUserId = userId;
    await _prefs.setString(_userIdKey, userId);
    
    // Sincroniza memórias do usuário
    await _syncWithCloud();
  }

  /// Adiciona uma nova memória
  Future<MemoryResult> addMemory({
    required String category,
    required String key,
    required String value,
    String? description,
    double importance = 0.5,
    Map<String, dynamic>? metadata,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        return MemoryResult.error('Serviço não inicializado');
      }
    }

    if (_currentUserId == null) {
      return MemoryResult.error('Usuário não definido');
    }

    try {
      // Cria nova memória
      final memory = UserMemory.create(
        userId: _currentUserId!,
        category: category,
        key: key,
        value: value,
        description: description,
        importance: importance,
        metadata: metadata,
      );

      // Adiciona ao cache local
      _localMemories.add(memory);
      
      // Salva localmente
      await _saveLocalMemories();
      
      // Sincroniza com a nuvem
      await _saveToCloud(memory);
      
      print('[MemoryService] Memória adicionada: ${memory.key} = ${memory.value}');
      return MemoryResult.success();
    } catch (e) {
      print('[MemoryService] Erro ao adicionar memória: $e');
      return MemoryResult.error('Erro ao adicionar memória: $e');
    }
  }

  /// Busca memórias por categoria
  Future<MemoryResult> getMemoriesByCategory(String category) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        return MemoryResult.error('Serviço não inicializado');
      }
    }

    try {
      final memories = _localMemories
          .where((m) => m.category == category)
          .toList();
      
      // Atualiza contador de acesso
      for (var memory in memories) {
        final index = _localMemories.indexOf(memory);
        if (index != -1) {
          _localMemories[index] = memory.updateAccess();
        }
      }
      
      await _saveLocalMemories();
      
      return MemoryResult.success(memories);
    } catch (e) {
      return MemoryResult.error('Erro ao buscar memórias: $e');
    }
  }

  /// Busca memória específica por chave
  Future<UserMemory?> getMemory(String category, String key) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return null;
    }

    try {
      final memory = _localMemories
          .where((m) => m.category == category && m.key == key)
          .firstOrNull;
      
      if (memory != null) {
        // Atualiza contador de acesso
        final index = _localMemories.indexOf(memory);
        _localMemories[index] = memory.updateAccess();
        await _saveLocalMemories();
      }
      
      return memory;
    } catch (e) {
      print('[MemoryService] Erro ao buscar memória: $e');
      return null;
    }
  }

  /// Atualiza uma memória existente
  Future<MemoryResult> updateMemory({
    required String category,
    required String key,
    required String newValue,
    String? newDescription,
    double? newImportance,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        return MemoryResult.error('Serviço não inicializado');
      }
    }

    try {
      final index = _localMemories.indexWhere(
        (m) => m.category == category && m.key == key,
      );

      if (index == -1) {
        return MemoryResult.error('Memória não encontrada');
      }

      var memory = _localMemories[index];
      memory = memory.updateValue(newValue, newDescription: newDescription);
      
      if (newImportance != null) {
        memory = memory.updateImportance(newImportance);
      }

      _localMemories[index] = memory;
      await _saveLocalMemories();
      
      // Sincroniza com a nuvem
      await _updateInCloud(memory);
      
      return MemoryResult.success();
    } catch (e) {
      return MemoryResult.error('Erro ao atualizar memória: $e');
    }
  }

  /// Remove uma memória
  Future<MemoryResult> removeMemory(String category, String key) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        return MemoryResult.error('Serviço não inicializado');
      }
    }

    try {
      _localMemories.removeWhere(
        (m) => m.category == category && m.key == key,
      );
      
      await _saveLocalMemories();
      
      // Remove da nuvem
      await _removeFromCloud(category, key);
      
      return MemoryResult.success();
    } catch (e) {
      return MemoryResult.error('Erro ao remover memória: $e');
    }
  }

  /// Busca memórias relevantes para um contexto
  Future<List<UserMemory>> getRelevantMemories({
    required String context,
    int limit = 10,
    double minImportance = 0.3,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return [];
    }

    try {
      // Filtra por importância mínima
      var relevant = _localMemories
          .where((m) => m.importance >= minImportance)
          .toList();

      // Ordena por relevância (importância + acesso recente + frequência de acesso)
      relevant.sort((a, b) {
        final aScore = _calculateRelevanceScore(a, context);
        final bScore = _calculateRelevanceScore(b, context);
        return bScore.compareTo(aScore);
      });

      return relevant.take(limit).toList();
    } catch (e) {
      print('[MemoryService] Erro ao buscar memórias relevantes: $e');
      return [];
    }
  }

  /// Calcula score de relevância para uma memória
  double _calculateRelevanceScore(UserMemory memory, String context) {
    double score = memory.importance;
    
    // Bônus por acesso recente
    final daysSinceLastAccess = DateTime.now().difference(memory.lastAccessed).inDays;
    if (daysSinceLastAccess < 7) score += 0.2;
    else if (daysSinceLastAccess < 30) score += 0.1;
    
    // Bônus por frequência de acesso
    if (memory.accessCount > 10) score += 0.1;
    else if (memory.accessCount > 5) score += 0.05;
    
    // Bônus por relevância contextual (palavras-chave)
    final contextLower = context.toLowerCase();
    final valueLower = memory.value.toLowerCase();
    final keyLower = memory.key.toLowerCase();
    
    if (contextLower.contains(keyLower) || keyLower.contains(contextLower)) {
      score += 0.3;
    }
    
    if (contextLower.contains(valueLower) || valueLower.contains(contextLower)) {
      score += 0.2;
    }
    
    return score.clamp(0.0, 1.0);
  }

  /// Gera contexto de memória para a IA
  Future<String> generateMemoryContext(String userMessage) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return '';
    }

    try {
      final relevantMemories = await getRelevantMemories(
        context: userMessage,
        limit: 5,
        minImportance: 0.4,
      );

      if (relevantMemories.isEmpty) return '';

      String context = '\n\nINFORMAÇÕES IMPORTANTES SOBRE O USUÁRIO:\n';
      
      for (var memory in relevantMemories) {
        context += '• ${memory.category.replaceAll('_', ' ').toUpperCase()}: ';
        context += '${memory.key.replaceAll('_', ' ')} = ${memory.value}\n';
        
        if (memory.description != null) {
          context += '  (${memory.description})\n';
        }
      }

      return context;
    } catch (e) {
      print('[MemoryService] Erro ao gerar contexto: $e');
      return '';
    }
  }

  /// Extrai informações importantes da mensagem do usuário
  Future<void> extractAndStoreInfo(String userMessage, String aiResponse) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    try {
      // Lista de padrões para extrair informações
      final patterns = [
        // Nome
        RegExp(r'meu nome (?:é|sou) ([A-Za-zÀ-ÿ\s]+)', caseSensitive: false),
        RegExp(r'chamo-me ([A-Za-zÀ-ÿ\s]+)', caseSensitive: false),
        RegExp(r'sou o ([A-Za-zÀ-ÿ\s]+)', caseSensitive: false),
        
        // Idade
        RegExp(r'tenho (\d+) anos?', caseSensitive: false),
        RegExp(r'sou (\d+) anos?', caseSensitive: false),
        
        // Vício
        RegExp(r'meu vício (?:é|são) ([^.!?]+)', caseSensitive: false),
        RegExp(r'sou viciado em ([^.!?]+)', caseSensitive: false),
        RegExp(r'tenho problema com ([^.!?]+)', caseSensitive: false),
        
        // Metas
        RegExp(r'quero ([^.!?]+)', caseSensitive: false),
        RegExp(r'minha meta (?:é|são) ([^.!?]+)', caseSensitive: false),
        RegExp(r'pretendo ([^.!?]+)', caseSensitive: false),
        
        // Gatilhos
        RegExp(r'quando ([^.!?]+) eu ([^.!?]+)', caseSensitive: false),
        RegExp(r'me sinto tentado quando ([^.!?]+)', caseSensitive: false),
      ];

      for (var pattern in patterns) {
        final match = pattern.firstMatch(userMessage);
        if (match != null) {
          final value = match.group(1)?.trim();
          if (value != null && value.isNotEmpty) {
            await _extractAndStore(match, value, userMessage);
          }
        }
      }
    } catch (e) {
      print('[MemoryService] Erro ao extrair informações: $e');
    }
  }

  /// Extrai e armazena informação específica
  Future<void> _extractAndStore(RegExpMatch match, String value, String context) async {
    try {
      String category = 'personal_info';
      String key = 'extracted_info';
      double importance = 0.6;

      // Determina categoria e chave baseado no padrão
      if (match.pattern.toString().contains('nome')) {
        category = 'personal_info';
        key = 'name';
        importance = 0.9;
      } else if (match.pattern.toString().contains('anos')) {
        category = 'personal_info';
        key = 'age';
        importance = 0.7;
      } else if (match.pattern.toString().contains('vício')) {
        category = 'addiction_info';
        key = 'addiction_type';
        importance = 0.9;
      } else if (match.pattern.toString().contains('quero') || match.pattern.toString().contains('meta')) {
        category = 'goals';
        key = 'current_goal';
        importance = 0.8;
      } else if (match.pattern.toString().contains('quando') || match.pattern.toString().contains('tentado')) {
        category = 'triggers';
        key = 'current_trigger';
        importance = 0.8;
      }

      // Verifica se já existe uma memória similar
      final existing = await getMemory(category, key);
      if (existing == null || existing.value != value) {
        await addMemory(
          category: category,
          key: key,
          value: value,
          description: 'Extraído de: "$context"',
          importance: importance,
        );
      }
    } catch (e) {
      print('[MemoryService] Erro ao armazenar informação extraída: $e');
    }
  }

  // ===== PERSISTÊNCIA LOCAL =====

  /// Carrega memórias do armazenamento local
  Future<void> _loadLocalMemories() async {
    try {
      final memoriesJson = _prefs.getStringList(_localStorageKey) ?? [];
      _localMemories = memoriesJson
          .map((json) => UserMemory.fromMap(jsonDecode(json)))
          .toList();
      
      print('[MemoryService] ${_localMemories.length} memórias carregadas localmente');
    } catch (e) {
      print('[MemoryService] Erro ao carregar memórias locais: $e');
      _localMemories = [];
    }
  }

  /// Salva memórias no armazenamento local
  Future<void> _saveLocalMemories() async {
    try {
      final memoriesJson = _localMemories
          .map((memory) => jsonEncode(memory.toMap()))
          .toList();
      
      await _prefs.setStringList(_localStorageKey, memoriesJson);
      await _prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      print('[MemoryService] Erro ao salvar memórias locais: $e');
    }
  }

  // ===== SINCRONIZAÇÃO COM NUVEM =====

  /// Sincroniza com a nuvem
  Future<void> _syncWithCloud() async {
    if (_currentUserId == null) return;

    try {
      print('[MemoryService] Sincronizando com a nuvem...');
      
      // Busca memórias da nuvem
      final cloudMemories = await _fetchFromCloud();
      
      // Mescla com memórias locais
      for (var cloudMemory in cloudMemories) {
        final localIndex = _localMemories.indexWhere((m) => m.id == cloudMemory.id);
        
        if (localIndex == -1) {
          // Nova memória da nuvem
          _localMemories.add(cloudMemory);
        } else {
          // Atualiza se a da nuvem for mais recente
          if (cloudMemory.lastAccessed.isAfter(_localMemories[localIndex].lastAccessed)) {
            _localMemories[localIndex] = cloudMemory;
          }
        }
      }
      
      await _saveLocalMemories();
      print('[MemoryService] Sincronização concluída');
    } catch (e) {
      print('[MemoryService] Erro na sincronização: $e');
    }
  }

  /// Busca memórias da nuvem
  Future<List<UserMemory>> _fetchFromCloud() async {
    try {
      final response = await _dio.get(
        '$_cloudApiUrl/user/$_currentUserId',
        options: Options(
          headers: {'Authorization': 'Bearer $_cloudApiKey'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['memories'] ?? [];
        return data.map((json) => UserMemory.fromMap(json)).toList();
      }
    } catch (e) {
      print('[MemoryService] Erro ao buscar da nuvem: $e');
    }
    
    return [];
  }

  /// Salva memória na nuvem
  Future<void> _saveToCloud(UserMemory memory) async {
    try {
      await _dio.post(
        _cloudApiUrl,
        data: memory.toMap(),
        options: Options(
          headers: {'Authorization': 'Bearer $_cloudApiKey'},
        ),
      );
    } catch (e) {
      print('[MemoryService] Erro ao salvar na nuvem: $e');
    }
  }

  /// Atualiza memória na nuvem
  Future<void> _updateInCloud(UserMemory memory) async {
    try {
      await _dio.put(
        '$_cloudApiUrl/${memory.id}',
        data: memory.toMap(),
        options: Options(
          headers: {'Authorization': 'Bearer $_cloudApiKey'},
        ),
      );
    } catch (e) {
      print('[MemoryService] Erro ao atualizar na nuvem: $e');
    }
  }

  /// Remove memória da nuvem
  Future<void> _removeFromCloud(String category, String key) async {
    try {
      final memory = _localMemories
          .where((m) => m.category == category && m.key == key)
          .firstOrNull;
      
      if (memory != null) {
        await _dio.delete(
          '$_cloudApiUrl/${memory.id}',
          options: Options(
            headers: {'Authorization': 'Bearer $_cloudApiKey'},
          ),
        );
      }
    } catch (e) {
      print('[MemoryService] Erro ao remover da nuvem: $e');
    }
  }

  // ===== BACKUP E RESTORE =====

  /// Exporta memórias para backup
  Future<String> exportMemories() async {
    try {
      final exportData = {
        'userId': _currentUserId,
        'exportDate': DateTime.now().toIso8601String(),
        'memories': _localMemories.map((m) => m.toMap()).toList(),
      };
      
      return jsonEncode(exportData);
    } catch (e) {
      print('[MemoryService] Erro ao exportar memórias: $e');
      return '';
    }
  }

  /// Importa memórias de backup
  Future<MemoryResult> importMemories(String backupData) async {
    try {
      final data = jsonDecode(backupData);
      final memories = (data['memories'] as List)
          .map((json) => UserMemory.fromMap(json))
          .toList();
      
      _localMemories.addAll(memories);
      await _saveLocalMemories();
      
      // Sincroniza com a nuvem
      for (var memory in memories) {
        await _saveToCloud(memory);
      }
      
      return MemoryResult.success();
    } catch (e) {
      return MemoryResult.error('Erro ao importar memórias: $e');
    }
  }

  /// Limpa todas as memórias
  Future<void> clearAllMemories() async {
    _localMemories.clear();
    await _saveLocalMemories();
    
    if (_currentUserId != null) {
      try {
        await _dio.delete(
          '$_cloudApiUrl/user/$_currentUserId',
          options: Options(
            headers: {'Authorization': 'Bearer $_cloudApiKey'},
          ),
        );
      } catch (e) {
        print('[MemoryService] Erro ao limpar da nuvem: $e');
      }
    }
  }
} 