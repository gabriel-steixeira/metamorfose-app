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
  conditionalValues: const [
    Condition.smallerThan(name: MOBILE, value: VALOR_MOBILE),
    Condition.largerThan(name: TABLET, value: VALOR_TABLET),
  ],
).value;
```

**⚠️ IMPORTANTE:** Sempre use `const` nos `conditionalValues` para melhor performance!

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
  conditionalValues: const [
    Condition.smallerThan(name: MOBILE, value: 12.0),
    Condition.largerThan(name: TABLET, value: 20.0),
  ],
).value;

// Mobile: 16px | Padrão: 24px | Tablet+: 32px
final margin = ResponsiveValue<double>(
  context,
  defaultValue: 24.0,
  conditionalValues: const [
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
  conditionalValues: const [
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
  conditionalValues: const [
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
  conditionalValues: const [
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
  conditionalValues: const [
    Condition.smallerThan(name: MOBILE, value: 24.0),
    Condition.largerThan(name: TABLET, value: 32.0),
  ],
).value;
```

### **Fatores de Escala (Para Imagens/Elementos)**
```dart
// Mobile: 0.8 | Padrão: 1.0 | Tablet+: 1.2
final scaleFactor = ResponsiveValue<double>(
  context,
  defaultValue: 1.0,
  conditionalValues: const [
    Condition.smallerThan(name: MOBILE, value: 0.8),
    Condition.largerThan(name: TABLET, value: 1.2),
  ],
).value;
```

### **Aspect Ratio Responsivo (Para Imagens)**
```dart
// Constantes para manter proporções originais
static const double originalImageWidth = 267;
static const double originalImageHeight = 196.06;
static const double imageAspectRatio = originalImageWidth / originalImageHeight;

// Largura responsiva
final imageWidth = ResponsiveValue<double>(
  context,
  defaultValue: 267.0,
  conditionalValues: const [
    Condition.smallerThan(name: MOBILE, value: 200.0),
    Condition.largerThan(name: TABLET, value: 350.0),
  ],
).value;

// Altura calculada mantendo proporção
final imageHeight = imageWidth / imageAspectRatio;
```

### **Espaçamentos Específicos (Footer, Header, etc.)**
```dart
// Mobile: 24px | Padrão: 36px | Tablet+: 48px
final footerPadding = ResponsiveValue<double>(
  context,
  defaultValue: 36.0,
  conditionalValues: const [
    Condition.smallerThan(name: MOBILE, value: 24.0),
    Condition.largerThan(name: TABLET, value: 48.0),
  ],
).value;
```

## 🎨 **Cores e Temas**

### **⚠️ REGRA OBRIGATÓRIA: Sempre usar cores do theme**
```dart
// ❌ ERRADO - Cores hardcoded
Container(color: Color(0xFF9D68FF))

// ✅ CORRETO - Cores do theme
Container(color: MetamorfoseColors.purpleNormal)
```

### **Verificação de Cores**
Antes de finalizar qualquer tela:
1. ✅ Verificar se todas as cores estão definidas no `lib/theme/colors.dart`
2. ✅ Se uma cor não existir no theme, verificar se existe com outro nome
3. ✅ Caso não exista, substituir por uma cor disponível ou solicitar aprovação para adicionar

### **Exemplo de Uso Correto**
```dart
// Status bar
statusBarColor: MetamorfoseColors.purpleNormal,
systemNavigationBarColor: MetamorfoseColors.whiteLight,

// Backgrounds
backgroundColor: MetamorfoseColors.whiteLight,

// Textos
color: MetamorfoseColors.greyMedium,
```

## 🔧 **Implementação em Componentes**

