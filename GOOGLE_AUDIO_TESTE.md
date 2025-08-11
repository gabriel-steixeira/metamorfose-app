# 🎤 Teste do Google Audio Service

## 📋 Resumo

Criamos uma versão alternativa do sistema de áudio usando Google Cloud Speech-to-Text e Text-to-Speech para você testar e comparar com o sistema atual.

## 🚀 Como Testar

### 1. Configuração da API Key

Primeiro, você precisa configurar sua API Key do Google Cloud:

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Crie um projeto ou selecione um existente
3. Ative as APIs:
   - **Speech-to-Text API**
   - **Text-to-Speech API**
4. Crie uma chave de API
5. Configure a chave no arquivo `lib/services/google_audio_service.dart`:

```dart
static const String _apiKey = 'SUA_API_KEY_AQUI';
```

### 2. Instalar Dependências

Execute no terminal:

```bash
flutter pub get
```

### 3. Acessar a Tela de Teste

Para acessar a tela de teste, você pode:

1. **Temporariamente** modificar a rota no `app_router.dart`:
```dart
// Substitua a rota do chat por:
GoRoute(
  path: '/chat',
  builder: (context, state) => const GoogleVoiceChatScreen(),
),
```

2. **Ou** navegar diretamente no código:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const GoogleVoiceChatScreen(),
  ),
);
```

## 🔍 Comparação de Funcionalidades

### ✅ Sistema Atual (speech_to_text + flutter_tts)
- **Vantagens**:
  - Funciona offline
  - Gratuito
  - Sem necessidade de API Key
  - Vozes locais do dispositivo

- **Desvantagens**:
  - Qualidade limitada
  - Vozes podem variar entre dispositivos
  - Reconhecimento menos preciso

### 🆕 Sistema Google (Google Cloud APIs)
- **Vantagens**:
  - Qualidade superior de reconhecimento
  - Vozes mais naturais e consistentes
  - Suporte a múltiplos idiomas
  - Reconhecimento mais preciso

- **Desvantagens**:
  - Requer internet
  - Custo por uso
  - Necessita de API Key
  - Latência de rede

## 📊 Métricas para Comparar

### 1. **Precisão do Reconhecimento**
- Teste frases complexas
- Teste com ruído de fundo
- Teste diferentes sotaques

### 2. **Qualidade da Voz**
- Naturalidade
- Velocidade
- Tom e entonação

### 3. **Latência**
- Tempo de resposta
- Tempo de processamento

### 4. **Confiabilidade**
- Estabilidade da conexão
- Tratamento de erros

## 🧪 Testes Sugeridos

### Teste 1: Frases Simples
```
"Olá, como você está?"
"Meu nome é João"
"Estou tentando parar de fumar"
```

### Teste 2: Frases Complexas
```
"Hoje foi um dia muito difícil, mas consegui resistir à tentação"
"Preciso de ajuda para superar essa dependência"
"Quais são as estratégias que você recomenda?"
```

### Teste 3: Com Ruído
- Teste em ambiente com música
- Teste com pessoas falando ao fundo
- Teste com diferentes volumes

### Teste 4: Personalidades
- Teste todas as 4 personalidades
- Compare a qualidade da voz entre elas
- Verifique se o tom muda adequadamente

## 🔧 Configurações Disponíveis

### Personalidades
- **Engraçado**: Tom descontraído e humorístico
- **Irônico**: Sarcástico mas carinhoso
- **Amoroso**: Extremamente carinhoso
- **Duolingo**: Ameaçador mas engraçado

### Níveis de Criatividade
- **Conservador**: Respostas mais previsíveis
- **Equilibrado**: Criativo mas controlado
- **Criativo**: Muito criativo e surpreendente
- **Loucura**: Máxima criatividade

## 💰 Custos do Google Cloud

### Speech-to-Text
- **Primeiros 60 minutos/mês**: Gratuito
- **Após**: $0.006 por 15 segundos

### Text-to-Speech
- **Primeiros 4 milhões de caracteres/mês**: Gratuito
- **Após**: $4.00 por 1 milhão de caracteres

### Estimativa de Uso
- **Conversa típica**: ~5-10 minutos
- **Custo estimado**: $0.01-0.05 por conversa

## 🛠️ Solução de Problemas

### Erro: "API Key não configurada"
- Configure a API Key no arquivo `google_audio_service.dart`

### Erro: "Sem permissão para gravar"
- Verifique as permissões do microfone
- Reinicie o app

### Erro: "Erro na API do Google"
- Verifique se as APIs estão ativadas
- Verifique se a API Key tem as permissões corretas
- Verifique a conexão com a internet

### Erro: "Não foi possível reconhecer a fala"
- Fale mais claramente
- Reduza o ruído de fundo
- Verifique se o microfone está funcionando

## 📈 Próximos Passos

Após os testes, você pode:

1. **Manter ambos os sistemas** e deixar o usuário escolher
2. **Migrar completamente** para o Google se a qualidade for superior
3. **Usar híbrido**: Google para reconhecimento, local para síntese
4. **Implementar fallback**: Google quando disponível, local como backup

## 🔄 Como Voltar ao Sistema Original

Para voltar ao sistema original, simplesmente:

1. Remova as modificações no `app_router.dart`
2. Use a tela `VoiceChatScreen` original
3. O `AudioService` original continuará funcionando normalmente

## 📝 Feedback

Durante os testes, anote:

- **Qualidade do reconhecimento**
- **Qualidade da voz**
- **Velocidade de resposta**
- **Estabilidade da conexão**
- **Custos (se aplicável)**

Com essas informações, poderemos tomar a melhor decisão sobre qual sistema usar! 🚀 