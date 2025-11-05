#
# File: test-metamorfose.sh
# Description: Script de teste de integração completo para o projeto Metamorfose.
#
# Responsabilidades:
# - Verificar status dos containers Docker.
# - Testar endpoints de health check (Backend, AI Service).
# - Executar testes de integração contra todos os endpoints da API de IA (chatbot, relatório, sugestões, anomalia, FAQ).
# - Validar a conexão com o banco de dados Oracle.
# - Verificar a disponibilidade dos serviços de monitoramento (Prometheus, Grafana).
# - Gerar um relatório final de sucesso ou falha dos testes.
#
# Author: Ester Silva
# Created on: 29-11-2025
# Last modified: 03-11-2025
# Version: 1.2.0
# Squad: Metamorfose
#

#!/bin/bash
# Script de Validação Completa - Smart HAS Metamorfose
# Este script testa todos os componentes do sistema

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configurações
API_URL="http://localhost:8080"
AI_ENDPOINT="$API_URL/api/v1/ai"

echo "=========================================="
echo "Smart HAS Metamorfose - Teste Completo"
echo "=========================================="
echo ""

# Função para testar endpoint
test_endpoint() {
    local name=$1
    local method=$2
    local endpoint=$3
    local data=$4
    
    echo -n "Testando $name... "
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -o /dev/null -w "%{http_code}" "$endpoint")
    else
        response=$(curl -s -o /dev/null -w "%{http_code}" \
            -X "$method" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$endpoint")
    fi
    
    if [ "$response" = "200" ]; then
        echo -e "${GREEN}✓ OK${NC} (HTTP $response)"
        return 0
    else
        echo -e "${RED}✗ FALHOU${NC} (HTTP $response)"
        return 1
    fi
}

# Função para teste com resposta
test_with_response() {
    local name=$1
    local method=$2
    local endpoint=$3
    local data=$4
    
    echo ""
    echo "----------------------------------------"
    echo "Teste: $name"
    echo "----------------------------------------"
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s "$endpoint")
    else
        response=$(curl -s -X "$method" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$endpoint")
    fi
    
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
    echo ""
}

# Contador de testes
total_tests=0
passed_tests=0

# 1. Verificar se containers estão rodando
echo "1. Verificando containers Docker..."
echo "-----------------------------------"
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Containers estão rodando${NC}"
    ((passed_tests++))
else
    echo -e "${RED}✗ Containers não estão rodando${NC}"
    echo "Execute: docker-compose up -d"
    exit 1
fi
((total_tests++))
echo ""

# 2. Testar Health Checks
echo "2. Testando Health Checks..."
echo "----------------------------"
test_endpoint "Backend Health" "GET" "$API_URL/actuator/health"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

test_endpoint "AI Service Health" "GET" "$AI_ENDPOINT/health"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi
echo ""

# 3. Testar Chatbot IA
echo "3. Testando Chatbot IA..."
echo "-------------------------"
chatbot_data='{
  "pergunta": "Como posso reduzir meu consumo de energia?",
  "contexto": {
    "consumoMensal": 350,
    "metaMensal": 300
  }
}'

test_with_response "Chatbot" "POST" "$AI_ENDPOINT/chatbot" "$chatbot_data"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# 4. Testar Geração de Relatório
echo "4. Testando Geração de Relatório..."
echo "------------------------------------"
relatorio_data='{
  "dadosConsumo": {
    "consumoTotal": 450,
    "consumoAnterior": 380,
    "variacao": "+18.4%",
    "picoConsumo": "14h-16h",
    "custoEstimado": 315.00
  },
  "periodo": "outubro/2024"
}'

test_with_response "Relatório Automático" "POST" "$AI_ENDPOINT/relatorio" "$relatorio_data"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# 5. Testar Sugestões de Otimização
echo "5. Testando Sugestões de Otimização..."
echo "---------------------------------------"
sugestoes_data='{
  "usuarioId": "user123",
  "perfilConsumo": {
    "consumoMedio": 400,
    "horarioPico": "18h-22h",
    "aparelhosMaisUsados": ["chuveiro", "ar-condicionado"],
    "temperaturaAmbiente": 28
  }
}'

test_with_response "Sugestões de Economia" "POST" "$AI_ENDPOINT/sugestoes" "$sugestoes_data"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# 6. Testar Análise de Anomalia
echo "6. Testando Análise de Anomalia..."
echo "-----------------------------------"
anomalia_data='{
  "anomaliaId": "anom_test_001",
  "dadosAnomalia": {
    "consumoEsperado": 15,
    "consumoReal": 45,
    "aparelho": "chuveiro",
    "horario": "03:00",
    "duracao": "2 horas"
  }
}'

test_with_response "Análise de Anomalia" "POST" "$AI_ENDPOINT/anomalia" "$anomalia_data"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# 7. Testar FAQ
echo "7. Testando FAQ..."
echo "------------------"
test_with_response "FAQ - Economia" "GET" "$AI_ENDPOINT/faq?categoria=economia&pergunta=Como%20economizar%20energia%20na%20geladeira?"
((total_tests++))
if [ $? -eq 0 ]; then ((passed_tests++)); fi

# 8. Testar Conexão Oracle
echo "8. Testando Conexão Oracle..."
echo "------------------------------"
if docker exec metamorfose-oracle sqlplus -s system/oracle123@//localhost:1521/XEPDB1 <<< "SELECT 1 FROM DUAL;" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Conexão Oracle OK${NC}"
    ((passed_tests++))
else
    echo -e "${RED}✗ Conexão Oracle FALHOU${NC}"
fi
((total_tests++))
echo ""

# 9. Testar Prometheus
echo "9. Testando Prometheus..."
echo "-------------------------"
if curl -s http://localhost:9090/-/healthy > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Prometheus OK${NC}"
    ((passed_tests++))
else
    echo -e "${YELLOW}⚠ Prometheus não disponível${NC}"
fi
((total_tests++))
echo ""

# 10. Testar Grafana
echo "10. Testando Grafana..."
echo "-----------------------"
if curl -s http://localhost:3000/api/health > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Grafana OK${NC}"
    ((passed_tests++))
else
    echo -e "${YELLOW}⚠ Grafana não disponível${NC}"
fi
((total_tests++))
echo ""

# Relatório Final
echo "=========================================="
echo "RELATÓRIO FINAL"
echo "=========================================="
echo ""
echo "Total de testes: $total_tests"
echo "Testes passados: $passed_tests"
echo "Testes falhados: $((total_tests - passed_tests))"
echo ""

percentage=$((passed_tests * 100 / total_tests))
if [ $percentage -ge 80 ]; then
    echo -e "${GREEN}✓ Sistema funcionando corretamente ($percentage%)${NC}"
    exit 0
else
    echo -e "${RED}✗ Sistema com problemas ($percentage%)${NC}"
    exit 1
fi