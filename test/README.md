# Testes de QA - Aplicativo Metamorfose

Este diretório contém todos os testes de qualidade (QA) para o aplicativo Metamorfose Flutter.

## 📁 Estrutura dos Testes

```
test/
├── unit/                    # Testes unitários
│   ├── models/             # Testes de modelos de dados
│   └── blocs/              # Testes de BLoCs
├── widget/                 # Testes de widget
│   └── components/         # Testes de componentes UI
├── integration_test/       # Testes de integração
├── test_helpers/           # Utilitários e mocks
├── run_tests.dart          # Script para executar todos os testes
├── test_config.dart        # Configurações de teste
└── README.md              # Este arquivo
```

## 🧪 Tipos de Testes

### 1. Testes Unitários (`test/unit/`)
- **Modelos**: Testam serialização, validação e métodos de modelos
- **BLoCs**: Testam lógica de negócio e gerenciamento de estado
- **Serviços**: Testam funcionalidades de serviços (com mocks)

### 2. Testes de Widget (`test/widget/`)
- **Componentes**: Testam renderização e interação de componentes UI
- **Telas**: Testam comportamento de telas completas
- **Responsividade**: Testam adaptação a diferentes tamanhos de tela

### 3. Testes de Integração (`integration_test/`)
- **Fluxos Completos**: Testam jornadas do usuário end-to-end
- **Navegação**: Testam transições entre telas
- **Persistência**: Testam salvamento e carregamento de dados

## 🚀 Como Executar os Testes

### Executar Todos os Testes
```bash
# Executa todos os testes
flutter test

# Executa com cobertura
flutter test --coverage

# Executa com relatório detalhado
flutter test --reporter expanded
```

### Executar Testes Específicos
```bash
# Apenas testes unitários
flutter test test/unit/

# Apenas testes de widget
flutter test test/widget/

# Apenas testes de integração
flutter test integration_test/

# Teste específico
flutter test test/unit/models/user_model_test.dart
```

### Executar com Script Personalizado
```bash
# Usa o script de execução personalizado
dart test/run_tests.dart
```

## 📊 Cobertura de Testes

### Objetivos de Cobertura
- **Mínimo**: 80% de cobertura de código
- **Ideal**: 90%+ de cobertura de código
- **Crítico**: 100% para BLoCs e modelos

### Gerar Relatório de Cobertura
```bash
# Gera relatório HTML
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Abre relatório no navegador
open coverage/html/index.html
```

## 🔧 Configurações

### Variáveis de Ambiente
```bash
# Configurações de teste
export FLAVOR=test
export ENVIRONMENT=testing
export DEBUG=true
export MOCK_API=true
```

### Configurações de Dispositivo
- **Mobile**: 400x800 pixels
- **Tablet**: 800x600 pixels
- **Desktop**: 1200x800 pixels

## 📝 Escrevendo Novos Testes

### Estrutura de um Teste
```dart
import 'package:flutter_test/flutter_test.dart';
import '../test_helpers/test_utils.dart';

void main() {
  group('Nome do Grupo', () {
    testWidgets('descrição do teste', (WidgetTester tester) async {
      // Arrange
      await TestUtils.pumpAndSettle(tester, widget);
      
      // Act
      await TestUtils.tapWidget(tester, finder);
      
      // Assert
      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

### Convenções de Nomenclatura
- **Arquivos**: `nome_do_teste_test.dart`
- **Grupos**: `NomeDoComponente`
- **Testes**: `deve [comportamento esperado]`
- **Variáveis**: `camelCase`

### Boas Práticas
1. **AAA Pattern**: Arrange, Act, Assert
2. **Testes Independentes**: Cada teste deve ser independente
3. **Nomes Descritivos**: Descreva claramente o que está sendo testado
4. **Mocks**: Use mocks para dependências externas
5. **Limpeza**: Limpe recursos após cada teste

## 🐛 Debugging de Testes

### Executar com Debug
```bash
# Executa com logs detalhados
flutter test --verbose

# Executa teste específico com debug
flutter test test/unit/models/user_model_test.dart --verbose
```

### Logs de Teste
```dart
// Habilitar logs no teste
debugPrint('Debug message');
print('Test log message');
```

## 📈 Métricas de Qualidade

### Critérios de Aprovação
- ✅ Todos os testes passam
- ✅ Cobertura mínima de 80%
- ✅ Sem vazamentos de memória
- ✅ Performance dentro dos limites
- ✅ Acessibilidade validada

### Relatórios Automáticos
- **Cobertura**: `coverage/html/index.html`
- **Performance**: `performance_reports/`
- **Acessibilidade**: `accessibility_reports/`

## 🔄 Integração Contínua

### GitHub Actions
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test --coverage
```

### Pré-commit Hooks
```bash
# Instalar hooks
flutter packages pub run build_runner build
flutter test --coverage
```

## 📚 Recursos Adicionais

- [Documentação Flutter Testing](https://docs.flutter.dev/testing)
- [BLoC Testing](https://bloclibrary.dev/#/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

## 🤝 Contribuindo

1. **Sempre escreva testes** para novas funcionalidades
2. **Mantenha a cobertura** acima de 80%
3. **Execute todos os testes** antes de fazer commit
4. **Documente** casos de teste complexos
5. **Atualize** este README quando necessário

---

**Squad Metamorfose** - 
Ester Santos 
Evelin Brandão 
Gabriel Teixeira
Pabllo Vinicyus 
Vitoria Lana 
