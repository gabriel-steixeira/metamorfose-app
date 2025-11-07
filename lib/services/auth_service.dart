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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream para ouvir mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

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

  // Registrar com email e senha
  Future<UserModel> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    try {
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
    } catch (e) {
      throw Exception('Erro ao registrar usuário: $e');
    }
  }

  // Login com email e senha
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await getUserData(userCredential.user!.uid);
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  // Login com Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Login com Google cancelado');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Verifica se o usuário já existe no Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        // Se não existe, cria um novo documento
        final userModel = UserModel(
          id: user.uid,
          email: user.email!,
          name: user.displayName,
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoURL,
          'phoneNumber': user.phoneNumber,
          'createdAt': Timestamp.fromDate(userModel.createdAt),
          'updatedAt': Timestamp.fromDate(userModel.updatedAt),
        });

        return userModel;
      }

      return await getUserData(user.uid);
    } catch (e) {
      throw Exception('Erro ao fazer login com Google: $e');
    }
  }

  // Login com Facebook
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

      // Verifica se o usuário já existe no Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        // Se não existe, cria um novo documento
        final userModel = UserModel(
          id: user.uid,
          email: user.email!,
          name: user.displayName,
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoURL,
          'phoneNumber': user.phoneNumber,
          'createdAt': Timestamp.fromDate(userModel.createdAt),
          'updatedAt': Timestamp.fromDate(userModel.updatedAt),
        });

        return userModel;
      }

      return await getUserData(user.uid);
    } catch (e) {
      throw Exception('Erro ao fazer login com Facebook: $e');
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
        FacebookAuth.instance.logOut(),
      ]);
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  // Recuperação de senha
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Erro ao enviar email de recuperação: $e');
    }
  }
} 