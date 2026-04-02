import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/search_users_usecase.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final SearchUsersUseCase search;

  UsersBloc({required this.search}) : super(UsersState.initial()) {
    on<UsersStarted>(_onRefresh);
    on<UsersQueryChanged>(_onQuery);
    on<UsersFilterChanged>(_onFilter);
  }

  Future<void> _doSearch(Emitter<UsersState> emit, {String? query, dynamic filter}) async {
    final q = query ?? state.query;
    final f = filter ?? state.filter;
    emit(state.copyWith(status: UsersStatus.loading, query: q, filter: f, error: null));
    try {
      final list = await search(query: q, filter: f);
      emit(state.copyWith(status: UsersStatus.success, users: list));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onRefresh(UsersStarted event, Emitter<UsersState> emit) async => _doSearch(emit);
  Future<void> _onQuery(UsersQueryChanged event, Emitter<UsersState> emit) async => _doSearch(emit, query: event.query);
  Future<void> _onFilter(UsersFilterChanged event, Emitter<UsersState> emit) async => _doSearch(emit, filter: event.filter);
}


