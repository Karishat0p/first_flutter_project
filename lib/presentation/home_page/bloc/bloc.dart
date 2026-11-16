import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_flutter_project/repositories/film_repository.dart';
import 'package:first_flutter_project/presentation/home_page/bloc/events.dart';
import 'package:first_flutter_project/presentation/home_page/bloc/state.dart';
import 'package:first_flutter_project/domain/models/card.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FilmRepository repo;

  HomeBloc(this.repo) : super(const HomeState()) {
    // Регистрируем обработчик события
    on<HomeLoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(HomeLoadDataEvent event, Emitter<HomeState> emit) async {
    if (event.nextPage != null) {
      emit(state.copyWith(isPaginationLoading: true, error: null));
    } else {
      emit(state.copyWith(isLoading: true, error: null));
    }

    String? error;

    //запрашиваем данные
    final newData = await repo.loadData(
        query: event.search ?? 'man',
        page: event.nextPage ?? 1,
        onError: (e) => error = e,
    );

    //склеиваем данные
    List<CardData>? finalData = newData;
    if (event.nextPage != null && newData != null) {
      finalData = [...(state.data ?? []), ...newData];
    }

    emit(state.copyWith(
      isLoading: false,
      isPaginationLoading: false,
      data: finalData,
      error: error,
    ));
  }
}