# 🔧 Configuração Automatizada - Metamorfose App

## 🎯 **Solução Implementada**

Criamos um sistema **completamente automatizado** que:
- ✅ **Centraliza todas as configurações** no Flutter
- ✅ **Configura automaticamente** Android, iOS e outras plataformas
- ✅ **Usa apenas APIs reais** do Google Maps
- ✅ **Mantém segurança** com variáveis de ambiente
- ✅ **Oferece flexibilidade** de versionamento

---

## 🚀 **Como Usar - Comandos Simples**

### **🔧 Para Desenvolvimento (Uso Diário)**
```bash
# Comando único para rodar o app
./scripts/dev.sh
```

### **🏗️ Para Build de Produção**
```bash
# Android (padrão)
./scripts/build.sh

# Outras plataformas
./scripts/build.sh ios
./scripts/build.sh web
./scripts/build.sh windows
./scripts/build.sh linux
./scripts/build.sh macos
```

### **🏗️ Para Setup Inicial/Recriar Plataformas**
```bash
# Primeira vez ou para novos desenvolvedores
dart run scripts/setup_project.dart android ios web

# Para recriar completamente
dart run scripts/setup_project.dart --recreate android
```

---

## 🔄 **Fluxo Automático**

### **1. Desenvolvimento (`./scripts/dev.sh`)**
```
🔍 Verifica env.local
⚙️  Executa: flutter run --dart-define-from-file=env.local
📱 App roda com configurações seguras
```

### **2. Build (`./scripts/build.sh`)**
```
🔍 Verifica env.local
🤖 Configura AndroidManifest.xml automaticamente
🔧 Injeta API keys do env.local
🏗️  Executa flutter build com todas as configurações
📱 APK/IPA pronto para uso
```

### **3. Setup (`setup_project.dart`)**
```
🏗️  Recria estruturas de plataforma via flutter create
🔧 Configura placeholders automáticos
✅ Estrutura pronta para desenvolvimento/build
```

---

## 📁 **Estrutura de Arquivos**

```
metamorfose-app-flutter/
├── 🔐 env.local                    # SEU arquivo (não versionado)
├── 📋 env.template                 # Template público
├── scripts/
│   ├── 🚀 dev.sh                   # Desenvolvimento rápido
│   ├── 🏗️  build.sh                # Build automático
│   ├── 🔧 build_with_config.dart   # Configurador inteligente
│   └── 🏗️  setup_project.dart      # Gerador de plataformas
├── lib/config/
│   └── 🔧 environment.dart         # Configurações centralizadas
└── 📊 CONFIGURACAO_AUTOMATIZADA.md # Esta documentação
```

---

## 🔐 **Configuração de Segurança**

### **Primeira Vez:**
```bash
# 1. Copie o template
cp env.template env.local

# 2. Edite com suas chaves reais
nano env.local

# 3. Execute normalmente
./scripts/dev.sh
```

### **Conteúdo do `env.local`:**
```bash
# Google Maps API Key (obrigatória)
GOOGLE_MAPS_API_KEY=Sua_Chave_Real_Aqui

# Google Places API Key (opcional)
GOOGLE_PLACES_API_KEY=Sua_Chave_Places_Aqui
```

---

## 🎯 **Estratégias de Versionamento**

### **Estratégia 1: Versionar Plataformas (Atual)**
✅ **Vantagens:**
- Setup imediato para novos desenvolvedores
- Preserva customizações nativas
- Controle total sobre configurações

❌ **Desvantagens:**
- Pastas grandes no repositório
- Possíveis conflitos de merge

### **Estratégia 2: Regenerar Plataformas**
Para adotar, edite `.gitignore` e descomente:
```bash
# android/
# ios/
# web/
# windows/
# linux/
# macos/
```

✅ **Vantagens:**
- Repositório muito menor
- Sem conflitos de plataforma
- Sempre estruturas atualizadas

❌ **Desvantagens:**
- Setup inicial necessário
- Perde customizações nativas

---

## 🛠️ **Como Funciona Internamente**

