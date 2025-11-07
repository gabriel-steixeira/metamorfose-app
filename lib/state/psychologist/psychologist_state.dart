/**
 * File: psychologist_state.dart
 * Description: Define os estados utilizados pelo BLoC de psicólogos.
 *
 * Responsabilidades:
 * - Representar os diferentes estados do processo de carregamento de psicólogos.
 * - Controlar o fluxo entre estado inicial, carregando, carregado e erro.
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

part of '../../blocs/psychologist_bloc.dart';

abstract class PsychologistState {}

class PsychologistInitial extends PsychologistState {}

class PsychologistLoading extends PsychologistState {}

class PsychologistLoaded extends PsychologistState {
  final List<dynamic> list; // use dynamic to avoid strict model typing issues
  PsychologistLoaded(this.list);
}

class PsychologistError extends PsychologistState {
  final String message;
  PsychologistError(this.message);
}
