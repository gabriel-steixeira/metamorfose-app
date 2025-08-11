# 🧠 Sistema de Memória da IA - Metamorfose App

## 📋 Resumo da Implementação

Foi implementado um sistema completo de memória para a IA que permite que ela lembre informações importantes sobre o usuário, mesmo após desinstalação do app. O sistema combina armazenamento local e na nuvem para máxima persistência.

## 🚀 Funcionalidades Implementadas

### ✨ Memória Persistente
- **Armazenamento Local**: Cache rápido para performance
- **Sincronização na Nuvem**: Persistência entre instalações
- **Backup/Restore**: Exportação e importação de dados
- **Extração Automática**: IA extrai informações das conversas

### 🎯 Categorias de Memória
1. **Informações Pessoais** - Nome, idade, ocupação
2. **Informações sobre Vícios** - Tipo, duração, gravidade
3. **Metas e Objetivos** - Metas de recuperação e vida
4. **Progresso** - Conquistas e marcos alcançados
5. **Gatilhos** - Situações que desencadeiam vícios
6. **Estratégias de Enfrentamento** - Técnicas que funcionam
7. **Rede de Apoio** - Pessoas e recursos de suporte
8. **Preferências** - Estilo de comunicação e motivação
9. **Estado Emocional** - Humor e níveis de estresse
10. **Rotina Diária** - Horários e atividades
11. **Conquistas** - Marcos específicos alcançados
12. **Desafios** - Obstáculos enfrentados
13. **Motivação** - Fatores que impulsionam
14. **Informações sobre Recaídas** - Aprendizados de recaídas
15. **Plano de Recuperação** - Estratégias personalizadas

### 🛠️ Componentes Criados

#### 1. `UserMemory` (`lib/models/user_memory.dart`)
- **Modelo de dados** para representar memórias
- **Categorias predefinidas** com chaves comuns
- **Sistema de importância** (0.0 a 1.0)
- **Contador de acesso** e timestamp
- **Metadados flexíveis** para informações adicionais

#### 2. `MemoryService` (`lib/services/memory_service.dart`)
- **Gerenciamento completo** de memórias
- **Sincronização local/nuvem** automática
- **Extração automática** de informações
- **Algoritmo de relevância** para contexto
- **Backup e restore** de dados

#### 3. `GeminiService` Atualizado
- **Integração com memória** nas conversas
- **Contexto personalizado** para cada resposta
- **Extração automática** de informações
- **Métodos para gerenciar** dados do usuário

#### 4. `VoiceChatScreen` Atualizada
- **Inicialização automática** do sistema de memória
- **ID de usuário único** para persistência
- **Conversas com memória** integrada

## 📦 Dependências Adicionadas

```yaml
dependencies:
  # Persistência local
  shared_preferences: ^2.2.2
```

## ⚙️ Como Funciona

### 🔄 Fluxo de Memória

1. **Inicialização**:
   - Sistema carrega memórias locais
   - Sincroniza com a nuvem (se houver usuário)
   - Define ID único do usuário

2. **Conversa**:
   - IA gera contexto baseado na mensagem
   - Inclui informações relevantes no prompt
   - Extrai e armazena novas informações automaticamente

3. **Persistência**:
   - Salva localmente para performance
   - Sincroniza com a nuvem em background
   - Mantém backup para segurança

### 🧮 Algoritmo de Relevância

O sistema calcula a relevância das memórias usando:

```dart
double score = memory.importance;

// Bônus por acesso recente
if (daysSinceLastAccess < 7) score += 0.2;
else if (daysSinceLastAccess < 30) score += 0.1;

// Bônus por frequência de acesso
if (memory.accessCount > 10) score += 0.1;
else if (memory.accessCount > 5) score += 0.05;

// Bônus por relevância contextual
if (context.contains(key) || key.contains(context)) score += 0.3;
if (context.contains(value) || value.contains(context)) score += 0.2;
```

### 🔍 Extração Automática

O sistema reconhece padrões como:

- **Nome**: "meu nome é João", "chamo-me Maria"
- **Idade**: "tenho 25 anos", "sou 30 anos"
- **Vício**: "meu vício é álcool", "sou viciado em cigarro"
- **Metas**: "quero parar de fumar", "minha meta é ficar sóbrio"
- **Gatilhos**: "quando estou estressado eu fumo"

## 🏗️ Arquitetura

```
lib/
├── models/
│   └── user_memory.dart           # Modelo de dados
├── services/
│   ├── memory_service.dart        # Gerenciamento de memória
│   └── gemini_service.dart        # IA com memória integrada
└── screens/chat/
    └── voice_chat_screen.dart     # Interface com memória
```

