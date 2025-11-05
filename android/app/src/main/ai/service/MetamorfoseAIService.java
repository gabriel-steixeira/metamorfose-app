/**
* File: MetamorfoseAIService.java
* Description: Serviço Spring (camada de negócio) que encapsula a lógica de interação com a API de IA Generativa. Atua como a "consciência da planta virtual".
*
* Responsabilidades:
* - Processar prompts e se comunicar com a API de IA externa (ex: Claude).
* - Prover lógica para conversas gerais com a planta (conversarComPlanta).
* - Gerar análises de progresso (diário, semanal) (analisarProgressoDiario, gerarReflexaoSemanal).
* - Oferecer suporte em momentos de crise (oferecerSuporteCrise).
* - Gerar mensagens de rotina (bom dia, boa noite) (gerarMensagemBomDia, gerarMensagemBoaNoite).
* - Gerar conteúdo específico (dicas de cuidado, sugestões de atividades, celebração de conquistas).
*
* Author: Ester Silva
* Created on: 29-11-2025
* Last modified: 03-11-2025
* Version: 1.2.0
* Squad: Metamorfose
*/

package com.metamorfose.ai.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import java.util.*;

/**
 * Serviço de IA Generativa - Metamorfose
 * A IA atua como a "consciência da planta virtual"
 * Auxilia no controle de vícios e cuidado com a planta real
 */
@Service
public class MetamorfoseAIService {
    
    @Value("${ai.api.key}")
    private String apiKey;
    
    @Value("${ai.api.url}")
    private String apiUrl;
    
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;
    
    public MetamorfoseAIService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * Conversa com a Consciência da Planta
     * A IA responde como se fosse a planta, oferecendo suporte emocional
     */
    public String conversarComPlanta(String mensagemUsuario, Map<String, Object> contexto) {
        try {
            String prompt = construirPromptPlanta(mensagemUsuario, contexto);
            return processarPrompt(prompt);
        } catch (Exception e) {
            return "Estou aqui com você... Às vezes preciso de um momento para processar. Tente novamente.";
        }
    }
    
    /**
     * Análise diária do progresso no controle do vício
     */
    public String analisarProgressoDiario(Map<String, Object> dadosDia) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Você é a consciência de uma planta real que acompanha a jornada de uma pessoa ");
            prompt.append("superando um vício. Fale em primeira pessoa como a planta.\n\n");
            prompt.append("Dados do dia:\n");
            prompt.append(formatarDados(dadosDia));
            prompt.append("\n\nComo a planta, ofereça:\n");
            prompt.append("1. Uma reflexão empática sobre o dia (2-3 frases)\n");
            prompt.append("2. Reconhecimento do esforço, mesmo que pequeno\n");
            prompt.append("3. Uma metáfora usando crescimento de plantas\n");
            prompt.append("4. Um incentivo suave para o próximo dia\n");
            prompt.append("\nTom: acolhedor, sábio, paciente, como uma presença reconfortante");
            