### **build_with_config.dart:**
1. 🔍 Verifica variáveis de ambiente
2. 📱 Lê AndroidManifest.xml atual
3. 🔄 Remove configurações antigas
4. ➕ Injeta nova API key automaticamente
5. 💾 Salva arquivo configurado
6. 🏗️  Executa build do Flutter

### **Script de Desenvolvimento:**
1. 🔍 Verifica se `env.local` existe
2. ⚡ Executa `flutter run` com configurações
3. 📱 App roda com APIs reais

### **Script de Setup:**
1. 🏗️  Executa `flutter create --platforms=...`
2. 🔧 Configura placeholders automáticos
3. ✅ Estrutura pronta para uso

---

## 🆘 **Troubleshooting**

### **❌ "env.local não encontrado"**
```bash
cp env.template env.local
# Edite env.local com suas chaves
```

### **❌ "GOOGLE_MAPS_API_KEY não configurada"**
```bash
# Verifique o conteúdo do env.local
cat env.local

# Execute com o comando correto
./scripts/dev.sh
```

### **❌ "REQUEST_DENIED" no Google Maps**
1. Verifique se a API key está correta
2. Confirme que Google Maps API está ativada
3. Verifique restrições da chave no Google Console

### **❌ Build falhou**
```bash
# Limpe e reconfigure
flutter clean
flutter pub get
./scripts/build.sh
```

### **❌ Estrutura de plataforma corrompida**
```bash
# Recrie a plataforma
dart run scripts/setup_project.dart --recreate android
```

---

## 🔄 **Comandos para Diferentes Cenários**

### **👨‍💻 Desenvolvedor Iniciante:**
```bash
# 1. Clone o projeto
git clone [repo-url]
cd metamorfose-app-flutter

# 2. Configure suas chaves
cp env.template env.local
# Edite env.local

# 3. Execute
./scripts/dev.sh
```

### **🏭 Deploy de Produção:**
```bash
# Configure variáveis do sistema
export GOOGLE_MAPS_API_KEY="chave_produção"

# Build
./scripts/build.sh android

# APK em: build/app/outputs/flutter-apk/app-release.apk
```

### **🔄 CI/CD:**
```bash
# No pipeline, configure as variáveis de ambiente
# e execute:
dart run scripts/build_with_config.dart --android
```

### **🆕 Nova Plataforma:**
```bash
# Adicionar Windows ao projeto
dart run scripts/setup_project.dart windows

# Build para Windows
./scripts/build.sh windows
```

---

## 🎯 **Benefícios da Solução**

### **🔐 Segurança:**
- ✅ Zero API keys hardcoded
- ✅ Arquivo `env.local` não versionado
- ✅ Configuração por ambiente

### **🚀 Produtividade:**
- ✅ Comando único para desenvolvimento
- ✅ Build automático para qualquer plataforma
- ✅ Setup de projeto automatizado

### **🔧 Flexibilidade:**
- ✅ Estratégia híbrida de versionamento
- ✅ Suporte a todas as plataformas Flutter
- ✅ Configuração centralizada

### **👥 Colaboração:**
- ✅ Setup consistente para todos os desenvolvedores
- ✅ Documentação clara e objetiva
- ✅ Scripts padronizados

---

## 📋 **Checklist de Implementação**

- [x] ✅ Scripts de desenvolvimento e build criados
- [x] ✅ Configuração automática do Android
- [x] ✅ Sistema de variáveis de ambiente seguro
- [x] ✅ Script de setup de plataformas
- [x] ✅ Estratégia híbrida de versionamento
- [x] ✅ Documentação completa
- [x] ✅ Environment.dart corrigido para APIs reais
- [x] ✅ Scripts executáveis configurados

---

## 🎉 **Pronto para Usar!**

A configuração está **completamente automatizada**. Agora você pode:

1. **Desenvolver:** `./scripts/dev.sh`
2. **Fazer build:** `./scripts/build.sh android`
3. **Setup projeto:** `dart run scripts/setup_project.dart android ios web`

**🔥 Tudo automático, seguro e flexível!** 