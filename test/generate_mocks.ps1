# Script PowerShell para gerar mocks automaticamente
# Executa build_runner para gerar os arquivos de mock

Write-Host "🔧 Gerando mocks para testes..." -ForegroundColor Yellow

# Gera os mocks
flutter packages pub run build_runner build --delete-conflicting-outputs

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Mocks gerados com sucesso!" -ForegroundColor Green
    Write-Host "📁 Arquivos gerados em: test/test_helpers/" -ForegroundColor Cyan
} else {
    Write-Host "❌ Erro ao gerar mocks!" -ForegroundColor Red
    exit 1
}
