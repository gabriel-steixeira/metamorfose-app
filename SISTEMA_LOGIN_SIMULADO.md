# Sistema de Login Simulado - Metamorfose App

## Visão Geral

Foi implementado um sistema de login simulado usando a arquitetura BLoC para o aplicativo Metamorfose. Este sistema permite autenticação de teste com credenciais fixas e serve como base para uma implementação real futura.

## Arquitetura Implementada

### 1. **BLoC Pattern**
- `AuthBloc` - Gerencia todo o estado de autenticação
- `AuthEvent` - Define eventos possíveis (login, logout, atualização de campos)
- `AuthState` - Mantém o estado atual da autenticação

### 2. **Service Layer**
- `AuthService` - Simula chamadas de API para autenticação
- `LoginResult` - Modelo de resposta das operações de login
- `User` - Modelo de dados do usuário

### 3. **State Management**
- Estados existentes reutilizados: `AuthState`, `LoginState`, `ValidationState`
- Integração com flutter_bloc para gerenciamento reativo

## Credenciais para Teste

### 📋 **Credenciais Válidas:**
- **Usuário:** `gabriel`
- **Senha:** `123456`

**Alternativas aceitas para usuário:**
- `gabriel`
- `gabriel@metamorfose.com`
- Qualquer string que contenha "gabriel"

## Como Usar

### 1. **Acessar a Tela de Login**
```dart
// Navegar para a tela de login com BLoC
context.go(Routes.authBloc);
```

### 2. **Testar o Login**
1. Abra o aplicativo
2. Passe pelo onboarding até a tela final
3. Clique em "SIM!" para ir para a tela de login
4. Digite as credenciais de teste:
   - Usuário: `gabriel`
   - Senha: `123456`
5. Clique em "ENTRAR"

### 3. **Funcionalidades Implementadas**
- ✅ Validação em tempo real dos campos
- ✅ Feedback visual de erro
- ✅ Loading state durante login
- ✅ Navegação automática após sucesso
- ✅ Checkbox "Lembrar-me"
- ✅ Animação dos olhos do personagem
- ✅ Mensagens de erro informativas

## Estrutura de Arquivos

```
lib/
├── blocs/
│   └── auth_bloc.dart              # BLoC principal de autenticação
├── services/
│   └── auth_service.dart           # Serviço de autenticação simulada
├── screens/auth/
│   ├── auth_screen.dart            # Tela original (mantida)
│   └── auth_screen_bloc.dart       # Nova tela com BLoC
├── state/auth/
│   ├── auth_state.dart             # Estado principal (existente)
│   ├── login_state.dart            # Estado de login (existente)
│   └── validation_state.dart       # Estado de validação (existente)
└── navigation/
    └── app_router.dart             # Rotas atualizadas
```

## Como Funciona

### 1. **Fluxo de Login**
```
Usuario preenche credenciais
         ↓
AuthBloc valida campos
         ↓
AuthService simula chamada API
         ↓
Estado atualizado (sucesso/erro)
         ↓
UI responde ao novo estado
         ↓
Navegação (se sucesso)
```

### 2. **Estados Possíveis**
- **Initial**: Estado inicial, campos vazios
- **Loading**: Durante validação/login
- **Success**: Login bem-sucedido
- **Error**: Credenciais inválidas ou outros erros

### 3. **Validações Implementadas**
- Campo email: mínimo 3 caracteres
- Campo senha: mínimo 6 caracteres
- Validação de credenciais específicas para teste

## Recursos Visuais

### 1. **Personagem Interativo**
- Os olhos do personagem mudam conforme a visibilidade da senha
- Feedback visual para o usuário

### 2. **Validação em Tempo Real**
- Bordas vermelhas em campos inválidos
- Mensagens de erro específicas
- Validação reativa conforme o usuário digita

### 3. **Estados de Carregamento**
- Botão mostra "ENTRANDO..." durante processo
- Desabilitação do botão durante loading

### 4. **Dicas para Usuário**
- Box informativo com credenciais de teste
- Feedback claro sobre erros

## Configuração para Desenvolvimento

### 1. **Dependências Necessárias**
Já configuradas no `pubspec.yaml`:
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  provider: ^6.0.5
```

### 2. **Configuração do BLoC**
O `AuthBloc` é fornecido globalmente em `app.dart`:
```dart
BlocProvider(
  create: (context) => AuthBloc(AuthService()),
  child: MaterialApp.router(...),
)
```

## Próximos Passos

### Para Implementação Real:
1. **Substituir AuthService** por serviço real de API
2. **Implementar persistência** de sessão (SharedPreferences/Secure Storage)
3. **Adicionar autenticação social** (Google, Facebook)
4. **Implementar refresh tokens**
5. **Adicionar biometria** se necessário

### Melhorias Sugeridas:
1. **Testes unitários** para AuthBloc e AuthService
2. **Testes de widget** para AuthScreenBloc
3. **Internacionalização** das mensagens
4. **Animações** mais sofisticadas
5. **Logs** de auditoria

## Troubleshooting

### Problemas Comuns:

**1. Login não funciona:**
- Verifique se está usando exatamente `gabriel` e `123456`
- Certifique-se de que não há espaços extras

**2. Navegação não acontece:**
- Verifique se a rota `Routes.plantConfig` existe
- Confirme se o BlocProvider está configurado

**3. Erros de estado:**
- Verifique se o AuthBloc está sendo injetado corretamente
- Confirme se os eventos estão sendo disparados

## Suporte

Para dúvidas ou problemas com o sistema de login simulado, consulte:
- Código fonte em `lib/blocs/auth_bloc.dart`
- Implementação da tela em `lib/screens/auth/auth_screen_bloc.dart`
- Documentação do flutter_bloc: https://bloclibrary.dev/

---

**Implementado por:** Gabriel Teixeira  
**Data:** 29-05-2025  
**Versão:** 1.0.0 