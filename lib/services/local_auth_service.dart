/**
 * File: local_auth_service.dart
 * Description: Serviço de autenticação local para desenvolvimento e testes.
 *
 * Responsabilidades:
 * - Permitir login com credenciais fixas
 * - Gerenciar estado de sessão localmente
 * - Fornecer dados do usuário autenticado
 * - Salvar estado de login no dispositivo
 *
 * Author: Assistente IA
 * Created on: 15-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalAuthService {
  static const String _userKey = 'local_user';
  static const String _isLoggedInKey = 'is_logged_in';
  
  // Credenciais fixas para desenvolvimento
  static const String _defaultEmail = 'teste@metamorfose.com';
  static const String _defaultPassword = '123456';
  static const String _defaultName = 'Usuário Teste';
  static const String _defaultPhone = '+55 11 99999-9999';

  // Usuário padrão
  static final UserModel _defaultUser = UserModel(
    id: 'local_user_001',
    email: _defaultEmail,
    name: _defaultName,
    photoUrl: null,
    phoneNumber: _defaultPhone,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  /// Verifica se o usuário está logado
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Faz login com as credenciais fornecidas
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    // Verifica se as credenciais são válidas
    if (email == _defaultEmail && password == _defaultPassword) {
      // Salva o estado de login
      await _saveLoginState(_defaultUser);
      return _defaultUser;
    } else {
      throw Exception('Credenciais inválidas. Use: $defaultEmail / $defaultPassword');
    }
  }

  /// Faz login com as credenciais padrão (para facilitar testes)
  Future<UserModel> signInWithDefaultCredentials() async {
    await _saveLoginState(_defaultUser);
    return _defaultUser;
  }

  /// Registra um novo usuário (simulado)
  Future<UserModel> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    // Simula registro bem-sucedido
    final newUser = UserModel(
      id: 'local_user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      photoUrl: null,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Salva o estado de login
    await _saveLoginState(newUser);
    return newUser;
  }

  /// Faz logout
  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_userKey);
    } catch (e) {
      // Ignora erros no logout
    }
  }

  /// Obtém o usuário atual
  Future<UserModel?> getCurrentUser() async {
    try {
      if (!await isLoggedIn()) return null;
      
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Salva o estado de login localmente
  Future<void> _saveLoginState(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
    } catch (e) {
      throw Exception('Erro ao salvar estado de login: $e');
    }
  }

  /// Stream para mudanças no estado de autenticação
  Stream<UserModel?> get authStateChanges async* {
    // Emite o usuário atual
    final user = await getCurrentUser();
    yield user;
    
    // Emite null quando não há usuário
    if (user == null) {
      yield null;
    }
  }

  // Getters para as credenciais padrão
  static String get defaultEmail => _defaultEmail;
  static String get defaultPassword => _defaultPassword;
  static String get defaultName => _defaultName;
  static String get defaultPhone => _defaultPhone;
}
