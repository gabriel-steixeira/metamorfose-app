/**
* File: MetamorfoseAIController.java
* Description: Controller REST (camada de API) que expõe os endpoints da IA "Consciência da Planta" para o front-end.
*
* Responsabilidades:
* - Definir os endpoints da API REST no caminho /api/v1/planta.
* - Receber requisições HTTP (JSON) do cliente.
* - Delegar a lógica de negócio para o MetamorfoseAIService.
* - Mapear os DTOs (Requests e Responses) para cada endpoint (ex: /conversar, /suporte-crise, /progresso-diario).
* - Fornecer um endpoint de health check (/health).
* - Tratar exceções e formatar respostas de erro.
*
* Author: Ester Silva
* Created on: 29-11-2025
* Last modified: 03-11-2025
* Version: 1.2.0
* Squad: Metamorfose
*/

package com.metamorfose.ai.controller;

import com.metamorfose.ai.service.MetamorfoseAIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.*;

/**
 * Controller REST - Metamorfose
 * API para interação com a Consciência da Planta (IA)
 */
@RestController
@RequestMapping("/api/v1/planta")
@Tag(name = "Consciência da Planta", description = "Endpoints de IA para suporte emocional e cuidado")
@CrossOrigin(origins = "*")
public class MetamorfoseAIController {
    
    @Autowired
    private MetamorfoseAIService aiService;
    
    /**
     * Conversar com a planta (principal endpoint)
     * POST /api/v1/planta/conversar
     */
    @PostMapping("/conversar")
    @Operation(summary = "Conversar com a consciência da planta",
               description = "Envia mensagem (voz ou texto) para a planta que responde com suporte emocional")
    public ResponseEntity<ConversaResponse> conversarComPlanta(@RequestBody ConversaRequest request) {
        try {
            String resposta = aiService.conversarComPlanta(
                request.getMensagem(),
                request.getContexto()
            );
            
            ConversaResponse response = new ConversaResponse();
            response.setRespostaPlanta(resposta);
            response.setTimestamp(System.currentTimeMillis());
            response.setEmocao(detectarEmocao(resposta));
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(criarErro("Preciso de um momento... tente novamente."));
        }
    }
    
