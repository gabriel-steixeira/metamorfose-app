/**
 * File: auth_validators.dart
 * Description: Utilitários para validação de campos de autenticação.
 *
 * Responsabilidades:
 * - Validar formato de email
 * - Validar força da senha
 * - Validar formato de telefone
 * - Validar username
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

class AuthValidators {
  // Regex para validação de email
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Regex para validação de telefone brasileiro
  static final RegExp _phoneRegex = RegExp(
    r'^\(?[1-9]{2}\)?\s?9?[0-9]{4}-?[0-9]{4}$',
  );

  // Regex para validação de username (apenas letras, números e underscore)
  static final RegExp _usernameRegex = RegExp(
    r'^[a-zA-Z0-9_]{3,20}$',
  );

  /// Valida se o email está em formato válido
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email é obrigatório';
    }
    
    if (!_emailRegex.hasMatch(email)) {
      return 'Digite um email válido';
    }
    
    return null;
  }

  /// Valida se a senha atende aos critérios mínimos
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (password.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    
    if (password.length > 50) {
      return 'Senha deve ter no máximo 50 caracteres';
    }
    
    // Verifica se tem pelo menos uma letra
    if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
      return 'Senha deve conter pelo menos uma letra';
    }
    
    // Verifica se tem pelo menos um número
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Senha deve conter pelo menos um número';
    }
    
    return null;
  }

  /// Valida se o username está em formato válido
  static String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Nome de usuário é obrigatório';
    }
    
    if (username.length < 3) {
      return 'Nome de usuário deve ter pelo menos 3 caracteres';
    }
    
    if (username.length > 20) {
      return 'Nome de usuário deve ter no máximo 20 caracteres';
    }
    
    if (!_usernameRegex.hasMatch(username)) {
      return 'Nome de usuário deve conter apenas letras, números e underscore';
    }
    
    return null;
  }

  /// Valida se o telefone está em formato válido
  static String? validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    // Remove caracteres especiais para validação
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return 'Digite um telefone válido (10 ou 11 dígitos)';
    }
    
    // Verifica se o formato está correto
    if (!_phoneRegex.hasMatch(phone)) {
      return 'Digite um telefone no formato (11) 99999-9999';
    }
    
    return null;
  }

  /// Valida se as senhas coincidem (para confirmação de senha)
  static String? validatePasswordConfirmation(String password, String confirmation) {
    if (confirmation.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    
    if (password != confirmation) {
      return 'As senhas não coincidem';
    }
    
    return null;
  }

  /// Formata o telefone para exibição
  static String formatPhone(String phone) {
    // Remove todos os caracteres não numéricos
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length == 10) {
      // Formato: (11) 9999-9999
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 6)}-${cleanPhone.substring(6)}';
    } else if (cleanPhone.length == 11) {
      // Formato: (11) 99999-9999
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 7)}-${cleanPhone.substring(7)}';
    }
    
    return phone; // Retorna original se não conseguir formatar
  }

  /// Limpa o telefone removendo formatação
  static String cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  static String? validateCompleteName(String name) {
    final value = name.trim();
    if (value.isEmpty) {
      return 'Nome completo é obrigatório';
    }
    if (value.length < 2) {
      return 'Nome completo deve ter pelo menos 2 caracteres';
    }
    return null;
  }
  
  static String? validateBirthDate(String date) {
    if (date.isEmpty) {
      return 'Data de nascimento é obrigatória';
    }
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(date)) {
      return 'Formato inválido: DD/MM/AAAA';
    }
    // Adicional: verificar se data é válida
    try {
      final parts = date.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final birthDate = DateTime(year, month, day);
      if (birthDate.year != year || birthDate.month != month || birthDate.day != day) {
        return 'Data inválida';
      }
      if (birthDate.isAfter(DateTime.now())) {
        return 'Data não pode ser no futuro';
      }
    } catch (e) {
      return 'Data inválida';
    }
    return null;
  }
}