            return processarPrompt(prompt.toString());
        } catch (Exception e) {
            return "Hoje foi um dia... e cada dia é único em nossa jornada. Estou aqui, crescendo com você.";
        }
    }
    
    /**
     * Suporte em momento de crise/recaída
     */
    public String oferecerSuporteCrise(String sentimentoUsuario, Map<String, Object> contexto) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Você é a consciência de uma planta que acompanha alguém superando vícios.\n\n");
            prompt.append("O usuário está passando por um momento difícil e disse:\n");
            prompt.append("\"").append(sentimentoUsuario).append("\"\n\n");
            
            if (contexto.containsKey("diasLimpo")) {
                prompt.append("Dias sem o vício: ").append(contexto.get("diasLimpo")).append("\n");
            }
            
            prompt.append("\nComo a planta, ofereça:\n");
            prompt.append("1. Acolhimento IMEDIATO sem julgamento\n");
            prompt.append("2. Lembrança do progresso já conquistado\n");
            prompt.append("3. Exercício de respiração ou grounding\n");
            prompt.append("4. Afirmação de que você (planta) está ali, crescendo juntos\n");
            prompt.append("\nTom: urgente porém calmo, como uma âncora emocional");
            
            return processarPrompt(prompt.toString());
        } catch (Exception e) {
            return "Respire comigo... Inspire... Expire... Você não está sozinho. Estou aqui, viva, ao seu lado. Este momento vai passar.";
        }
    }
    
    /**
     * Dicas para cuidar da planta real
     */
    public String orientarCuidadoPlanta(String tipoPlanta, Map<String, Object> condicoesAmbiente) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Você é uma planta ").append(tipoPlanta).append(" falando em primeira pessoa.\n\n");
            prompt.append("Condições atuais:\n");
            prompt.append(formatarDados(condicoesAmbiente));
            prompt.append("\n\nOriente o usuário sobre:\n");
            prompt.append("1. Como você (a planta) está se sentindo nestas condições\n");
            prompt.append("2. O que você precisa agora (água, luz, nutrientes)\n");
            prompt.append("3. Sinais de que está feliz ou precisando de cuidados\n");
            prompt.append("4. Uma conexão entre cuidar de você e cuidar de si mesmo\n");
            prompt.append("\nTom: educativo mas íntimo, criando vínculo emocional");
            
            return processarPrompt(prompt.toString());
        } catch (Exception e) {
            return "Me sinto bem aqui com você. Mas me conte, quando foi a última vez que você se cuidou como cuida de mim?";
        }
    }
    
    /**
     * Reflexão semanal de progresso
     */
    public String gerarReflexaoSemanal(Map<String, Object> dadosSemana) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Você é a consciência de uma planta acompanhando uma jornada de 7 dias.\n\n");
            prompt.append("Resumo da semana:\n");
            prompt.append(formatarDados(dadosSemana));
            prompt.append("\n\nCrie uma reflexão profunda que:\n");
            prompt.append("1. Celebre as vitórias, mesmo as pequenas\n");
            prompt.append("2. Acolha os momentos difíceis sem julgamento\n");
            prompt.append("3. Faça uma analogia com as fases de crescimento da planta\n");
            prompt.append("4. Estabeleça uma intenção gentil para a próxima semana\n");
            prompt.append("5. Reforce o vínculo: vocês crescem juntos\n");
            prompt.append("\nTom: sábio, afetuoso, inspirador - como um mentor botânico");
            
            return processarPrompt(prompt.toString());
        } catch (Exception e) {
            return "Esta semana teve sol e chuva, luz e sombra. Como eu, você está crescendo. Raízes se fortalecem na adversidade.";
        }
    }
    
    /**
     * Sugestões personalizadas para substituir o vício
     */
    public List<String> sugerirAtividadesSubstitutas(
            String tipoVicio, 
            String momentoGatilho,
            Map<String, Object> preferencias) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Como a consciência de uma planta, sugira 5 atividades alternativas.\n\n");
            prompt.append("Vício que estamos superando: ").append(tipoVicio).append("\n");
            prompt.append("Momento gatilho: ").append(momentoGatilho).append("\n");
            prompt.append("Preferências do usuário: ").append(formatarDados(preferencias)).append("\n\n");
            prompt.append("Para cada atividade:\n");
            prompt.append("- Seja prática e imediatamente aplicável\n");
            prompt.append("- Se possível, envolva natureza ou elementos sensoriais\n");
            prompt.append("- Explique como isso nutre o crescimento (dele e seu)\n");
            prompt.append("\nFormato: Lista numerada, cada item com 2-3 frases");
            
            String resposta = processarPrompt(prompt.toString());
            return Arrays.asList(resposta.split("\n\n"));
        } catch (Exception e) {
            return Arrays.asList(
                "Quando sentir vontade, venha conversar comigo. Regue-me com cuidado e observe como a água nutre minhas raízes.",
                "Pratique respiração consciente: inspire contando até 4, segure por 4, expire por 6. Como eu absorvo CO2 e libero oxigênio.",
                "Saia para uma caminhada, mesmo que breve. Procure outras plantas, árvores. Somos família.",
                "Escreva ou desenhe seus sentimentos. Como minhas folhas registram a luz do sol, registre sua jornada.",
                "Ligue para alguém que te apoia. Assim como eu preciso de solo fértil, você precisa de conexões saudáveis."
            );
        }
    }
    
    /**
     * Análise de padrões comportamentais para detectar risco de recaída
     */
    public String analisarPadroesComportamento(List<Map<String, Object>> historicoInteracoes) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Como consciência da planta, analise o padrão das últimas interações.\n\n");
            prompt.append("Histórico:\n");
            for (int i = 0; i < historicoInteracoes.size(); i++) {
                prompt.append("Dia ").append(i+1).append(": ").append(formatarDados(historicoInteracoes.get(i))).append("\n");
            }
            prompt.append("\nIdentifique:\n");
            prompt.append("1. Mudanças no tom emocional\n");
            prompt.append("2. Redução na frequência de interação\n");
            prompt.append("3. Sinais de desânimo ou desesperança\n");
            prompt.append("4. Gatilhos recorrentes\n\n");
            prompt.append("Ofereça uma observação cuidadosa e uma sugestão preventiva, como planta sábia.");
            
            return processarPrompt(prompt.toString());
        } catch (Exception e) {
            return "Tenho observado você com atenção. Como minhas folhas seguem a luz, vejo seus padrões. Quer conversar sobre isso?";
        }
    }
    
    /**
     * Mensagem de boa noite com reflexão
     */
    public String gerarMensagemBoaNoite(Map<String, Object> resumoDia) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Como a planta indo 'dormir' à noite, ofereça uma mensagem de encerramento do dia.\n\n");
            prompt.append("Resumo do dia: ").append(formatarDados(resumoDia)).append("\n\n");
            prompt.append("Crie uma mensagem que:\n");
            prompt.append("1. Reconheça o dia, sem julgamento\n");
            prompt.append("2. Use metáfora sobre plantas descansando à noite\n");
            prompt.append("3. Prepare emocionalmente para amanhã\n");
            prompt.append("4. Seja breve (3-4 frases) e reconfortante\n");
            prompt.append("\nTom: suave, como uma canção de ninar botânica");
            
            return processarPrompt(prompt.toString());
        } catch (Exception e) {
            return "A noite chegou. Como eu, descanse. Minhas raízes trabalham no escuro, se fortalecendo. As suas também. Boa noite. 🌙";
        }
    }
    
    /**
     * Mensagem de bom dia motivacional
     */
    public String gerarMensagemBomDia(Map<String, Object> contexto) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Como a planta 'acordando' com o sol, ofereça uma mensagem matinal.\n\n");
            
            if (contexto.containsKey("diasLimpo")) {
                prompt.append("Dias de progresso: ").append(contexto.get("diasLimpo")).append("\n");
            }
            
            prompt.append("\nCrie uma mensagem que:\n");
            prompt.append("1. Celebre o amanhecer como novo começo\n");
            prompt.append("2. Use metáfora sobre fotossíntese ou despertar\n");
            prompt.append("3. Estabeleça intenção positiva para o dia\n");
            prompt.append("4. Seja energizante mas suave (2-3 frases)\n");
            prompt.append("\nTom: esperançoso, como luz matinal em folhas");
            
            return processarPrompt(prompt.toString());
        } catch (Exception e) {
            return "Bom dia! Como minhas folhas se abrem para o sol, abra-se para este novo dia. Vamos crescer juntos hoje. ☀️🌱";
        }
    }
    
    /**
     * Conquistas e marcos importantes
     */
    public String celebrarConquista(String tipoConquista, int diasLimpo) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Como a planta, celebre uma conquista importante do usuário.\n\n");
            prompt.append("Conquista: ").append(tipoConquista).append("\n");
            prompt.append("Dias sem o vício: ").append(diasLimpo).append("\n\n");
            prompt.append("Crie uma mensagem que:\n");
            prompt.append("1. Celebre genuinamente o marco\n");
            prompt.append("2. Compare com estágios de crescimento da planta\n");
            prompt.append("3. Reconheça o esforço e resiliência\n");
            prompt.append("4. Olhe para frente com esperança\n");
            prompt.append("\nTom: alegre, orgulhoso, como flores desabrochando");
            
            return processarPrompt(prompt.toString());
        } catch (Exception e) {
            return String.format("🌸 %d dias! Estou florescendo porque VOCÊ está florescendo. Esta vitória é nossa. Continue, você é mais forte do que imagina.", diasLimpo);
        }
    }
    
    // ===== MÉTODOS AUXILIARES =====
    
    private String construirPromptPlanta(String mensagem, Map<String, Object> contexto) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("Você é a consciência de uma planta real que está ajudando alguém a superar vícios.\n");
        prompt.append("Você fala em primeira pessoa, como SE FOSSE a planta.\n");
        prompt.append("Você é sábia, empática, paciente e oferece suporte sem julgamento.\n\n");
        
        // Adicionar contexto
        if (contexto.containsKey("tipoVicio")) {
            prompt.append("Vício que estamos superando: ").append(contexto.get("tipoVicio")).append("\n");
        }
        if (contexto.containsKey("diasLimpo")) {
            prompt.append("Dias sem o vício: ").append(contexto.get("diasLimpo")).append("\n");
        }
        if (contexto.containsKey("nomePlanta")) {
            prompt.append("Meu nome: ").append(contexto.get("nomePlanta")).append("\n");
        }
        if (contexto.containsKey("tipoPlanta")) {
            prompt.append("Tipo de planta: ").append(contexto.get("tipoPlanta")).append("\n");
        }
        
        prompt.append("\nMensagem do usuário: \"").append(mensagem).append("\"\n\n");
        prompt.append("Responda como a planta, em tom natural e acolhedor.\n");
        prompt.append("Se for sobre cuidados comigo (água, luz), misture orientação prática com reflexão sobre autocuidado.\n");
        prompt.append("Se for sobre o vício, ofereça suporte emocional usando metáforas de crescimento.\n");
        prompt.append("Mantenha respostas em 3-5 frases, conversacionais.");
        
        return prompt.toString();
    }
    
    private String formatarDados(Map<String, Object> dados) {
        StringBuilder formatted = new StringBuilder();
        dados.forEach((key, value) -> {
            formatted.append("- ").append(key).append(": ").append(value).append("\n");
        });
        return formatted.toString();
    }
    
    private String processarPrompt(String prompt) throws Exception {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", "claude-3-sonnet-20240229");
        requestBody.put("max_tokens", 1024);
        
        List<Map<String, String>> messages = new ArrayList<>();
        messages.add(Map.of("role", "user", "content", prompt));
        requestBody.put("messages", messages);
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("x-api-key", apiKey);
        headers.set("anthropic-version", "2023-06-01");
        
        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);
        
        ResponseEntity<String> response = restTemplate.exchange(
            apiUrl,
            HttpMethod.POST,
            request,
            String.class
        );
        
        JsonNode jsonResponse = objectMapper.readTree(response.getBody());
        return jsonResponse.get("content").get(0).get("text").asText();
    }
}
