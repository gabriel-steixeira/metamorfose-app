/**
 * File: psychologist_event.dart
 * Description: Define os eventos relacionados ao gerenciamento de psicólogos no BLoC.
 *
 * Responsabilidades:
 * - Declarar classes de eventos que o BLoC de psicólogos escuta.
 * - Permitir o carregamento e manipulação de dados de psicólogos.
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

part of '../../blocs/psychologist_bloc.dart';

abstract class PsychologistEvent {}

class LoadPsychologistsEvent extends PsychologistEvent {}
