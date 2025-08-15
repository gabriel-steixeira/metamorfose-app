/**
 * File: hybrid_auth_service.dart
 * Description: Serviço de autenticação híbrido que combina Firebase e autenticação local.
 *
 * Responsabilidades:
 * - Tentar autenticação Firebase primeiro
 * - Fallback para autenticação local se Firebase falhar
 * - Gerenciar estado de sessão
 * - Fornecer dados do usuário autenticado
 *
 * Author: Assistente IA
 * Created on: 15-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/user_model.dart';
import 'local_auth_service.dart';

class HybridAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LocalAuthService _localAuth = LocalAuthService();

  // Stream para ouvir mudanças no estado de autenticação
  Stream<UserModel?> get authStateChanges async* {
    // Primeiro tenta Firebase
    try {
      await for (final firebaseUser in _auth.authStateChanges()) {
        if (firebaseUser != null) {
          try {
            final userModel = await getUserData(firebaseUser.uid);
            yield userModel;
          } catch (e) {
            // Se falhar ao buscar dados do Firestore, tenta local
            final localUser = await _localAuth.getCurrentUser();
            yield localUser;
          }
        } else {
          // Se não há usuário Firebase, tenta local
          final localUser = await _localAuth.getCurrentUser();
          yield localUser;
        }
      }
    } catch (e) {
      // Se Firebase falhar completamente, usa apenas local
      await for (final localUser in _localAuth.authStateChanges) {
        yield localUser;
      }
    }
  }

  // Buscar dados do usuário no Firestore
  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao buscar dados do usuário: $e');
    }
  }

  // Login com email e senha - tenta Firebase primeiro, depois local
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Primeiro tenta Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await getUserData(userCredential.user!.uid);
    } catch (firebaseError) {
      // Se Firebase falhar, tenta local
      try {
        return await _localAuth.signInWithEmailAndPassword(email, password);
      } catch (localError) {
        // Se ambos falharem, retorna erro mais específico
        if (firebaseError.toString().contains('user-not-found') || 
            firebaseError.toString().contains('wrong-password')) {
          throw Exception('Credenciais inválidas. Use: ${LocalAuthService.defaultEmail} / ${LocalAuthService.defaultPassword}');
        }
        throw Exception('Erro de autenticação: $firebaseError');
      }
    }
  }

  // Login com Google - tenta Firebase primeiro
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Login cancelado');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Verifica se usuário já existe no Firestore
      try {
        return await getUserData(user.uid);
      } catch (e) {
        // Se não existe, cria novo usuário
        final userModel = UserModel(
          id: user.uid,
          email: user.email!,
          name: user.displayName ?? 'Usuário Google',
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set({
          'email': userModel.email,
          'name': userModel.name,
          'photoUrl': userModel.photoUrl,
          'phoneNumber': userModel.phoneNumber,
          'createdAt': Timestamp.fromDate(userModel.createdAt),
          'updatedAt': Timestamp.fromDate(userModel.updatedAt),
        });

        return userModel;
      }
    } catch (e) {
      throw Exception('Erro no login com Google: $e');
    }
  }

  // Login com Facebook - tenta Firebase primeiro
  Future<UserModel> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        throw Exception('Login com Facebook falhou');
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.token,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Verifica se usuário já existe no Firestore
      try {
        return await getUserData(user.uid);
      } catch (e) {
        // Se não existe, cria novo usuário
        final userModel = UserModel(
          id: user.uid,
          email: user.email!,
          name: user.displayName ?? 'Usuário Facebook',
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set({
          'email': userModel.email,
          'name': userModel.name,
          'photoUrl': userModel.photoUrl,
          'phoneNumber': userModel.phoneNumber,
          'createdAt': Timestamp.fromDate(userModel.createdAt),
          'updatedAt': Timestamp.fromDate(userModel.updatedAt),
        });

        return userModel;
      }
    } catch (e) {
      throw Exception('Erro no login com Facebook: $e');
    }
  }

  // Registrar com email e senha - tenta Firebase primeiro, depois local
  Future<UserModel> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    try {
      // Primeiro tenta Firebase
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      await user.updateDisplayName(name);

      final userModel = UserModel(
        id: user.uid,
        email: email,
        name: name,
        photoUrl: user.photoURL,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'name': name,
        'photoUrl': user.photoURL,
        'phoneNumber': phoneNumber,
        'createdAt': Timestamp.fromDate(userModel.createdAt),
        'updatedAt': Timestamp.fromDate(userModel.updatedAt),
      });

      return userModel;
    } catch (firebaseError) {
      // Se Firebase falhar, tenta local
      try {
        return await _localAuth.registerWithEmailAndPassword(
          email, password, name, phoneNumber);
      } catch (localError) {
        throw Exception('Erro no registro: $firebaseError');
      }
    }
  }

  // Login rápido com credenciais padrão (apenas local)
  Future<UserModel> signInWithDefaultCredentials() async {
    return await _localAuth.signInWithDefaultCredentials();
  }

  // Logout - limpa tanto Firebase quanto local
  Future<void> signOut() async {
    try {
      // Tenta logout do Firebase
      await _auth.signOut();
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      // Ignora erros do Firebase
    }
    
    // Sempre limpa o estado local
    await _localAuth.signOut();
  }

  // Obtém usuário atual - tenta Firebase primeiro, depois local
  Future<UserModel?> getCurrentUser() async {
    try {
      // Primeiro tenta Firebase
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        try {
          return await getUserData(firebaseUser.uid);
        } catch (e) {
          // Se falhar ao buscar dados, tenta local
          return await _localAuth.getCurrentUser();
        }
      }
      
      // Se não há usuário Firebase, tenta local
      return await _localAuth.getCurrentUser();
    } catch (e) {
      // Se Firebase falhar, usa apenas local
      return await _localAuth.getCurrentUser();
    }
  }

  // Verifica se está logado
  Future<bool> isLoggedIn() async {
    try {
      // Primeiro tenta Firebase
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) return true;
      
      // Se não há usuário Firebase, tenta local
      return await _localAuth.isLoggedIn();
    } catch (e) {
      // Se Firebase falhar, usa apenas local
      return await _localAuth.isLoggedIn();
    }
  }

  // Reset de senha - tenta Firebase primeiro
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Erro ao enviar email de reset: $e');
    }
  }

  // Getters para credenciais padrão
  static String get defaultEmail => LocalAuthService.defaultEmail;
  static String get defaultPassword => LocalAuthService.defaultPassword;
  static String get defaultName => LocalAuthService.defaultName;
  static String get defaultPhone => LocalAuthService.defaultPhone;
}
