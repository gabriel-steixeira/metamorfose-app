# 🗺️ Configuração do Google Maps - Metamorfose App

## ✅ Passos Concluídos

### 1. Dependências Adicionadas ✅
- `google_maps_flutter: ^2.5.0`
- `geolocator: ^10.1.0`

### 2. Permissões Android Configuradas ✅
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`
- `INTERNET`

### 3. Código Atualizado ✅
- Importações do Google Maps e Geolocator
- Métodos de localização implementados
- Marcadores no mapa configurados

## 🔑 Próximos Passos - OBRIGATÓRIOS

### 1. Obter API Key do Google Maps

1. **Acesse o Google Cloud Console**:
   - Vá para: https://console.cloud.google.com/

2. **Criar/Selecionar Projeto**:
   - Crie um novo projeto ou selecione um existente
   - Nome sugerido: "Metamorfose App"

3. **Ativar APIs Necessárias**:
   - Maps SDK for Android
   - Maps SDK for iOS (se for usar iOS)
   - Geocoding API (opcional, para busca de endereços)

4. **Criar API Key**:
   - Vá em "Credenciais" → "Criar Credenciais" → "Chave de API"
   - Copie a chave gerada

5. **Restringir a API Key** (IMPORTANTE para segurança):
   - Clique na API Key criada
   - Em "Restrições da aplicação", selecione "Apps Android"
   - Adicione o nome do pacote: `com.example.conversao_flutter`
   - Em "Restrições de API", selecione as APIs ativadas acima

### 2. Configurar a API Key no Projeto

**Substitua no arquivo `android/app/src/main/AndroidManifest.xml`:**

```xml
<!-- Google Maps API Key -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_API_KEY_AQUI" />
```

**Por:**

```xml
<!-- Google Maps API Key -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyD2DQAH9nE9Q-IFLNyvv7-X8Vwrw_cEWlk" />
```

### 3. Para iOS (se necessário)

Adicione no arquivo `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("SUA_CHAVE_API_AQUI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 🧪 Testando o Google Maps

1. **Execute o projeto**:
   ```bash
   flutter run
   ```

2. **Navegue para a tela de mapa**

3. **Permita acesso à localização** quando solicitado

4. **Verifique se**:
   - O mapa carrega corretamente
   - Sua localização aparece (marcador azul)
   - As floriculturas aparecem como marcadores coloridos
   - Verde = Aberto, Vermelho = Fechado

## 🔧 Troubleshooting

### Erro: "MissingPluginException"
- Execute: `flutter clean && flutter pub get`
- Rebuild do projeto

### Erro: "API Key inválida"
- Verifique se a API Key está correta
- Confirme se as APIs estão ativadas no Google Cloud Console
- Verifique as restrições da API Key

### Localização não funciona
- Verifique se as permissões estão no AndroidManifest.xml
- Teste em dispositivo físico (não funciona bem no emulador)
- Confirme que o GPS está ligado no dispositivo

### Mapa não carrega
- Verifique conexão com internet
- Confirme que a API Key tem permissão para Maps SDK for Android
- Verifique se o nome do pacote está correto nas restrições

## 💰 Custos

O Google Maps oferece:
- **$200 de créditos gratuitos por mês**
- Até ~28.000 visualizações de mapa gratuitas
- Monitore o uso no Google Cloud Console

## 🔐 Segurança

**NUNCA commite a API Key no código!**

Para produção, considere:
- Usar variáveis de ambiente
- Configurar restrições rigorosas na API Key
- Monitorar uso no Google Cloud Console

---

**Status**: ✅ Configuração técnica completa - Aguardando API Key do Google 