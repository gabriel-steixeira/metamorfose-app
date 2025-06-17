# 🔧 Correção: Permissões de Localização no Android

## 🎯 Problema Identificado
As permissões de localização não estavam sendo solicitadas corretamente no Android quando o usuário acessava a tela de mapa (`map_screen.dart`).

## ✅ Correções Implementadas

### 1. **AndroidManifest.xml - Configurações Melhoradas**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.metamorfose_app">
    
    <!-- Permissões para localização -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET" />
    
    <!-- Características opcionais para compatibilidade -->
    <uses-feature 
        android:name="android.hardware.location" 
        android:required="false" />
    <uses-feature 
        android:name="android.hardware.location.gps" 
        android:required="false" />
    <uses-feature 
        android:name="android.hardware.location.network" 
        android:required="false" />
```

**Mudanças:**
- ✅ Adicionado atributo `package` no manifest
- ✅ Adicionadas `uses-feature` para melhor compatibilidade
- ✅ Permissões já estavam corretas

### 2. **MapScreen - Tratamento de Permissões Robusto**

#### **Inicialização Melhorada:**
```dart
@override
void initState() {
  super.initState();
  // Aguarda um pequeno delay para garantir que a tela foi totalmente carregada
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkAndRequestPermissions();
  });
}
```

#### **Verificação Forçada de Permissões:**
```dart
Future<void> _checkAndRequestPermissions() async {
  LocationPermission permission = await Geolocator.checkPermission();
  
  if (permission == LocationPermission.denied || 
      permission == LocationPermission.unableToDetermine) {
    await Future.delayed(const Duration(milliseconds: 500));
    _getCurrentLocation();
  } else {
    _getCurrentLocation();
  }
}
```

#### **Solicitação de Permissão Aprimorada:**
```dart
// Se a permissão foi negada ou não determinada, solicita novamente
if (permission == LocationPermission.denied || 
    permission == LocationPermission.unableToDetermine) {
  
  // Aguarda um pouco antes de solicitar para garantir que a UI está pronta
  await Future.delayed(const Duration(milliseconds: 300));
  
  permission = await Geolocator.requestPermission();
}
```

#### **Configurações de Localização Otimizadas:**
```dart
Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.medium, // Mais rápido que HIGH
  timeLimit: const Duration(seconds: 15),   // Timeout maior
  forceAndroidLocationManager: false,       // Usa FusedLocationProvider
);
```

### 3. **Diálogos Informativos Adicionados**

- ✅ **Serviço de localização desabilitado** - Com botão para abrir configurações
- ✅ **Permissão negada** - Com opção de tentar novamente
- ✅ **Permissão negada permanentemente** - Com redirecionamento para configurações do app
- ✅ **Erro de localização genérico** - Com detalhes do erro

### 4. **UI Melhorada para Erro de Localização**

```dart
// Botão "Tentar Novamente" na tela quando localização falha
ElevatedButton(
  onPressed: () {
    setState(() {
      _isLoadingLocation = true;
    });
    _getCurrentLocation();
  },
  child: const Text('Tentar Novamente'),
)
```

### 5. **Logs de Debug Implementados**

```dart
print('[DEBUG] Iniciando processo de obtenção de localização...');
print('[DEBUG] Serviço de localização habilitado: $serviceEnabled');
print('[DEBUG] Permissão atual: $permission');
print('[DEBUG] Solicitando permissão de localização...');
print('[DEBUG] Permissão após solicitação: $permission');
print('[DEBUG] Localização obtida: ${position.latitude}, ${position.longitude}');
```

## 🧪 Como Testar

### 1. **Primeira Execução (Permissão Nunca Solicitada)**
1. Execute: `flutter run -d SEU_DISPOSITIVO`
2. Navegue para a tela de mapa
3. **DEVE aparecer o popup de permissão de localização**
4. Aceite a permissão
5. Verifique se o mapa carrega com sua localização

### 2. **Permissão Negada**
1. Vá em Configurações > Apps > Metamorfose App > Permissões
2. Desabilite "Localização"
3. Abra o app e navegue para o mapa
4. **DEVE aparecer diálogo explicativo**
5. Teste o botão "Tentar Novamente"

### 3. **Serviço de Localização Desabilitado**
1. Desabilite o GPS do dispositivo
2. Abra o app e navegue para o mapa
3. **DEVE aparecer diálogo para habilitar localização**
4. Teste o botão "Abrir Configurações"

### 4. **Verificar Logs**
No terminal ou Android Studio, procure por:
```
[DEBUG] Iniciando processo de obtenção de localização...
[DEBUG] Permissão atual: LocationPermission.denied
[DEBUG] Solicitando permissão de localização...
```

## 🔍 Troubleshooting

### **Se AINDA não solicitar permissão:**

1. **Limpe completamente o app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run --uninstall-first
   ```

2. **Verifique nas configurações do dispositivo:**
   - Android: Configurações > Apps > Metamorfose App > Permissões
   - Certifique-se de que "Localização" está como "Não permitido"

3. **Desinstale manualmente o app** e instale novamente

4. **Verifique se o GPS está ligado** no dispositivo

5. **Teste em dispositivo físico** (não funciona bem no emulador)

### **Se aparecer erro de API Key:**
- A API Key do Google Maps está configurada, mas pode ter restrições
- Para produção, configure sua própria API Key

### **Se a localização demorar muito:**
- Normal em primeira execução
- O timeout foi aumentado para 15 segundos
- Verifique se há conexão com internet

## 📱 Comportamentos Esperados

| Cenário | Comportamento Esperado |
|---------|----------------------|
| Primeira vez | Popup de permissão aparece automaticamente |
| Permissão aceita | Mapa carrega com localização em azul |
| Permissão negada | Diálogo explicativo + botão "Tentar Novamente" |
| GPS desligado | Diálogo para ativar serviço de localização |
| Erro de rede | Diálogo de erro com opção de retry |

## 🎯 Status
- ✅ **AndroidManifest.xml**: Configurado corretamente
- ✅ **Código Dart**: Tratamento robusto implementado
- ✅ **UI/UX**: Diálogos informativos adicionados
- ✅ **Debug**: Logs detalhados implementados
- ✅ **Build**: Projeto limpo e dependências atualizadas

**O problema de permissões deve estar resolvido. Teste agora no seu dispositivo Android!** 🚀 