### **Template Básico para Componentes**
```dart
class MeuComponente extends StatelessWidget {
  const MeuComponente({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Definir valores responsivos
    final height = ResponsiveValue<double>(
      context,
      defaultValue: 43.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 52.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
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
        color: MetamorfoseColors.whiteLight, // ✅ Usar cores do theme
      ),
      child: Text(
        'Texto',
        style: TextStyle(
          fontSize: fontSize,
          color: MetamorfoseColors.greyMedium, // ✅ Usar cores do theme
        ),
        textAlign: TextAlign.center, // ✅ Sempre definir textAlign
        maxLines: 1, // ✅ Sempre definir maxLines
        overflow: TextOverflow.ellipsis, // ✅ Sempre definir overflow
      ),
    );
  }
}
```

## 🖥️ **Implementação em Telas**

### **Template Básico para Telas**
```dart
class MinhaTela extends StatelessWidget {
  const MinhaTela({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Valores responsivos globais
    final horizontalMargin = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    // 2. Layout responsivo
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight, // ✅ Usar cores do theme
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
    return const Column(
      children: [
        // Layout em coluna para mobile
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return const Row(
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

### **Para RichText Responsivo**
```dart
RichText(
  textAlign: TextAlign.center,
  maxLines: 3,
  overflow: TextOverflow.ellipsis,
  text: TextSpan(
    style: TextStyle(
      fontSize: titleFontSize,
      color: MetamorfoseColors.greyMedium,
    ),
    children: [
      const TextSpan(text: 'Seu '),
      TextSpan(
        text: 'crescimento',
        style: TextStyle(
          color: MetamorfoseColors.greenLight,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
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

### **Métodos Separados para Layout Responsivo**
```dart
// No build method principal
Widget _buildResponsiveButtons(BuildContext context, bool isMobile) {
  final maxButtonWidth = ResponsiveValue<double>(
    context,
    defaultValue: 358.0,
    conditionalValues: const [
      Condition.smallerThan(name: MOBILE, value: double.infinity),
      Condition.largerThan(name: TABLET, value: 400.0),
    ],
  ).value;

  final buttonWidget = MetamorfosePrimaryButton(
    text: 'Começar agora',
    onPressed: () => context.go(Routes.onboardingWelcome),
  );

  if (isMobile) {
    return SizedBox(
      width: double.infinity,
      child: buttonWidget,
    );
  } else {
    return Center(
      child: SizedBox(
        width: maxButtonWidth,
        child: buttonWidget,
      ),
    );
  }
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
- ✅ Usar `const` nos `conditionalValues` de ResponsiveValue
- ✅ Verificar com `flutter analyze` antes de finalizar
- ✅ Usar comentários de documentação (`///`) em vez de (`/**`)

### **2. Processo de Correção**
- ✅ **Fazer correções uma por vez para evitar conflitos**
- ✅ Testar cada correção individualmente
- ✅ Verificar se não há erros de linting após cada mudança
- ✅ Usar `search_replace` com contexto específico quando há múltiplas ocorrências
- ✅ Preferir `replace_all` apenas quando a mudança é idêntica em todos os locais

### **3. Performance**
- ✅ Usar `mounted` check em operações async
- ✅ Evitar rebuilds desnecessários
- ✅ Usar `Flexible` e `Expanded` adequadamente

### **4. Acessibilidade**
- ✅ Sempre definir `textAlign` para textos
- ✅ Usar `maxLines` e `overflow` apropriados
- ✅ Manter contraste adequado

### **5. Limpeza de Código (Pós-Implementação)**
- ✅ Remover constantes estáticas desnecessárias (como `_LayoutConstants`)
- ✅ Substituir cores hardcoded por cores do theme
- ✅ Verificar se todas as variáveis declaradas estão sendo utilizadas
- ✅ Executar `flutter analyze` e corrigir todos os warnings
- ✅ Testar em diferentes tamanhos de tela

### **6. Limpeza de Comentários**
- ✅ **MANTER:**
  - Cabeçalho do arquivo (comentários de documentação no topo)
  - Comentários de funções públicas importantes (se houver)
  - Comentários que explicam lógica complexa ou não óbvia
- ✅ **REMOVER:**
  - Comentários óbvios que apenas repetem o código
  - Comentários de linha única explicando operações simples
  - Comentários redundantes como "// Cor de fundo", "// Espaço entre elementos"
  - Comentários de configuração básica
  - Comentários de imports ou declarações simples

### **7. Comentários de Documentação**
- ✅ **SEMPRE usar `///` para comentários de documentação**
- ❌ **NUNCA usar `/**` para comentários de documentação**

```dart
// ✅ CORRETO - Comentários de documentação
/// File: onboarding_screen.dart
/// Description: Tela inicial do onboarding do aplicativo.

// ❌ ERRADO - Comentários de documentação
/**
 * File: onboarding_screen.dart
 * Description: Tela inicial do onboarding do aplicativo.
 */
```

#### **Exemplos do que REMOVER:**
```dart
// ❌ REMOVER - Comentários óbvios
backgroundColor: Colors.blue, // Cor azul
const SizedBox(height: 20), // Espaço de 20 pixels
final name = 'João'; // Nome do usuário
final isMobile = true; // Verifica se é mobile

// ❌ REMOVER - Comentários redundantes
// Cor de fundo
Container(color: Colors.white),
// Espaço entre elementos
SizedBox(height: 16),
// Import necessário
import 'package:flutter/material.dart';
```

#### **Exemplos do que MANTER:**
```dart
// ✅ MANTER - Documentação de função complexa
/// Calcula o layout responsivo baseado no tamanho da tela
/// e aplica os breakpoints definidos no sistema
void calculateResponsiveLayout() {
  // Lógica complexa aqui
}

// ✅ MANTER - Explicação de lógica não óbvia
// Garante que o texto nunca fique fora da tela
final double maxTextTop = constraints.maxHeight - 200;
final double textTop = distanceFromTop < maxTextTop ? distanceFromTop : maxTextTop;

// ✅ MANTER - Cabeçalho do arquivo
/// File: onboarding_plant_screen.dart
/// Description: Tela de onboarding que apresenta a planta do usuário.
```

#### **Regras para Comentários:**
- ✅ Manter apenas comentários que agregam valor real
- ✅ Código deve ser autoexplicativo através de nomes de variáveis claros
- ✅ Focar na legibilidade através de nomes de variáveis claros
- ✅ Preservar documentação de API pública
- ✅ Aplicar limpeza mantendo funcionalidade e legibilidade

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
- [ ] Uso de `const` nos `conditionalValues`
- [ ] Uso dos valores no widget
- [ ] Truncamento de texto implementado (`maxLines`, `overflow`, `textAlign`)
- [ ] Cores do theme utilizadas (não hardcoded)
- [ ] Constructor `const` implementado
- [ ] Comentários limpos (remover óbvios, manter úteis)
- [ ] Teste em diferentes tamanhos de tela
- [ ] `flutter analyze` sem erros

### **Para Telas:**
- [ ] Import do `responsive_framework`
- [ ] Valores responsivos globais definidos
- [ ] Uso de `const` nos `conditionalValues`
- [ ] Layout condicional implementado (se necessário)
- [ ] Métodos separados para mobile/desktop (se necessário)
- [ ] Espaçamentos responsivos aplicados
- [ ] Cores do theme utilizadas (não hardcoded)
- [ ] Constructor `const` implementado
- [ ] Comentários de documentação com `///` (cabeçalho do arquivo)
- [ ] Comentários limpos (remover óbvios, manter úteis)
- [ ] RichText com `maxLines` e `overflow` (se aplicável)
- [ ] Aspect ratio responsivo para imagens (se aplicável)
- [ ] Constantes estáticas para cálculos (se aplicável)
- [ ] Teste em diferentes tamanhos de tela
- [ ] `flutter analyze` sem erros

## 🎯 **Exemplo Completo - Card Responsivo**

```dart
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

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
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 160.0),
        Condition.largerThan(name: TABLET, value: 200.0),
      ],
    ).value;

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final contentFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: MetamorfoseColors.whiteLight, // ✅ Usar cores do theme
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: MetamorfoseColors.shadowLight, // ✅ Usar cores do theme
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
              color: MetamorfoseColors.blackNormal, // ✅ Usar cores do theme
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.start, // ✅ Sempre definir textAlign
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: contentFontSize,
                color: MetamorfoseColors.greyMedium, // ✅ Usar cores do theme
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start, // ✅ Sempre definir textAlign
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🚨 **Problemas Comuns e Soluções**

### **1. Erro de Linting: "prefer_const_constructors"**
```dart
// ❌ ERRADO
conditionalValues: [
  Condition.smallerThan(name: MOBILE, value: 16.0),
]

// ✅ CORRETO
conditionalValues: const [
  Condition.smallerThan(name: MOBILE, value: 16.0),
]
```

### **2. Erro de Linting: "slash_for_doc_comments"**
```dart
// ❌ ERRADO
/**
 * Comentário de documentação
 */

// ✅ CORRETO
/// Comentário de documentação
```

### **3. Variáveis não utilizadas**
```dart
// ❌ ERRADO - Variável declarada mas não usada
final isMobile = ResponsiveBreakpoints.of(context).isMobile;
final isTablet = ResponsiveBreakpoints.of(context).isTablet;

// ✅ CORRETO - Remover variáveis não utilizadas
// Ou usar apenas as que são necessárias
```

### **4. Cores hardcoded**
```dart
// ❌ ERRADO
Container(color: Color(0xFF9D68FF))

// ✅ CORRETO
Container(color: MetamorfoseColors.purpleNormal)
```

### **5. Comentários desnecessários**
```dart
// ❌ ERRADO - Comentários óbvios
final isMobile = true; // Verifica se é mobile
const SizedBox(height: 20), // Espaço de 20 pixels
backgroundColor: Colors.blue, // Cor azul

// ✅ CORRETO - Código autoexplicativo
final isMobile = true;
const SizedBox(height: 20),
backgroundColor: Colors.blue,
```

### **6. Comentários redundantes**
```dart
// ❌ ERRADO - Comentários que apenas repetem o código
// Cor de fundo
Container(color: Colors.white),
// Espaço entre elementos
SizedBox(height: 16),
// Import necessário
import 'package:flutter/material.dart';

// ✅ CORRETO - Sem comentários desnecessários
Container(color: Colors.white),
SizedBox(height: 16),
import 'package:flutter/material.dart';
```

## 🚀 **Resultado Esperado**

Com este prompt, você conseguirá implementar responsividade completa em qualquer tela ou componente Flutter, garantindo:

- ✅ **Adaptação perfeita** a diferentes tamanhos de tela
- ✅ **Código limpo** e bem estruturado
- ✅ **Performance otimizada**
- ✅ **Experiência de usuário consistente**
- ✅ **Manutenibilidade alta**
- ✅ **Zero erros de linting**

## 📝 **Checklist Final**

Antes de finalizar qualquer tela responsiva:

1. ✅ Verificar se todas as cores estão definidas no `lib/theme/colors.dart`
2. ✅ Se uma cor não existir no theme, verificar se existe com outro nome
3. ✅ Caso não exista, substituir por uma cor disponível ou solicitar aprovação
4. ✅ **Verificar comentários de documentação:**
   - Usar `///` para comentários de documentação (nunca `/**`)
   - Manter cabeçalho do arquivo com informações relevantes
5. ✅ **Limpar comentários desnecessários:**
   - Remover comentários óbvios que apenas repetem o código
   - Remover comentários redundantes como "// Cor de fundo", "// Espaço entre elementos"
   - Manter apenas comentários que agregam valor real
6. ✅ **Verificar responsividade específica:**
   - RichText com `maxLines` e `overflow` (se aplicável)
   - Aspect ratio responsivo para imagens (se aplicável)
   - Constantes estáticas para cálculos (se aplicável)
7. ✅ Executar `flutter analyze` e corrigir todos os warnings
8. ✅ Testar em diferentes tamanhos de tela (mobile, tablet, desktop)
9. ✅ Verificar se todos os textos têm `textAlign`, `maxLines` e `overflow` definidos


