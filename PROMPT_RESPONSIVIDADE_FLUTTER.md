# 🚀 Prompt para Implementação de Responsividade em Flutter

## 📋 **Contexto e Objetivo**

Este prompt serve como guia completo para implementar responsividade em telas e componentes Flutter usando a biblioteca `responsive_framework: ^1.5.1`, seguindo as melhores práticas de desenvolvimento e código limpo.

## 🛠️ **Pré-requisitos**

### 1. **Dependência Obrigatória**
```yaml
dependencies:
  responsive_framework: ^1.5.1
```

### 2. **Configuração no app.dart**
```dart
import 'package:responsive_framework/responsive_framework.dart';

// No MaterialApp.router
builder: (context, child) => ResponsiveBreakpoints.builder(
  child: child!,
  breakpoints: [
    const Breakpoint(start: 0, end: 450, name: MOBILE),
    const Breakpoint(start: 451, end: 800, name: TABLET),
    const Breakpoint(start: 801, end: 1920, name: DESKTOP),
    const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
  ],
),
```

## 📱 **Breakpoints Padrão**

| Dispositivo | Largura | Nome |
|-------------|---------|------|
| Mobile | 0-450px | `MOBILE` |
| Tablet | 451-800px | `TABLET` |
| Desktop | 801-1920px | `DESKTOP` |
| 4K | 1921px+ | `'4K'` |

## 🎯 **Padrão de Implementação**

### **1. Import Obrigatório**
```dart
import 'package:responsive_framework/responsive_framework.dart';
```

### **2. Estrutura de ResponsiveValue**
```dart
final valorResponsivo = ResponsiveValue<double>(
  context,
  defaultValue: VALOR_PADRAO,
  conditionalValues: [
    Condition.smallerThan(name: MOBILE, value: VALOR_MOBILE),
    Condition.largerThan(name: TABLET, value: VALOR_TABLET),
  ],
).value;
```

### **3. Detecção de Dispositivo**
```dart
final isMobile = ResponsiveBreakpoints.of(context).isMobile;
final isTablet = ResponsiveBreakpoints.of(context).isTablet;
final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
```

## 📏 **Valores Responsivos Padrão**

### **Espaçamentos (Padding/Margin)**
```dart
// Mobile: 12px | Padrão: 16px | Tablet+: 20px
final padding = ResponsiveValue<double>(
  context,
  defaultValue: 16.0,
  conditionalValues: [
    Condition.smallerThan(name: MOBILE, value: 12.0),
    Condition.largerThan(name: TABLET, value: 20.0),
  ],
).value;

// Mobile: 16px | Padrão: 24px | Tablet+: 32px
final margin = ResponsiveValue<double>(
  context,
  defaultValue: 24.0,
  conditionalValues: [
    Condition.smallerThan(name: MOBILE, value: 16.0),
    Condition.largerThan(name: TABLET, value: 32.0),
  ],
).value;
```

### **Tamanhos de Fonte**
```dart
// Mobile: 14px | Padrão: 16px | Tablet+: 18px
final fontSize = ResponsiveValue<double>(
  context,
  defaultValue: 16.0,
  conditionalValues: [
    Condition.smallerThan(name: MOBILE, value: 14.0),
    Condition.largerThan(name: TABLET, value: 18.0),
  ],
).value;
```

### **Alturas de Componentes**
```dart
// Mobile: 40px | Padrão: 43px | Tablet+: 52px
final height = ResponsiveValue<double>(
  context,
  defaultValue: 43.0,
  conditionalValues: [
    Condition.smallerThan(name: MOBILE, value: 40.0),
    Condition.largerThan(name: TABLET, value: 52.0),
  ],
).value;
```

### **Border Radius**
```dart
// Mobile: 10px | Padrão: 12px | Tablet+: 16px
final borderRadius = ResponsiveValue<double>(
  context,
  defaultValue: 12.0,
  conditionalValues: [
    Condition.smallerThan(name: MOBILE, value: 10.0),
    Condition.largerThan(name: TABLET, value: 16.0),
  ],
).value;
```

### **Tamanhos de Ícones**
```dart
// Mobile: 24px | Padrão: 28px | Tablet+: 32px
final iconSize = ResponsiveValue<double>(
  context,
  defaultValue: 28.0,
  conditionalValues: [
    Condition.smallerThan(name: MOBILE, value: 24.0),
    Condition.largerThan(name: TABLET, value: 32.0),
  ],
).value;
```