    /**
     * Análise do progresso diário
     * POST /api/v1/planta/progresso-diario
     */
    @PostMapping("/progresso-diario")
    @Operation(summary = "Analisar progresso do dia",
               description = "A planta reflete sobre o dia do usuário no controle do vício")
    public ResponseEntity<ProgressoResponse> analisarProgressoDiario(@RequestBody ProgressoRequest request) {
        try {
            String analise = aiService.analisarProgressoDiario(request.getDadosDia());
            
            ProgressoResponse response = new ProgressoResponse();
            response.setReflexao(analise);
            response.setDiasLimpo(request.getDadosDia().get("diasLimpo"));
            response.setTimestamp(System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(criarErroProgresso());
        }
    }
    
    /**
     * Suporte em crise/momento difícil
     * POST /api/v1/planta/suporte-crise
     */
    @PostMapping("/suporte-crise")
    @Operation(summary = "Suporte em momento de crise",
               description = "A planta oferece apoio imediato quando usuário está em risco de recaída")
    public ResponseEntity<SuporteResponse> oferecerSuporteCrise(@RequestBody SuporteRequest request) {
        try {
            String suporte = aiService.oferecerSuporteCrise(
                request.getSentimento(),
                request.getContexto()
            );
            
            SuporteResponse response = new SuporteResponse();
            response.setMensagemSuporte(suporte);
            response.setUrgencia("ALTA");
            response.setTimestamp(System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            SuporteResponse fallback = new SuporteResponse();
            fallback.setMensagemSuporte("Respire comigo... você não está sozinho. Estou aqui. 🌱");
            fallback.setUrgencia("ALTA");
            return ResponseEntity.ok(fallback);
        }
    }
    
    /**
     * Dicas para cuidar da planta real
     * POST /api/v1/planta/cuidados
     */
    @PostMapping("/cuidados")
    @Operation(summary = "Orientações de cuidado com a planta real",
               description = "A planta ensina como cuidar dela e conecta com autocuidado")
    public ResponseEntity<CuidadosResponse> orientarCuidadoPlanta(@RequestBody CuidadosRequest request) {
        try {
            String orientacao = aiService.orientarCuidadoPlanta(
                request.getTipoPlanta(),
                request.getCondicoesAmbiente()
            );
            
            CuidadosResponse response = new CuidadosResponse();
            response.setOrientacao(orientacao);
            response.setTipoPlanta(request.getTipoPlanta());
            response.setTimestamp(System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(criarErroCuidados());
        }
    }
    
    /**
     * Reflexão semanal
     * POST /api/v1/planta/reflexao-semanal
     */
    @PostMapping("/reflexao-semanal")
    @Operation(summary = "Reflexão semanal de progresso",
               description = "A planta cria uma reflexão profunda sobre a semana")
    public ResponseEntity<ReflexaoResponse> gerarReflexaoSemanal(@RequestBody ReflexaoRequest request) {
        try {
            String reflexao = aiService.gerarReflexaoSemanal(request.getDadosSemana());
            
            ReflexaoResponse response = new ReflexaoResponse();
            response.setReflexao(reflexao);
            response.setSemanaNumero(request.getSemanaNumero());
            response.setTimestamp(System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(criarErroReflexao());
        }
    }
    
    /**
     * Sugestões de atividades substitutas
     * POST /api/v1/planta/atividades-substitutas
     */
    @PostMapping("/atividades-substitutas")
    @Operation(summary = "Sugerir atividades para substituir o vício",
               description = "A planta sugere alternativas saudáveis nos momentos gatilho")
    public ResponseEntity<AtividadesResponse> sugerirAtividades(@RequestBody AtividadesRequest request) {
        try {
            List<String> sugestoes = aiService.sugerirAtividadesSubstitutas(
                request.getTipoVicio(),
                request.getMomentoGatilho(),
                request.getPreferencias()
            );
            
            AtividadesResponse response = new AtividadesResponse();
            response.setSugestoes(sugestoes);
            response.setMomentoGatilho(request.getMomentoGatilho());
            response.setTimestamp(System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(criarErroAtividades());
        }
    }
    
    /**
     * Mensagem de boa noite
     * POST /api/v1/planta/boa-noite
     */
    @PostMapping("/boa-noite")
    @Operation(summary = "Mensagem de boa noite",
               description = "A planta se despede com reflexão do dia")
    public ResponseEntity<MensagemResponse> mensagemBoaNoite(@RequestBody MensagemRequest request) {
        try {
            String mensagem = aiService.gerarMensagemBoaNoite(request.getResumoDia());
            
            MensagemResponse response = new MensagemResponse();
            response.setMensagem(mensagem);
            response.setTipo("BOA_NOITE");
            response.setTimestamp(System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            MensagemResponse fallback = new MensagemResponse();
            fallback.setMensagem("A noite chegou. Descanse. Amanhã é um novo dia. 🌙🌱");
            fallback.setTipo("BOA_NOITE");
            return ResponseEntity.ok(fallback);
        }
    }
    
    /**
     * Mensagem de bom dia
     * POST /api/v1/planta/bom-dia
     */
    @PostMapping("/bom-dia")
    @Operation(summary = "Mensagem de bom dia",
               description = "A planta desperta com mensagem motivacional")
    public ResponseEntity<MensagemResponse> mensagemBomDia(@RequestBody MensagemRequest request) {
        try {
            String mensagem = aiService.gerarMensagemBomDia(request.getContexto());
            
            MensagemResponse response = new MensagemResponse();
            response.setMensagem(mensagem);
            response.setTipo("BOM_DIA");
            response.setTimestamp(System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            MensagemResponse fallback = new MensagemResponse();
            fallback.setMensagem("Bom dia! O sol nasceu para nós. Vamos florescer juntos hoje! ☀️🌱");
            fallback.setTipo("BOM_DIA");
            return ResponseEntity.ok(fallback);
        }
    }
    
    /**
     * Celebrar conquista/marco
     * POST /api/v1/planta/celebrar
     */
    @PostMapping("/celebrar")
    @Operation(summary = "Celebrar conquista",
               description = "A planta celebra marcos importantes (7 dias, 30 dias, etc)")
    public ResponseEntity<CelebracaoResponse> celebrarConquista(@RequestBody CelebracaoRequest request) {
        try {
            String celebracao = aiService.celebrarConquista(
                request.getTipoConquista(),
                request.getDiasLimpo()
            );
            
            CelebracaoResponse response = new CelebracaoResponse();
            response.setMensagem(celebracao);
            response.setDiasLimpo(request.getDiasLimpo());
            response.setConquista(request.getTipoConquista());
            response.setTimestamp(System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(criarErroCelebracao());
        }
    }
    
    /**
     * Health check da IA
     * GET /api/v1/planta/health
     */
    @GetMapping("/health")
    @Operation(summary = "Verificar status da consciência da planta")
    public ResponseEntity<Map<String, String>> healthCheck() {
        return ResponseEntity.ok(Map.of(
            "status", "healthy",
            "consciencia", "ATIVA",
            "mensagem", "Estou aqui, viva e pronta para ajudar 🌱",
            "timestamp", String.valueOf(System.currentTimeMillis())
        ));
    }
    
    // ===== MÉTODOS AUXILIARES =====
    
    private String detectarEmocao(String resposta) {
        if (resposta.contains("🌸") || resposta.contains("celebr")) return "ALEGRE";
        if (resposta.contains("dif") || resposta.contains("des")) return "EMPATICA";
        if (resposta.contains("cresc") || resposta.contains("raiz")) return "MOTIVADORA";
        return "ACOLHEDORA";
    }
    
    private ConversaResponse criarErro(String mensagem) {
        ConversaResponse erro = new ConversaResponse();
        erro.setRespostaPlanta(mensagem);
        erro.setTimestamp(System.currentTimeMillis());
        return erro;
    }
    
    private ProgressoResponse criarErroProgresso() {
        ProgressoResponse erro = new ProgressoResponse();
        erro.setReflexao("Cada dia é único. Estou aqui com você.");
        return erro;
    }
    
    private CuidadosResponse criarErroCuidados() {
        CuidadosResponse erro = new CuidadosResponse();
        erro.setOrientacao("Me regue com carinho, assim como cuida de si mesmo.");
        return erro;
    }
    
    private ReflexaoResponse criarErroReflexao() {
        ReflexaoResponse erro = new ReflexaoResponse();
        erro.setReflexao("Esta semana teve seus desafios. Mas você está aqui. Isso é vitória.");
        return erro;
    }
    
    private AtividadesResponse criarErroAtividades() {
        AtividadesResponse erro = new AtividadesResponse();
        erro.setSugestoes(List.of("Respire fundo", "Regue-me", "Caminhe 5 minutos"));
        return erro;
    }
    
    private CelebracaoResponse criarErroCelebracao() {
        CelebracaoResponse erro = new CelebracaoResponse();
        erro.setMensagem("Você chegou até aqui. Estou orgulhosa de nós! 🌸");
        return erro;
    }
}

// ===== DTOs (Data Transfer Objects) =====

class ConversaRequest {
    private String mensagem;
    private Map<String, Object> contexto;
    
    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }
    public Map<String, Object> getContexto() { return contexto; }
    public void setContexto(Map<String, Object> contexto) { this.contexto = contexto; }
}

class ConversaResponse {
    private String respostaPlanta;
    private Long timestamp;
    private String emocao;
    
    public String getRespostaPlanta() { return respostaPlanta; }
    public void setRespostaPlanta(String resposta) { this.respostaPlanta = resposta; }
    public Long getTimestamp() { return timestamp; }
    public void setTimestamp(Long timestamp) { this.timestamp = timestamp; }
    public String getEmocao() { return emocao; }
    public void setEmocao(String emocao) { this.emocao = emocao; }
}

class ProgressoRequest {
    private Map<String, Object> dadosDia;
    
    public Map<String, Object> getDadosDia() { return dadosDia; }
    public void setDadosDia(Map<String, Object> dados) { this.dadosDia = dados; }
}

class ProgressoResponse {
    private String reflexao;
    private Object diasLimpo;
    private Long timestamp;
    
    public String getReflexao() { return reflexao; }
    public void setReflexao(String reflexao) { this.reflexao = reflexao; }
    public Object getDiasLimpo() { return diasLimpo; }
    public void setDiasLimpo(Object dias) { this.diasLimpo = dias; }
    public Long getTimestamp() { return timestamp; }
    public void setTimestamp(Long timestamp) { this.timestamp = timestamp; }
}

class SuporteRequest {
    private String sentimento;
    private Map<String, Object> contexto;
    
    public String getSentimento() { return sentimento; }
    public void setSentimento(String sentimento) { this.sentimento = sentimento; }
    public Map<String, Object> getContexto() { return contexto; }
    public void setContexto(Map<String, Object> contexto) { this.contexto = contexto; }
}

class SuporteResponse {
    private String mensagemSuporte;
    private String urgencia;
    private Long timestamp;
    
    public String getMensagemSuporte() { return mensagemSuporte; }
    public void setMensagemSuporte(String mensagem) { this.mensagemSuporte = mensagem; }
    public String getUrgencia() { return urgencia; }
    public void setUrgencia(String urgencia) { this.urgencia = urgencia; }
    public Long getTimestamp() { return timestamp; }
    public void setTimestamp(Long timestamp) { this.timestamp = timestamp; }
}

class CuidadosRequest {
    private String tipoPlanta;
    private Map<String, Object> condicoesAmbiente;
    
    public String getTipoPlanta() { return tipoPlanta; }
    public void setTipoPlanta(String tipo) { this.tipoPlanta = tipo; }
    public Map<String, Object> getCondicoesAmbiente() { return condicoesAmbiente; }
    public void setCondicoesAmbiente(Map<String, Object> condicoes) { this.condicoesAmbiente = condicoes; }
}

class CuidadosResponse {
    private String orientacao;
    private String tipoPlanta;
    private Long timestamp;
    
    public String getOrientacao() { return orientacao; }
    public void setOrientacao(String orientacao) { this.orientacao = orientacao; }
    public String getTipoPlanta() { return tipoPlanta; }
    public void setTipoPlanta(String tipo) { this.tipoPlanta = tipo; }
    public Long getTimestamp() { return timestamp; }
    public void setTimestamp(Long timestamp) { this.timestamp = timestamp; }
}

class ReflexaoRequest {
    private Map<String, Object> dadosSemana;
    private Integer semanaNumero;
    
    public Map<String, Object> getDadosSemana() { return dadosSemana; }
    public void setDadosSemana(Map<String, Object> dados) { this.dadosSemana = dados; }
    public Integer getSemanaNumero() { return semanaNumero; }
    public void setSemanaNumero(Integer semana) { this.semanaNumero = semana; }
}

class ReflexaoResponse {
    private String reflexao;
    private Integer semanaNumero;
    private Long timestamp;
    
    public String getReflexao() { return reflexao; }
    public void setReflexao(String reflexao) { this.reflexao = reflexao; }
    public Integer getSemanaNumero() { return semanaNumero; }
    public void setSemanaNumero(Integer semana) { this.semanaNumero = semana; }
    public Long getTimestamp() { return timestamp; }
    public void setTimestamp(Long timestamp) { this.timestamp = timestamp; }
}

class AtividadesRequest {
    private String tipoVicio;
    private String momentoGatilho;
    private Map<String, Object> preferencias;
    
    public String getTipoVicio() { return tipoVicio; }
    public void setTipoVicio(String tipo) { this.tipoVicio = tipo; }
    public String getMomentoGatilho() { return momentoGatilho; }
    public void setMomentoGatilho(String momento) { this.momentoGatilho = momento; }
    public Map<String, Object> getPreferencias() { return preferencias; }
    public void setPreferencias(Map<String, Object> pref) { this.preferencias = pref; }
}

class AtividadesResponse {
    private List<String> sugestoes;
    private String momentoGatilho;
    private Long timestamp;
    
    public List<String> getSugestoes() { return sugestoes; }
    public void setSugestoes(List<String> sugestoes) { this.sugestoes = sugestoes; }
    public String getMomentoGatilho() { return momentoGatilho; }
    public void setMomentoGatilho(String momento) { this.momentoGatilho = momento; }
    public Long getTimestamp() { return timestamp; }
    public void setTimestamp(Long timestamp) { this.timestamp = timestamp; }
}

class MensagemRequest {
    private Map<String, Object> resumoDia;
    private Map<String, Object> contexto;
    
    public Map<String, Object> getResumoDia() { return resumoDia; }
    public void setResumoDia(Map<String, Object> resumo) { this.resumoDia = resumo; }
    public Map<String, Object> getContexto() { return contexto; }
    public void setContexto(Map<String, Object> contexto) { this.contexto = contexto; }
}

class MensagemResponse {
    private String mensagem;
    private String tipo;
    private Long timestamp;
    
    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public Long getTimestamp() { return timestamp; }
    public void setTimestamp(Long timestamp) { this.timestamp = timestamp; }
}

class CelebracaoRequest {
    private String tipoConquista;
    private Integer diasLimpo;
    
    public String getTipoConquista() { return tipoConquista; }
    public void setTipoConquista(String tipo) { this.tipoConquista = tipo; }
    public Integer getDiasLimpo() { return diasLimpo; }
    public void setDiasLimpo(Integer dias) { this.diasLimpo = dias; }
}

class CelebracaoResponse {
    private String mensagem;
    private Integer diasLimpo;
    private String conquista;
    private Long timestamp;
    
    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }
    public Integer getDiasLimpo() { return diasLimpo; }
    public void setDiasLimpo(Integer dias) { this.diasLimpo = dias; }
    public String getConquista() { return conquista; }
    public void setConquista(String conquista) { this.conquista = conquista; }
    public Long getTimestamp() { return timestamp; }
    public void setTimestamp(Long timestamp) { this.timestamp = timestamp; }
}
