/**
 * File: auth_service.dart
 * Description: Serviço de autenticação simulada.
 *
 * Responsabilidades:
 * - Simular login com credenciais fixas
 * - Gerenciar estado de sessão do usuário
 * - Fornecer dados do usuário autenticado
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:async';

/// Resultado de uma operação de login
class LoginResult {
  final bool success;
  final String? errorMessage;
  final User? user;

  LoginResult({
    required this.success,
    this.errorMessage,
    this.user,
  });
}

/// Modelo de usuário
class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });
}

/// Serviço de autenticação simulada
class AuthService {
  // Credenciais simuladas para teste
  static const String _validUsername = 'gabriel';
  static const String _validPassword = '123456';
  
  // Usuário simulado
  static const User _simulatedUser = User(
    id: '1',
    name: 'Gabriel Teixeira',
    email: 'gabriel@metamorfose.com',
    avatar: null,
  );

  // Estado interno da sessão
  User? _currentUser;
  bool _isLoggedIn = false;
  
  // Stream controller para mudanças de estado de auth
  final StreamController<bool> _authStateController = StreamController<bool>.broadcast();
  
  /// Stream que notifica mudanças no estado de autenticação
  Stream<bool> get authStateChanges => _authStateController.stream;
  
  /// Usuário atualmente logado
  User? get currentUser => _currentUser;
  
  /// Se o usuário está logado
  bool get isLoggedIn => _isLoggedIn;

  /// Simula login com credenciais
  Future<LoginResult> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Normaliza o input (remove espaços)
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();
    
    // Verifica credenciais - aceita tanto 'gabriel' quanto email
    final bool validCredentials = (
      (normalizedEmail == _validUsername || normalizedEmail == _simulatedUser.email) &&
      normalizedPassword == _validPassword
    );
    
    if (validCredentials) {
      _currentUser = _simulatedUser;
      _isLoggedIn = true;
      _authStateController.add(true);
      
      return LoginResult(
        success: true,
        user: _currentUser,
      );
    } else {
      return LoginResult(
        success: false,
        errorMessage: 'Credenciais inválidas. Use gabriel/123456 para teste.',
      );
    }
  }

  /// Simula logout
  Future<void> logout() async {
    // Simula delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    _currentUser = null;
    _isLoggedIn = false;
    _authStateController.add(false);
  }

  /// Verifica se há sessão ativa (para remember me)
  Future<bool> checkSession() async {
    // Simula verificação de sessão
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Em uma implementação real, verificaria token armazenado
    // Por enquanto, sempre retorna false
    return false;
  }

  /// Obtém dados do usuário logado
  Future<User?> getCurrentUser() async {
    if (!_isLoggedIn) return null;
    
    // Simula busca de dados atualizados do usuário
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  /// Dispose do service
  void dispose() {
    _authStateController.close();
  }
} 