## 🔧 **Implementação em Componentes**

### **Template Básico para Componentes**
```dart
class MeuComponente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Definir valores responsivos
    final height = ResponsiveValue<double>(
      context,
      defaultValue: 43.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 52.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    // 2. Usar os valores no widget
    return Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        'Texto',
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
```

## 🖥️ **Implementação em Telas**

### **Template Básico para Telas**
```dart
class MinhaTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Valores responsivos globais
    final horizontalMargin = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    // 2. Layout responsivo
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: isMobile 
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Layout em coluna para mobile
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Layout em linha para desktop
      ],
    );
  }
}
```

## 📝 **Truncamento de Texto**

### **Implementação Padrão**
```dart
Text(
  'Texto que pode ser longo',
  style: TextStyle(fontSize: fontSize),
  overflow: TextOverflow.ellipsis,
  maxLines: 1,
  textAlign: TextAlign.center,
)
```

### **Para Textos Longos (Múltiplas Linhas)**
```dart
Text(
  'Texto longo que pode ocupar várias linhas',
  style: TextStyle(fontSize: fontSize),
  maxLines: 3,
  overflow: TextOverflow.ellipsis,
)
```

## 🔄 **Layouts Responsivos**

### **Layout Condicional**
```dart
// Layout baseado no tipo de dispositivo
if (ResponsiveBreakpoints.of(context).isMobile) {
  return _buildMobileLayout();
} else {
  return _buildDesktopLayout();
}
```

### **Layout Flexível**
```dart
Row(
  children: [
    Flexible(
      child: Text('Conteúdo que pode ser comprimido'),
    ),
    Expanded(
      child: Text('Conteúdo que ocupa espaço disponível'),
    ),
  ],
)
```

## ⚠️ **Boas Práticas Obrigatórias**

### **1. Código Limpo**
- ✅ Remover imports não utilizados
- ✅ Remover variáveis não utilizadas
- ✅ Usar `const` constructors quando possível
- ✅ Verificar com `flutter analyze` antes de finalizar

### **2. Performance**
- ✅ Usar `mounted` check em operações async
- ✅ Evitar rebuilds desnecessários
- ✅ Usar `Flexible` e `Expanded` adequadamente

### **3. Acessibilidade**
- ✅ Sempre definir `textAlign` para textos
- ✅ Usar `maxLines` e `overflow` apropriados
- ✅ Manter contraste adequado

## 🧪 **Teste de Responsividade**

### **Comandos para Testar**
```bash
# Mobile
flutter run -d chrome --web-browser-flag "--window-size=400,800"

# Tablet
flutter run -d chrome --web-browser-flag "--window-size=768,1024"

# Desktop
flutter run -d chrome --web-browser-flag "--window-size=1920,1080"
```

### **Verificação de Linting**
```bash
flutter analyze
```

## 📋 **Checklist de Implementação**

### **Para Componentes:**
- [ ] Import do `responsive_framework`
- [ ] Valores responsivos definidos (height, fontSize, padding, borderRadius)
- [ ] Uso dos valores no widget
- [ ] Truncamento de texto implementado
- [ ] Teste em diferentes tamanhos de tela
- [ ] Linting sem erros

### **Para Telas:**
- [ ] Import do `responsive_framework`
- [ ] Valores responsivos globais definidos
- [ ] Layout condicional implementado
- [ ] Métodos separados para mobile/desktop
- [ ] Espaçamentos responsivos aplicados
- [ ] Teste em diferentes tamanhos de tela
- [ ] Linting sem erros

## 🎯 **Exemplo Completo - Card Responsivo**

```dart
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveCard extends StatelessWidget {
  final String title;
  final String content;

  const ResponsiveCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    // Valores responsivos
    final height = ResponsiveValue<double>(
      context,
      defaultValue: 180.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 160.0),
        Condition.largerThan(name: TABLET, value: 200.0),
      ],
    ).value;

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final contentFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: contentFontSize,
                color: Colors.grey[600],
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🚀 **Resultado Esperado**

Com este prompt, você conseguirá implementar responsividade completa em qualquer tela ou componente Flutter, garantindo:

- ✅ **Adaptação perfeita** a diferentes tamanhos de tela
- ✅ **Código limpo** e bem estruturado
- ✅ **Performance otimizada**
- ✅ **Experiência de usuário consistente**
- ✅ **Manutenibilidade alta**

**Use este prompt como referência para todas as implementações de responsividade no projeto!** 🎉
