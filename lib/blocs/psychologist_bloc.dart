///cabeçalho do arquivo
///

import 'package:bloc/bloc.dart';
// model import intentionally omitted — service returns dynamic list
import 'package:metamorfose_flutter/services/psychologist_service.dart';

part '../state/psychologist/psychologist_event.dart';
part '../state/psychologist/psychologist_state.dart';

class PsychologistBloc extends Bloc<PsychologistEvent, PsychologistState> {
  final PsychologistService _service;

  PsychologistBloc({PsychologistService? service})
      : _service = service ?? PsychologistService(),
        super(PsychologistInitial()) {
    on<LoadPsychologistsEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadPsychologistsEvent event,
    Emitter<PsychologistState> emit,
  ) async {
    emit(PsychologistLoading());
    try {
      final list = await _service.fetchNearbyPsychologists();
      emit(PsychologistLoaded(list));
    } catch (e) {
      emit(PsychologistError('Erro ao carregar psicólogos'));
    }
  }
}
