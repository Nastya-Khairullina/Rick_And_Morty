import 'dart:core';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/error/failure.dart';
import 'package:untitled1/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:untitled1/feature/presentation/bloc/search_bloc/search_state.dart';
import '../../../domain/usecase/search_person.dart';
import 'dart:async';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

// BLoC 8.0.0
class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmpty()) {
    on<SearchPersons>(_onEvent);
  }

  FutureOr<void> _onEvent(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    emit(PersonSearchLoading());
    final failureOrPerson =
    await searchPerson(SearchPersonParams(query: event.personQuery));
    emit(failureOrPerson.fold(
            (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
            (person) => PersonSearchLoaded(persons: person)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}





