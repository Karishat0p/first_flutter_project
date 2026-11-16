import 'package:first_flutter_project/domain/models/card.dart';
import 'package:first_flutter_project/data/dtos/films_dto.dart';

typedef OnErrorCallback = void Function(String? error);

abstract class ApiInterface {
  Future<List<CardData>?> loadData({
    required String query,
    int page = 1,
    OnErrorCallback? onError,
  });
  Future<FilmDataDto?> loadDetails(
      String imdbId,
      {OnErrorCallback? onError}
  );
}