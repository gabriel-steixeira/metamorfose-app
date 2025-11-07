/**
 * File: run_tests.dart
 * Description: Script para executar todos os testes do aplicativo.
 *
 * Responsabilidades:
 * - Executar testes unitários
 * - Executar testes de widget
 * - Executar testes de integração
 * - Gerar relatórios de cobertura
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:io';

void main(List<String> args) async {
  print('🧪 Iniciando execução dos testes de QA...\n');

  // Executa testes unitários
  print('📋 Executando testes unitários...');
  final unitResult = await Process.run(
    'flutter',
    ['test', 'test/unit/'],
    workingDirectory: Directory.current.path,
  );
  
  if (unitResult.exitCode == 0) {
    print('✅ Testes unitários passaram!\n');
  } else {
    print('❌ Testes unitários falharam:');
    print(unitResult.stderr);
    print(unitResult.stdout);
  }

  // Executa testes de widget
  print('🎨 Executando testes de widget...');
  final widgetResult = await Process.run(
    'flutter',
    ['test', 'test/widget/'],
    workingDirectory: Directory.current.path,
  );
  
  if (widgetResult.exitCode == 0) {
    print('✅ Testes de widget passaram!\n');
  } else {
    print('❌ Testes de widget falharam:');
    print(widgetResult.stderr);
    print(widgetResult.stdout);
  }

  // Executa testes de integração
  print('🔗 Executando testes de integração...');
  final integrationResult = await Process.run(
    'flutter',
    ['test', 'integration_test/'],
    workingDirectory: Directory.current.path,
  );
  
  if (integrationResult.exitCode == 0) {
    print('✅ Testes de integração passaram!\n');
  } else {
    print('❌ Testes de integração falharam:');
    print(integrationResult.stderr);
    print(integrationResult.stdout);
  }

  // Executa todos os testes com cobertura
  print('📊 Executando todos os testes com cobertura...');
  final coverageResult = await Process.run(
    'flutter',
    ['test', '--coverage'],
    workingDirectory: Directory.current.path,
  );
  
  if (coverageResult.exitCode == 0) {
    print('✅ Cobertura de testes gerada!\n');
  } else {
    print('❌ Erro ao gerar cobertura:');
    print(coverageResult.stderr);
    print(coverageResult.stdout);
  }

  // Resumo final
  print('📈 Resumo dos testes:');
  print('==================');
  print('Testes unitários: ${unitResult.exitCode == 0 ? '✅' : '❌'}');
  print('Testes de widget: ${widgetResult.exitCode == 0 ? '✅' : '❌'}');
  print('Testes de integração: ${integrationResult.exitCode == 0 ? '✅' : '❌'}');
  print('Cobertura: ${coverageResult.exitCode == 0 ? '✅' : '❌'}');
  
  final allPassed = unitResult.exitCode == 0 && 
                   widgetResult.exitCode == 0 && 
                   integrationResult.exitCode == 0;
  
  if (allPassed) {
    print('\n🎉 Todos os testes passaram! Aplicativo pronto para produção.');
  } else {
    print('\n⚠️  Alguns testes falharam. Verifique os erros acima.');
    exit(1);
  }
}
