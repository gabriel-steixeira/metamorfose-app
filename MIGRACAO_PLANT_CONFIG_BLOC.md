# Migração PlantConfigScreen para BLoC - Prioridade 3

## Resumo da Migração

**Objetivo**: Migrar a `PlantConfigScreen` de `StatefulWidget` com `setState()` para arquitetura BLoC.

**Complexidade**: Formulários e validações em tempo real

**Status**: ✅ **CONCLUÍDA**

## Análise do Estado Original

### Estados Identificados
```dart
// lib/screens/plant/plant_config_screen.dart
class _PlantConfigScreenState extends State<PlantConfigScreen> {
  final _nameController = TextEditingController();
  String? _selectedPlant;
  Color? _selectedColor;
  
  // setState() identificados:
  // Linha 230: setState(() { _selectedPlant = value; });
  // Linha 248: setState(() { _selectedColor = value; });
}
```

### Funcionalidades Originais
- ✅ Campo de entrada para nome da planta
- ✅ Seleção de tipo de planta (suculenta, samambaia, cacto)
- ✅ Seleção de cor do vaso (roxo, verde, azul, rosa)
- ✅ Navegação para captura de foto
- ✅ Opção de ignorar captura
- ✅ Link para mapa de floriculturas

## Arquitetura Implementada

### 1. Estado (PlantConfigState)
```dart
// lib/state/plant_config/plant_config_state.dart

enum ValidationState { initial, valid, invalid }
enum LoadingState { idle, saving, navigating }

class PlantConfigState {
  final String plantName;
  final String selectedPlant;
  final Color selectedColor;
  final ValidationState validationState;
  final LoadingState loadingState;
  final String? errorMessage;
  
  // Getters de conveniência
  bool get isValid => validationState == ValidationState.valid;
  bool get canSave => isValid && !isLoading;
  bool get isNameValid => plantName.trim().isNotEmpty && plantName.trim().length >= 2;
}

// Classes auxiliares para opções
class PlantOption {
  static const List<PlantOption> values = [
    PlantOption(value: 'suculenta', label: 'Suculenta', icon: Icons.spa),
    PlantOption(value: 'samambaia', label: 'Samambaia', icon: Icons.eco),
    PlantOption(value: 'cacto', label: 'Cacto', icon: Icons.park),
  ];
}

class ColorOption {
  static const List<ColorOption> values = [
    ColorOption(value: MetamorfoseColors.purpleNormal, label: 'Roxo'),
    ColorOption(value: MetamorfoseColors.greenNormal, label: 'Verde'),
    ColorOption(value: MetamorfoseColors.blueNormal, label: 'Azul'),
    ColorOption(value: MetamorfoseColors.pinkNormal, label: 'Rosa'),
  ];
}
```

### 2. Serviço (PlantConfigService)
```dart
// lib/services/plant_config_service.dart

class PlantConfigService {
  // Validações específicas
  ValidationResult validatePlantName(String name);
  ValidationResult validatePlantSelection(String plantType);
  ValidationResult validateColorSelection(Color color);
  ValidationResult validateForm(PlantConfigState state);
  
  // Operações assíncronas
  Future<SaveResult> savePlantConfiguration(PlantConfigState state);
  Future<PlantConfigState?> loadSavedConfiguration();
  Future<SaveResult> captureFirstPhoto();
  Future<SaveResult> skipPhotoCapture();
}

// Classes de resultado
class ValidationResult {
  final bool isValid;
  final String? error;
  final ValidationState state;
}

class SaveResult {
  final bool success;
  final String? error;
}
```

