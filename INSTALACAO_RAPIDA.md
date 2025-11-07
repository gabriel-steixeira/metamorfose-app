# 🚀 Guia de Instalação Rápida - Metamorfose App

> **Para eventos e demonstrações rápidas**

Este guia foi criado para facilitar o download e execução do projeto em eventos de 1 dia. Siga os passos abaixo para ter o app rodando rapidamente.

## ⚡ Instalação em 5 Minutos

### 1️⃣ Pré-requisitos

Certifique-se de ter instalado:

- ✅ **Flutter SDK 3.0+** ([Download](https://docs.flutter.dev/get-started/install))
- ✅ **Dart 3.0+** (vem com Flutter)
- ✅ **Android Studio** ou **VS Code** com extensão Flutter
- ✅ **Git** ([Download](https://git-scm.com/downloads))

**Verificar instalação:**
```bash
flutter --version
dart --version
git --version
```

### 2️⃣ Clonar/Baixar o Projeto

**Opção A - Via Git:**
```bash
git clone <URL_DO_REPOSITORIO>
cd metamorfose-app-demo
```

**Opção B - Download ZIP:**
1. Baixe o ZIP do repositório
2. Extraia em uma pasta
3. Abra o terminal na pasta extraída

### 3️⃣ Instalar Dependências

```bash
# Navegar para a pasta do projeto
cd metamorfose-app-demo

# Obter as dependências do Flutter
flutter pub get
```

⏱️ **Tempo estimado:** 2-3 minutos

### 4️⃣ Verificar Configuração

O projeto já vem com as chaves de API configuradas para demonstração:
- ✅ Firebase (configurado)
- ✅ Google Maps (configurado)
- ✅ Gemini AI (configurado)

**Não é necessário configurar variáveis de ambiente!**

### 5️⃣ Executar o App

**Para Android:**
```bash
# Conectar um dispositivo Android ou iniciar um emulador
flutter run
```

**Para iOS (apenas macOS):**
```bash
flutter run
```

**Para Web:**
```bash
flutter run -d chrome
```

**Para Windows:**
```bash
flutter run -d windows
```

### 6️⃣ Build para APK (Opcional)

Se quiser gerar um APK para distribuir:

```bash
# Build de debug (mais rápido)
flutter build apk --debug

# Build de release (otimizado)
flutter build apk --release
```

O APK estará em: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔧 Solução de Problemas Comuns

### Erro: "Flutter not found"
```bash
# Adicione Flutter ao PATH do sistema
# Windows: Adicione ao PATH do sistema
# Linux/Mac: Adicione ao ~/.bashrc ou ~/.zshrc
export PATH="$PATH:[CAMINHO_DO_FLUTTER]/bin"
```

### Erro: "No devices found"
```bash
# Verificar dispositivos conectados
flutter devices

# Iniciar emulador Android
# No Android Studio: Tools > Device Manager > Start emulador
```

### Erro: "Pub get failed"
```bash
# Limpar cache e tentar novamente
flutter clean
flutter pub get
```

### Erro de dependências nativas
```bash
# Reinstalar dependências nativas
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Erro de permissões (Android)
Verifique se o arquivo `android/app/src/main/AndroidManifest.xml` tem as permissões necessárias (já configurado no projeto).

---

## 📱 Plataformas Suportadas

- ✅ **Android** (API 21+)
- ✅ **iOS** (11.0+)
- ✅ **Web** (Chrome, Firefox, Edge)
- ✅ **Windows** (10+)
- ✅ **macOS** (10.14+)
- ✅ **Linux** (Ubuntu 18.04+)

---

## 🎯 Checklist Rápido para o Evento

Antes de disponibilizar o projeto, verifique:

- [ ] Flutter instalado e funcionando (`flutter doctor`)
- [ ] Dependências instaladas (`flutter pub get`)
- [ ] Projeto compila sem erros (`flutter build apk --debug`)
- [ ] README.md atualizado
- [ ] Este guia (INSTALACAO_RAPIDA.md) presente
- [ ] Arquivos sensíveis não expostos (já configurado no .gitignore)
- [ ] Teste em pelo menos uma plataforma (Android recomendado)

---

## 📦 Estrutura do Projeto

```
metamorfose-app-demo/
├── lib/                    # Código fonte Dart
│   ├── blocs/             # Gerenciamento de estado (BLoC)
│   ├── screens/           # Telas do aplicativo
│   ├── services/          # Serviços (Firebase, APIs, etc)
│   ├── models/            # Modelos de dados
│   └── config/            # Configurações
├── assets/                # Imagens, ícones, fontes
├── android/               # Configuração Android
├── ios/                   # Configuração iOS
├── web/                   # Configuração Web
├── pubspec.yaml           # Dependências do projeto
└── README.md              # Documentação principal
```

---

## 🆘 Precisa de Ajuda?

### Comandos Úteis

```bash
# Verificar status do Flutter
flutter doctor

# Ver dispositivos disponíveis
flutter devices

# Limpar build
flutter clean

# Atualizar dependências
flutter pub upgrade

# Ver logs em tempo real
flutter logs
```

### Informações do Projeto

- **Versão:** 1.0.0+1
- **Flutter SDK:** >=3.0.0 <4.0.0
- **Dart SDK:** >=3.0.0 <4.0.0
- **Arquitetura:** Clean Architecture + BLoC

---

## ✅ Pronto para Usar!

O projeto está configurado e pronto para demonstração. Todas as chaves de API necessárias já estão configuradas no código para facilitar o uso em eventos.

**Tempo total de instalação:** ~5 minutos

**Boa demonstração! 🦋**

