// TEMPORARIAMENTE DESABILITADO - DEPENDÊNCIAS NÃO DISPONÍVEIS
/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oracle_dart/oracle_dart.dart';
import 'dart:convert';

/// Serviço híbrido que combina Firebase Auth com Oracle Database
class HybridAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  OracleConnection? _oracleConnection;
  
  // Configuração Oracle
  static const String _oracleHost = 'your-oracle-host';
  static const int _oraclePort = 1521;
  static const String _oracleService = 'your-service';
  static const String _oracleUser = 'app_user';
  static const String _oraclePassword = 'app_password';

  /// Inicializa o serviço
  Future<bool> initialize() async {
    try {
      print('[HybridAuth] Inicializando serviço híbrido...');
      
      // Conecta com Oracle
      _oracleConnection = await OracleConnection.connect(
        host: _oracleHost,
        port: _oraclePort,
        serviceName: _oracleService,
        userName: _oracleUser,
        password: _oraclePassword,
      );
      
      print('[HybridAuth] Conectado com Oracle Database');
      return true;
    } catch (e) {
      print('[HybridAuth] Erro ao conectar com Oracle: $e');
      return false;
    }
  }

  /// Registra usuário com Firebase Auth
  Future<UserCredential> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Registra no Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Salva dados adicionais no Oracle
      await _saveUserToOracle(
        userId: userCredential.user!.uid,
        email: email,
        name: name,
      );

      print('[HybridAuth] Usuário registrado com sucesso');
      return userCredential;
    } catch (e) {
      print('[HybridAuth] Erro no registro: $e');
      rethrow;
    }
  }

  /// Login com Firebase Auth
  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Login no Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Valida no Oracle
      await _validateUserInOracle(userCredential.user!.uid);

      print('[HybridAuth] Login realizado com sucesso');
      return userCredential;
    } catch (e) {
      print('[HybridAuth] Erro no login: $e');
      rethrow;
    }
  }

  /// Salva usuário no Oracle Database
  Future<void> _saveUserToOracle({
    required String userId,
    required String email,
    required String name,
  }) async {
    try {
      final query = '''
        INSERT INTO users (user_id, email, name, created_at, updated_at)
        VALUES (:userId, :email, :name, SYSDATE, SYSDATE)
      ''';

      await _oracleConnection!.execute(
        query,
        parameters: {
          'userId': userId,
          'email': email,
          'name': name,
        },
      );

      print('[HybridAuth] Usuário salvo no Oracle');
    } catch (e) {
      print('[HybridAuth] Erro ao salvar no Oracle: $e');
      rethrow;
    }
  }

  /// Valida usuário no Oracle Database
  Future<void> _validateUserInOracle(String userId) async {
    try {
      final query = '''
        SELECT user_id, email, name, status
        FROM users 
        WHERE user_id = :userId AND status = 'ACTIVE'
      ''';

      final result = await _oracleConnection!.query(
        query,
        parameters: {'userId': userId},
      );

      if (result.isEmpty) {
        throw Exception('Usuário não encontrado ou inativo no Oracle');
      }

      print('[HybridAuth] Usuário validado no Oracle');
    } catch (e) {
      print('[HybridAuth] Erro na validação Oracle: $e');
      rethrow;
    }
  }

  /// Salva memória da IA no Oracle
  Future<void> saveAIMemory({
    required String userId,
    required String category,
    required String key,
    required String value,
    String? description,
    double importance = 0.5,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Valida token do Firebase
      final token = await _firebaseAuth.currentUser?.getIdToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final query = '''
        INSERT INTO ai_memories (
          user_id, category, memory_key, value, description, 
          importance, metadata, created_at, updated_at
        )
        VALUES (
          :userId, :category, :key, :value, :description,
          :importance, :metadata, SYSDATE, SYSDATE
        )
      ''';

      await _oracleConnection!.execute(
        query,
        parameters: {
          'userId': userId,
          'category': category,
          'key': key,
          'value': value,
          'description': description,
          'importance': importance,
          'metadata': metadata != null ? jsonEncode(metadata) : null,
        },
      );

      print('[HybridAuth] Memória salva no Oracle');
    } catch (e) {
      print('[HybridAuth] Erro ao salvar memória: $e');
      rethrow;
    }
  }

  /// Busca memórias da IA do Oracle
  Future<List<Map<String, dynamic>>> getAIMemories({
    required String userId,
    String? category,
    int limit = 10,
  }) async {
    try {
      // Valida token do Firebase
      final token = await _firebaseAuth.currentUser?.getIdToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      String query = '''
        SELECT category, memory_key, value, description, 
               importance, metadata, created_at, updated_at
        FROM ai_memories 
        WHERE user_id = :userId
      ''';

      if (category != null) {
        query += ' AND category = :category';
      }

      query += ' ORDER BY importance DESC, updated_at DESC';
      query += ' FETCH FIRST :limit ROWS ONLY';

      final parameters = {
        'userId': userId,
        'limit': limit,
      };

      if (category != null) {
        parameters['category'] = category;
      }

      final result = await _oracleConnection!.query(query, parameters: parameters);

      return result.map((row) => {
        'category': row[0],
        'key': row[1],
        'value': row[2],
        'description': row[3],
        'importance': row[4],
        'metadata': row[5] != null ? jsonDecode(row[5]) : null,
        'createdAt': row[6],
        'updatedAt': row[7],
      }).toList();

    } catch (e) {
      print('[HybridAuth] Erro ao buscar memórias: $e');
      return [];
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _oracleConnection?.close();
      print('[HybridAuth] Logout realizado');
    } catch (e) {
      print('[HybridAuth] Erro no logout: $e');
    }
  }

  /// Obtém usuário atual
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Verifica se está logado
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
*/ 