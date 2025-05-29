class InputValidators {
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'E-mail é obrigatório';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(email)) {
      return 'E-mail inválido';
    }
    
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    
    return null;
  }

  static String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Nome de usuário é obrigatório';
    }
    
    if (username.length < 3) {
      return 'O nome de usuário deve ter pelo menos 3 caracteres';
    }
    
    return null;
  }

  static String? validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    final phoneRegex = RegExp(
      r'^\([1-9]{2}\) [9]{0,1}[0-9]{4}-[0-9]{4}$',
    );
    
    if (!phoneRegex.hasMatch(phone)) {
      return 'Telefone inválido';
    }
    
    return null;
  }
} 