# 🧠 Guia de Teste - Sistema de Memória Local da IA

## 🚀 **Como Testar o Sistema de Memória**

### **1. 📱 Acessando o Teste**
1. Abra o app Metamorfose
2. Vá para a tela **Home**
3. Role para baixo até a seção **"Teste de Notificações"**
4. Clique no botão **"Teste Memória"** (ícone de cérebro)

---

## 🎯 **Funcionalidades para Testar**

### **📊 Estatísticas**
- **Total de memórias**: Quantidade total armazenada
- **Alta importância**: Memórias com importância ≥ 70%
- **Média importância**: Memórias com importância 40-69%
- **Baixa importância**: Memórias com importância < 40%
- **Importância média**: Média geral das memórias

### **💬 Chat com IA**
- **Enviar mensagem**: Testa a IA com memória
- **Buscar**: Procura memórias relacionadas ao texto
- **Resposta da IA**: Mostra como a IA usa as memórias

### **➕ Adicionar Memória Manual**
- **Categoria**: Tipo da memória (ex: personal, preferences)
- **Chave**: Identificador único (ex: favorite_color)
- **Valor**: Conteúdo da memória (ex: azul)

### **🧠 Lista de Memórias**
- **Visualização**: Todas as memórias armazenadas
- **Importância**: Indicador colorido (verde/amarelo/vermelho)
- **Acessos**: Quantas vezes foi usada
- **Data**: Quando foi criada

---

## 🧪 **Cenários de Teste**

### **Teste 1: Memórias de Exemplo**
1. Acesse a tela de teste
2. Verifique se há 5 memórias de exemplo carregadas:
   - `personal > favorite_color: azul`
   - `preferences > music_genre: rock`
   - `goals > recovery_goal: parar de fumar`
   - `emotions > stress_triggers: trabalho e trânsito`
   - `support > support_person: mãe`

### **Teste 2: Chat com Memória**
1. Digite: "Qual é minha cor favorita?"
2. Clique em "Enviar"
3. A IA deve responder lembrando que sua cor favorita é azul
4. Verifique se uma nova memória de conversa foi criada

### **Teste 3: Busca Semântica**
1. Digite: "música" no campo de mensagem
2. Clique em "Buscar"
3. Deve encontrar a memória sobre gênero musical (rock)

### **Teste 4: Adicionar Memória Manual**
1. Preencha os campos:
   - **Categoria**: `personal`
   - **Chave**: `favorite_food`
   - **Valor**: `pizza`
2. Clique em "Adicionar Memória"
3. Verifique se aparece na lista

### **Teste 5: Atualizar Memória**
1. Adicione uma memória com chave existente
2. Verifique se ela é atualizada em vez de duplicada
3. O contador de acessos deve aumentar

### **Teste 6: Limpeza**
1. Clique em "Limpar Tudo"
2. Verifique se todas as memórias são removidas
3. As estatísticas devem zerar

---

## 🔍 **O que Observar**

### **✅ Comportamentos Esperados:**
- **Memórias persistem** entre sessões do app
- **IA usa contexto** das memórias nas respostas
- **Busca funciona** por palavras-chave
- **Estatísticas atualizam** em tempo real
- **Importância afeta** a relevância nas buscas

### **⚠️ Possíveis Problemas:**
- **Erro de inicialização**: Verificar logs do console
- **Memórias não salvam**: Verificar permissões de armazenamento
- **IA não responde**: Verificar conexão com internet
- **Busca não funciona**: Verificar se há memórias carregadas

---

## 📝 **Logs para Monitorar**

### **Logs de Sucesso:**
```
[LocalMemory] Serviço inicializado com sucesso
[LocalMemory] 5 memórias de exemplo adicionadas
[LocalMemory] Nova memória adicionada: favorite_color
[GeminiService] Contexto de memória incluído
```

### **Logs de Erro:**
```
[LocalMemory] Erro na inicialização: ...
[GeminiService] Erro ao gerar contexto de memória: ...
```

---

## 🎮 **Testes Avançados**

### **Teste de Performance:**
1. Adicione 50+ memórias
2. Teste a velocidade de busca
3. Verifique se o app continua responsivo

### **Teste de Categorias:**
1. Teste diferentes categorias:
   - `personal` (informações pessoais)
   - `preferences` (preferências)
   - `goals` (objetivos)
   - `emotions` (estados emocionais)
   - `support` (rede de apoio)

### **Teste de Importância:**
1. Adicione memórias com diferentes importâncias (0.1 a 1.0)
2. Verifique se as mais importantes aparecem primeiro
3. Teste a busca por importância mínima

---

## 🔧 **Solução de Problemas**

### **Problema: App não inicia**
**Solução**: Verificar se todas as dependências estão instaladas

### **Problema: Memórias não salvam**
**Solução**: Verificar permissões de SharedPreferences

### **Problema: IA não responde**
**Solução**: Verificar API Key do Gemini

### **Problema: Busca não funciona**
**Solução**: Verificar se há memórias carregadas

---

## 📊 **Métricas de Sucesso**

### **Funcionalidade Básica:**
- ✅ Memórias salvam e carregam
- ✅ IA usa contexto das memórias
- ✅ Busca semântica funciona
- ✅ Estatísticas atualizam

### **Performance:**
- ✅ Inicialização < 2 segundos
- ✅ Busca < 1 segundo
- ✅ Salvamento < 500ms

### **Usabilidade:**
- ✅ Interface intuitiva
- ✅ Feedback visual claro
- ✅ Navegação fluida

---

## 🎯 **Próximos Passos**

Após testar o sistema local, você pode:

1. **Implementar Firebase** para sincronização na nuvem
2. **Adicionar criptografia** para segurança
3. **Implementar backup** automático
4. **Adicionar sincronização** entre dispositivos
5. **Criar interface** para gerenciar memórias

---

## 🚀 **Resultado Esperado**

O sistema de memória local deve funcionar perfeitamente, permitindo que a IA:
- **Lembre** informações importantes do usuário
- **Personalize** respostas baseadas no histórico
- **Aprenda** com as conversas
- **Mantenha** contexto entre sessões

**Boa sorte nos testes! 🧠✨** 