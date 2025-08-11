/// Modelo para representar a memória do usuário
/// Armazena informações importantes que a IA deve lembrar
class UserMemory {
  final String id;
  final String userId;
  final String category;
  final String key;
  final String value;
  final String? description;
  final DateTime createdAt;
  final DateTime lastAccessed;
  final int accessCount;
  final double importance; // 0.0 a 1.0
  final Map<String, dynamic>? metadata;

  UserMemory({
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
  });

  /// Cria uma nova memória
  factory UserMemory.create({
    required String userId,
    required String category,
    required String key,
    required String value,
    String? description,
    double importance = 0.5,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now();
    return UserMemory(
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
    );
  }

  /// Atualiza o acesso à memória
  UserMemory updateAccess() {
    return UserMemory(
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
    );
  }

  /// Atualiza o valor da memória
  UserMemory updateValue(String newValue, {String? newDescription}) {
    return UserMemory(
      id: id,
      userId: userId,
      category: category,
      key: key,
      value: newValue,
      description: newDescription ?? description,
      createdAt: createdAt,
      lastAccessed: DateTime.now(),
      accessCount: accessCount + 1,
      importance: importance,
      metadata: metadata,
    );
  }

  /// Atualiza a importância da memória
  UserMemory updateImportance(double newImportance) {
    return UserMemory(
      id: id,
      userId: userId,
      category: category,
      key: key,
      value: value,
      description: description,
      createdAt: createdAt,
      lastAccessed: DateTime.now(),
      accessCount: accessCount + 1,
      importance: newImportance.clamp(0.0, 1.0),
      metadata: metadata,
    );
  }

  /// Converte para Map (útil para persistência)
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
    };
  }

  /// Cria a partir de Map
  factory UserMemory.fromMap(Map<String, dynamic> map) {
    return UserMemory(
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
    );
  }

  /// Categorias predefinidas de memória
  static const List<String> categories = [
    'personal_info',      // Informações pessoais
    'addiction_info',     // Informações sobre vícios
    'goals',              // Metas e objetivos
    'progress',           // Progresso e conquistas
    'triggers',           // Gatilhos e situações difíceis
    'coping_strategies',  // Estratégias de enfrentamento
    'support_network',    // Rede de apoio
    'preferences',        // Preferências do usuário
    'emotional_state',    // Estado emocional
    'daily_routine',      // Rotina diária
    'achievements',       // Conquistas específicas
    'challenges',         // Desafios enfrentados
    'motivation',         // Fatores motivacionais
    'relapse_info',       // Informações sobre recaídas
    'recovery_plan',      // Plano de recuperação
  ];

  /// Chaves comuns para cada categoria
  static const Map<String, List<String>> commonKeys = {
    'personal_info': [
      'name',
      'age',
      'occupation',
      'location',
      'family_situation',
      'interests',
      'hobbies',
    ],
    'addiction_info': [
      'addiction_type',
      'addiction_duration',
      'severity_level',
      'previous_attempts',
      'current_status',
      'withdrawal_symptoms',
    ],
    'goals': [
      'short_term_goals',
      'long_term_goals',
      'recovery_goals',
      'life_goals',
      'health_goals',
    ],
    'progress': [
      'days_sober',
      'milestones_reached',
      'positive_changes',
      'skills_developed',
      'confidence_level',
    ],
    'triggers': [
      'stress_triggers',
      'social_triggers',
      'emotional_triggers',
      'environmental_triggers',
      'time_triggers',
    ],
    'coping_strategies': [
      'exercise_routine',
      'meditation_practice',
      'hobby_activities',
      'social_activities',
      'professional_help',
    ],
    'support_network': [
      'family_support',
      'friends_support',
      'professional_support',
      'support_groups',
      'emergency_contacts',
    ],
    'preferences': [
      'communication_style',
      'motivation_style',
      'learning_style',
      'activity_preferences',
      'comfort_zones',
    ],
    'emotional_state': [
      'current_mood',
      'stress_level',
      'anxiety_level',
      'depression_signs',
      'emotional_triggers',
    ],
    'daily_routine': [
      'wake_up_time',
      'sleep_time',
      'meal_times',
      'exercise_time',
      'meditation_time',
    ],
    'achievements': [
      'first_week_sober',
      'first_month_sober',
      'milestone_reached',
      'skill_learned',
      'relationship_improved',
    ],
    'challenges': [
      'current_challenge',
      'difficult_situation',
      'temptation_faced',
      'setback_experienced',
      'obstacle_encountered',
    ],
    'motivation': [
      'primary_motivation',
      'secondary_motivation',
      'inspirational_quotes',
      'role_models',
      'future_vision',
    ],
    'relapse_info': [
      'relapse_date',
      'relapse_circumstances',
      'relapse_triggers',
      'lessons_learned',
      'recovery_plan',
    ],
    'recovery_plan': [
      'daily_activities',
      'weekly_goals',
      'monthly_objectives',
      'emergency_plan',
      'support_contacts',
    ],
  };

  @override
  String toString() {
    return 'UserMemory(id: $id, category: $category, key: $key, value: $value, importance: $importance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserMemory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 