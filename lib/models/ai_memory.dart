/// Modelo para representar memória da IA
class AIMemory {
  final String id;
  final String userId;
  final String category;
  final String key;
  final String value;
  final String? description;
  final DateTime createdAt;
  final DateTime lastAccessed;
  final int accessCount;
  final double importance;
  final Map<String, dynamic>? metadata;
  final String? context;
  final String? sentiment;

  AIMemory({
    required this.id,
    required this.userId,
    required this.category,
    required this.key,
    required this.value,
    this.description,
    required this.createdAt,
    required this.lastAccessed,
    required this.accessCount,
    required this.importance,
    this.metadata,
    this.context,
    this.sentiment,
  });

  /// Cria uma nova memória
  factory AIMemory.create({
    required String userId,
    required String category,
    required String key,
    required String value,
    String? description,
    double importance = 0.5,
    Map<String, dynamic>? metadata,
    String? context,
    String? sentiment,
  }) {
    final now = DateTime.now();
    return AIMemory(
      id: '${now.millisecondsSinceEpoch}_${key.hashCode}',
      userId: userId,
      category: category,
      key: key,
      value: value,
      description: description,
      createdAt: now,
      lastAccessed: now,
      accessCount: 1,
      importance: importance.clamp(0.0, 1.0),
      metadata: metadata,
      context: context,
      sentiment: sentiment,
    );
  }

  /// Atualiza o acesso à memória
  AIMemory updateAccess() {
    return AIMemory(
      id: id,
      userId: userId,
      category: category,
      key: key,
      value: value,
      description: description,
      createdAt: createdAt,
      lastAccessed: DateTime.now(),
      accessCount: accessCount + 1,
      importance: importance,
      metadata: metadata,
      context: context,
      sentiment: sentiment,
    );
  }

  /// Converte para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'key': key,
      'value': value,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'lastAccessed': lastAccessed.toIso8601String(),
      'accessCount': accessCount,
      'importance': importance,
      'metadata': metadata,
      'context': context,
      'sentiment': sentiment,
    };
  }

  /// Cria a partir de Map
  factory AIMemory.fromMap(Map<String, dynamic> map) {
    return AIMemory(
      id: map['id'],
      userId: map['userId'],
      category: map['category'],
      key: map['key'],
      value: map['value'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      lastAccessed: DateTime.parse(map['lastAccessed']),
      accessCount: map['accessCount'],
      importance: (map['importance'] as num).toDouble(),
      metadata: map['metadata'] != null 
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
      context: map['context'],
      sentiment: map['sentiment'],
    );
  }
} 