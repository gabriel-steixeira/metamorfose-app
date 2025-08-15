# Sistema de Login Híbrido - Metamorfose App

## Visão Geral

O aplicativo Metamorfose agora possui um sistema de autenticação híbrido que combina:
- **Firebase Authentication** (principal)
- **Autenticação Local** (fallback)

## Como Funciona

### 1. Autenticação Firebase (Prioritária)
- Tenta primeiro fazer login com Firebase
- Suporta email/senha, Google e Facebook
- Armazena dados no Firestore
- Ideal para produção

### 2. Autenticação Local (Fallback)
- Ativa automaticamente se Firebase falhar
- Credenciais fixas para desenvolvimento
- Dados salvos localmente no dispositivo
- Perfeito para testes e desenvolvimento

## Credenciais de Desenvolvimento

### Login Rápido
- **Botão**: "LOGIN RÁPIDO (DEV)" na tela de login
- **Função**: Acesso instantâneo sem digitar credenciais
- **Uso**: Clique no botão para entrar diretamente

### Credenciais Manuais
- **Email**: `teste@metamorfose.com`
- **Senha**: `123456`
- **Nome**: Usuário Teste
- **Telefone**: +55 11 99999-9999

## Fluxo de Autenticação

```
1. Usuário tenta login
   ↓
2. Sistema tenta Firebase primeiro
   ↓
3. Se Firebase falhar → Fallback para Local
   ↓
4. Se ambos falharem → Erro de credenciais
```

## Vantagens do Sistema Híbrido

✅ **Desenvolvimento**: Sempre funciona, mesmo offline  
✅ **Produção**: Firebase para usuários reais  
✅ **Testes**: Credenciais fixas para QA  
✅ **Robustez**: Fallback automático em caso de falha  
✅ **Flexibilidade**: Suporte a múltiplos provedores  

## Como Usar

### Para Desenvolvedores
1. Use o botão "LOGIN RÁPIDO (DEV)" para acesso rápido
2. Ou digite as credenciais padrão manualmente
3. O sistema salva o login localmente

### Para Usuários Finais
1. Crie conta com email/senha (Firebase)
2. Ou use login social (Google/Facebook)
3. Sistema funciona normalmente

### Para Testes
1. Credenciais fixas sempre disponíveis
2. Não precisa de conexão com Firebase
3. Login salvo localmente no dispositivo

## Arquivos Principais

- `lib/services/hybrid_auth_service.dart` - Serviço principal
- `lib/services/local_auth_service.dart` - Fallback local
- `lib/blocs/auth_bloc.dart` - Lógica de autenticação
- `lib/screens/auth/auth_screen.dart` - Interface de login

## Configuração

### Firebase (Opcional)
- Configure `google-services.json` (Android)
- Configure `GoogleService-Info.plist` (iOS)
- Configure variáveis de ambiente

### Local (Automático)
- Funciona sem configuração
- Dados salvos em `SharedPreferences`
- Credenciais hardcoded para desenvolvimento

## Troubleshooting

### Erro de Firebase
- Sistema automaticamente usa fallback local
- Verifique configuração do Firebase
- Credenciais locais sempre funcionam

### Erro de Login
- Verifique se está usando credenciais corretas
- Use o botão de login rápido para testes
- Sistema mostra mensagens de erro específicas

### Problemas de Rede
- Firebase pode falhar offline
- Sistema local funciona sem internet
- Login salvo localmente persiste

## Segurança

⚠️ **ATENÇÃO**: As credenciais locais são apenas para desenvolvimento!  
- Não use em produção
- Não compartilhe credenciais fixas
- Firebase é mais seguro para usuários reais

## Próximos Passos

1. Teste o login rápido
2. Verifique funcionamento offline
3. Configure Firebase se necessário
4. Personalize credenciais locais se desejar
