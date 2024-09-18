import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/feature/domain/entityes/person_entity.dart';
import 'package:untitled1/feature/domain/usecase/get_all_persons.dart';
import 'package:untitled1/feature/presentation/bloc/person_list_cubit/person_list_state.dart';

import '../../../../core/error/failure.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPersons getAllPersons;

  PersonListCubit({required this.getAllPersons}) : super(PersonEmpty());

  int page = 1;

  void loadPerson() async {
    if (state is PersonLoading) return;

    final currentState = state;

    var oldPerson = <PersonEntity>[];
    if (currentState is PersonLoaded) {
      oldPerson = currentState.personsList;
    }

    emit(PersonLoading(oldPerson, isFirstFetch: page == 1));

    final failureOrPerson = await getAllPersons(PagePersonParams(page: page));

    failureOrPerson.fold(
            (error) => emit(PersonError(message: _mapFailureToMessage(error))),
            (character) {
          page++;
          final persons = (state as PersonLoading).oldPersonsList;
          persons.addAll(character);
          print('List length: ${persons.length.toString()}');
          emit(PersonLoaded(persons));
        });
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