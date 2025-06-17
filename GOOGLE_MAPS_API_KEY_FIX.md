# 🔑 Correção: API Key do Google Maps

## 🚨 Problema: "API Key não encontrada"

Se você está vendo a mensagem de API Key não encontrada no mapa, siga estes passos:

## ✅ Soluções Implementadas

### 1. **Configuração Android** ✅
- API Key configurada em `android/app/src/main/AndroidManifest.xml`
- Duas meta-data para compatibilidade:
  ```xml
  <meta-data android:name="com.google.android.geo.API_KEY"
             android:value="AIzaSyD2DQAH9nE9Q-IFLNyvv7-X8Vwrw_cEWlk"/>
  <meta-data android:name="com.google.android.gms.maps.v2.API_KEY"
             android:value="AIzaSyD2DQAH9nE9Q-IFLNyvv7-X8Vwrw_cEWlk"/>
  ```

### 2. **Configuração iOS** ✅
- API Key configurada em `ios/Runner/AppDelegate.swift`
- Import do GoogleMaps adicionado
- Configuração no `didFinishLaunchingWithOptions`

## 🔧 Verificações Necessárias

### **1. Verificar se a API Key está ativa:**
1. Acesse: https://console.cloud.google.com/
2. Selecione seu projeto
3. Vá em **APIs & Serviços** > **Credenciais**
4. Clique na API Key: `AIzaSyD2DQAH9nE9Q-IFLNyvv7-X8Vwrw_cEWlk`

### **2. APIs que devem estar habilitadas:**
- ✅ **Maps SDK for Android**
- ✅ **Maps SDK for iOS** (se usar iOS)
- ✅ **Places API** (para busca de floriculturas)

### **3. Restrições da API Key:**

#### **Para Desenvolvimento (Recomendado):**
- **Restrições de aplicativo:** `Nenhuma`
- **Restrições de API:** Apenas as APIs listadas acima

#### **Para Produção:**
- **Restrições de aplicativo:** `Aplicativos Android`
- **Nome do pacote:** `com.metamorfose.app`
- **SHA-1:** Obtido com `keytool -list -v -keystore ~/.android/debug.keystore`

## 🧪 Testando a Correção

### **1. Limpar e rebuildar:**
```bash
flutter clean
flutter pub get
flutter run
```

### **2. Verificar logs:**
Procure por mensagens como:
```
[Google Maps] API Key configurada com sucesso
[Google Maps] Mapa carregado
```

### **3. Se ainda não funcionar:**

#### **Opção A - Desabilitar restrições temporariamente:**
1. Google Console > Credenciais > Sua API Key
2. **Restrições de aplicativo:** `Nenhuma`
3. **Restrições de API:** `Não restringir chave`
4. Salvar e aguardar 2-5 minutos

#### **Opção B - Criar nova API Key:**
1. Google Console > Credenciais > **Criar Credenciais** > **Chave de API**
2. Copie a nova chave
3. Substitua nos arquivos:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/AppDelegate.swift`

## 📍 Status Atual

- ✅ **Android:** Configurado com meta-data dupla
- ✅ **iOS:** Configurado no AppDelegate
- ✅ **Dependências:** google_maps_flutter instalado
- ✅ **Permissões:** Localização configurada

## 🔍 Diagnóstico Adicional

Se o problema persistir, verifique:

1. **Conexão com internet**
2. **Google Play Services** atualizado no dispositivo
3. **Quota da API** não excedida
4. **Faturamento habilitado** no Google Cloud (necessário para produção)

## 📱 Teste no Dispositivo

1. Execute o app no dispositivo físico
2. Navegue para a tela de mapa
3. Aguarde a solicitação de permissão de localização
4. O mapa deve carregar normalmente

**Se seguir estes passos, o Google Maps deve funcionar perfeitamente! 🗺️** 