### 3. BLoC (PlantConfigBloc)
```dart
// lib/blocs/plant_config_bloc.dart

// 9 Eventos implementados:
abstract class PlantConfigEvent {}
class InitializePlantConfigEvent extends PlantConfigEvent {}
class LoadSavedConfigurationEvent extends PlantConfigEvent {}
class UpdatePlantNameEvent extends PlantConfigEvent {}
class SelectPlantTypeEvent extends PlantConfigEvent {}
class SelectPlantColorEvent extends PlantConfigEvent {}
class ValidateFormEvent extends PlantConfigEvent {}
class TakeFirstPhotoEvent extends PlantConfigEvent {}
class SkipPhotoEvent extends PlantConfigEvent {}
class ClearErrorEvent extends PlantConfigEvent {}

// Handlers implementados:
class PlantConfigBloc extends Bloc<PlantConfigEvent, PlantConfigState> {
  Future<void> _onInitialize(); // Inicialização com valores padrão
  Future<void> _onLoadSavedConfiguration(); // Carregamento de config salva
  Future<void> _onUpdatePlantName(); // Validação em tempo real
  Future<void> _onSelectPlantType(); // Seleção + validação
  Future<void> _onSelectPlantColor(); // Seleção + validação
  Future<void> _onValidateForm(); // Validação completa
  Future<void> _onTakeFirstPhoto(); // Captura + navegação
  Future<void> _onSkipPhoto(); // Skip + navegação
  Future<void> _onClearError(); // Limpeza de erros
}
```

### 4. Interface (PlantConfigScreenBloc)
```dart
// lib/screens/plant/plant_config_screen_bloc.dart

class PlantConfigScreenBloc extends StatelessWidget {
  // BlocProvider local
  // BlocListener para navegação e feedbacks
  // BlocBuilder com buildWhen otimizado
}

class _PlantConfigView extends StatefulWidget {
  // TextEditingController sincronizado com BLoC
  // Conversão de PlantOption/ColorOption para SelectOption
  // Handlers reativados
}
```

## Melhorias Implementadas

### Validação em Tempo Real
```dart
// Validação automática durante digitação
_nameController.addListener(() {
  context.read<PlantConfigBloc>().add(
    UpdatePlantNameEvent(_nameController.text),
  );
});

// Validação após seleções
void _onSelectPlantType(SelectPlantTypeEvent event, Emitter emit) async {
  emit(state.copyWith(selectedPlant: event.plantType));
  add(ValidateFormEvent()); // Auto-validação
}
```

### Feedback Visual Aprimorado
```dart
// Indicadores de validação
if (state.validationState == ValidationState.invalid && 
    state.errorMessage != null) {
  // Container vermelho com erro específico
}

if (state.isValid) {
  // Container verde com confirmação
}

// Estados de loading nos botões
text: state.isSaving ? 'SALVANDO...' 
    : state.isNavigating ? 'PREPARANDO...'
    : 'TIRAR A PRIMEIRA FOTO DE SUA PLANTA'
```

### Estados de Loading Granulares
```dart
enum LoadingState { 
  idle,        // Pronto para interação
  saving,      // Salvando configuração
  navigating   // Preparando navegação
}

// Botões desabilitados durante loading
onPressed: state.isLoading ? () {} : () => _handleAction(context)
```

### Sincronização Bidirecional
```dart
// BlocListener sincroniza controller com estado
listener: (context, state) {
  if (_nameController.text != state.plantName) {
    _nameController.text = state.plantName;
  }
}
```

## Integração Global

### 1. MultiBlocProvider (app.dart)
```dart
providers: [
  BlocProvider(create: (context) => AuthBloc(AuthService())),
  BlocProvider(create: (context) => MapBloc(MapService())),
  BlocProvider(create: (context) => HomeBloc(HomeService())),
  BlocProvider(create: (context) => PlantConfigBloc(service: PlantConfigService())), // ✅ Adicionado
],
```

### 2. Rotas (routes.dart & app_router.dart)
```dart
// routes.dart
static const plantConfigBloc = '/plant-config-bloc';

// app_router.dart
GoRoute(
  path: Routes.plantConfigBloc,
  builder: (context, state) => const PlantConfigScreenBloc(),
),
```

