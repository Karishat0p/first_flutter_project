import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'like_event.dart';
import 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final Box _box = Hive.box('favorites');

  LikeBloc() : super(const LikeState(likedIds: [])) {
    on<LoadLikesEvent>(_onLoadLikes);
    on<ChangeLikeEvent>(_onChangeLike);
  }

  //загрузка лайков при старте
  Future<void> _onLoadLikes(LoadLikesEvent event, Emitter<LikeState> emit) async {
    //получаем все ключи из Hive. это и есть лайки.
    final List<String> ids = _box.keys.map((key) => key.toString()).toList();
    emit(state.copyWith(likedIds: ids));
  }

  //переключение лайка
  Future<void> _onChangeLike(ChangeLikeEvent event, Emitter<LikeState> emit) async {
    //проверяем, есть ли уже лайк
    if (_box.containsKey(event.id)) {
      await _box.delete(event.id); //удаляем из Hive
    } else {
      await _box.put(event.id, true); //добавляем в Hive
    }

    //Заново считываем все ID, чтобы обновить
    final List<String> ids = _box.keys.map((key) => key.toString()).toList();
    emit(state.copyWith(likedIds: ids));
  }
}