## 💾 Persistência de Dados

### Local (SharedPreferences)
- **Vantagens**: Rápido, funciona offline
- **Desvantagens**: Perdido na desinstalação
- **Uso**: Cache e performance

### Nuvem (API REST)
- **Vantagens**: Persiste entre instalações
- **Desvantagens**: Requer internet
- **Uso**: Backup e sincronização

### Backup/Restore
- **Formato**: JSON exportável
- **Uso**: Backup manual e migração

## 🎯 Exemplos de Uso

### 1. Primeira Conversa
```
Usuário: "Oi, meu nome é João e tenho 28 anos"
IA: "Oi João! Que prazer te conhecer! Com 28 anos você tem muita vida pela frente..."
[Sistema armazena: nome=João, idade=28]
```

### 2. Conversa Posterior
```
Usuário: "Estou tentando parar de fumar"
IA: "João, sei que você tem 28 anos e está enfrentando esse desafio..."
[IA usa memória anterior + armazena: vício=cigarro]
```

### 3. Acompanhamento
```
Usuário: "Faz 3 dias que não fumo"
IA: "João, parabéns pelos 3 dias! Você está mostrando muita força..."
[Sistema atualiza: progresso=3 dias sem fumar]
```

## 🔧 Configuração da API na Nuvem

Para usar a sincronização na nuvem, configure:

```dart
// Em memory_service.dart
static const String _cloudApiUrl = 'https://sua-api.com/memories';
static const String _cloudApiKey = 'SUA_API_KEY';
```

### Endpoints Necessários:
- `GET /memories/user/{userId}` - Buscar memórias
- `POST /memories` - Criar memória
- `PUT /memories/{id}` - Atualizar memória
- `DELETE /memories/{id}` - Remover memória
- `DELETE /memories/user/{userId}` - Limpar todas

## 🛡️ Privacidade e Segurança

### Dados Armazenados
- **Local**: Apenas no dispositivo
- **Nuvem**: Criptografados e seguros
- **Backup**: Controlado pelo usuário

### Controles de Privacidade
- **Consentimento**: Usuário pode desabilitar
- **Exclusão**: Pode limpar dados a qualquer momento
- **Anonimização**: IDs únicos sem dados pessoais

## 📊 Métricas e Analytics

O sistema rastreia:
- **Número de memórias** por categoria
- **Frequência de acesso** a cada memória
- **Taxa de extração** de informações
- **Performance** de sincronização

## 🚀 Próximos Passos

### Melhorias Planejadas
1. **Machine Learning** para extração mais inteligente
2. **Análise de Sentimento** para contexto emocional
3. **Recomendações Personalizadas** baseadas em memória
4. **Integração com Wearables** para dados de saúde
5. **Sincronização Multi-dispositivo** em tempo real

### Otimizações
1. **Cache Inteligente** para memórias mais acessadas
2. **Compressão de Dados** para economizar espaço
3. **Sincronização Incremental** para melhor performance
4. **Fallback Offline** mais robusto

## 🔍 Debug e Logs

O sistema inclui logs detalhados:

```dart
print('[MemoryService] Memória adicionada: name = João');
print('[GeminiService] Contexto de memória incluído');
print('[MemoryService] Sincronização concluída');
```

## 💡 Dicas de Implementação

### Para Desenvolvedores
1. **Sempre inicialize** o MemoryService antes de usar
2. **Defina um ID único** para cada usuário
3. **Trate erros** de sincronização graciosamente
4. **Teste offline** para garantir funcionamento
5. **Monitore performance** da extração automática

### Para Usuários
1. **Permita sincronização** para persistência
2. **Faça backup regular** dos dados
3. **Compartilhe informações** relevantes naturalmente
4. **Use o app regularmente** para melhor memória
5. **Configure preferências** de privacidade

## 🎉 Benefícios

### Para o Usuário
- **Experiência Personalizada**: IA lembra de você
- **Progresso Persistente**: Dados não se perdem
- **Acompanhamento Contínuo**: Histórico completo
- **Motivação Personalizada**: Baseada em suas metas

### Para o App
- **Engajamento Maior**: Experiência única
- **Retenção de Usuários**: Dados valiosos preservados
- **Insights Valiosos**: Padrões de uso e progresso
- **Diferencial Competitivo**: Memória inteligente

---

**Sistema de Memória da IA** - Transformando conversas em experiências personalizadas e duradouras! 🧠✨ 