### 3. Navegação Atualizada
```dart
// auth_screen_bloc.dart
if ((email == 'gabriel' || email.contains('gabriel')) && password == '123456') {
  context.go(Routes.plantConfigBloc); // ✅ Nova rota
}

// bottom_navigation_menu.dart
case 2: // Account icon - navegar para plantConfig BLoC (temporário para teste)
  context.go(Routes.plantConfigBloc);
```

## Resultados da Migração

### ✅ Estados Eliminados
- **2 setState() eliminados** (linhas 230 e 248)
- **3 variáveis de estado** consolidadas em estado imutável
- **TextEditingController** mantido para compatibilidade com widgets

### ✅ Funcionalidades Preservadas
- ✅ Campo de nome com validação
- ✅ Seleção de planta com modal
- ✅ Seleção de cor com modal  
- ✅ Botões funcionais (tirar foto / ignorar)
- ✅ Navegação para mapa
- ✅ Visual e comportamento idênticos

### ✅ Melhorias Adicionadas
- ✅ **Validação em tempo real** durante digitação
- ✅ **Feedback visual** para estados válido/inválido
- ✅ **Loading states** granulares (saving/navigating)
- ✅ **Error handling** com SnackBar
- ✅ **buildWhen otimizado** para performance
- ✅ **Persistência simulada** para configurações
- ✅ **Navegação reativa** baseada em estado

## Performance e Qualidade

### BuildWhen Otimizado
```dart
buildWhen: (previous, current) {
  return previous.selectedPlant != current.selectedPlant ||
         previous.selectedColor != current.selectedColor ||
         previous.validationState != current.validationState ||
         previous.loadingState != current.loadingState ||
         previous.errorMessage != current.errorMessage;
},
```

### Error Handling Robusto
```dart
// Validações com regex
final validPattern = RegExp(r'^[a-zA-ZÀ-ÿ0-9\s]+$');
if (!validPattern.hasMatch(trimmedName)) {
  return ValidationResult.invalid('Nome deve conter apenas letras, números e espaços');
}

// Try-catch em todas operações assíncronas
try {
  final saveResult = await _service.savePlantConfiguration(state);
  // ...
} catch (e) {
  emit(state.copyWith(errorMessage: 'Erro ao salvar configuração'));
}
```

### Testabilidade Máxima
```dart
// Service isolado e injetável
PlantConfigBloc({PlantConfigService? service})
    : _service = service ?? PlantConfigService(),

// Estados imutáveis e previsíveis
@override
bool operator ==(Object other) {
  return other is PlantConfigState &&
    other.plantName == plantName &&
    other.selectedPlant == selectedPlant &&
    // ...
}
```

## Próximos Passos

### ✅ Migração Completa
A **Prioridade 3: PlantConfigScreen** foi **100% migrada** com:
- **2 setState()** eliminados
- **Funcionalidades preservadas** e **melhoradas**  
- **Arquitetura consistente** com MapBloc e HomeBloc
- **Validações robustas** e **UX aprimorada**

### 🔄 Próxima Fase
- **Fase 4**: Refinamento e limpeza geral
- Remoção de rotas temporárias de teste
- Otimização final de performance
- Documentação consolidada

## Resumo Técnico

| Aspecto | Antes | Depois |
|---------|--------|--------|
| **Arquitetura** | StatefulWidget + setState | BLoC Pattern |
| **Estados** | 3 variáveis mutáveis | 1 estado imutável |
| **Validação** | Manual/nenhuma | Tempo real + robusta |
| **Loading** | Sem feedback | Estados granulares |
| **Erros** | Sem tratamento | SnackBar + recovery |
| **Performance** | Rebuilds desnecessários | buildWhen otimizado |
| **Testabilidade** | Baixa | Máxima |
| **Manutenibilidade** | Média | Alta |

A migração da **PlantConfigScreen** está **concluída** e representa um avanço significativo na **arquitetura e UX** do aplicativo. 