import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:first_flutter_project/data/dtos/films_dto.dart';
import 'package:first_flutter_project/domain/models/card.dart';
import 'package:first_flutter_project/repositories/api_interface.dart';
import 'package:first_flutter_project/data/mappers/films_mapper.dart';

class FilmRepository extends ApiInterface {
  static final Dio _dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));

  static const String _baseUrl = 'https://www.omdbapi.com';
  static const String _apiKey = 'c37df519';

  @override
  Future<List<CardData>?> loadData({
    required String query,
    int page = 1,
    OnErrorCallback? onError,
  }) async {
    try {
      const String url = '$_baseUrl/';

      final Response<dynamic> response = await _dio.get<dynamic>(
        url,
        queryParameters: {
          'apikey': _apiKey,
          's': query,
          'page': page, //пагинация
        },
      );

      final json = response.data;
      if (json == null || json['Response'] == 'False') return null;

      final FilmsSearchDto dto = FilmsSearchDto.fromJson(json);
      final List<FilmDataDto>? searchResults = dto.search;

      if (searchResults == null || searchResults.isEmpty) return [];

      final List<CardData> cards = [];

      for (var film in searchResults) {
        if (film.imdbId != null) {
          final FilmDataDto? details = await loadDetails(film.imdbId!, onError: onError);

          if (details != null) {
            cards.add(details.toDomain());
          }
        }
      }

      return cards;

    } on DioException catch (e) {
      onError?.call(e.message);
      //debugPrint('Ошибка OMDb: ${e.message}');
      return null;
    }
  }

  @override
  Future<FilmDataDto?> loadDetails(String imdbId, {OnErrorCallback? onError}) async {
    try {
      const String url = '$_baseUrl/';

      final Response<dynamic> response = await _dio.get<dynamic>(
        url,
        queryParameters:  {
          'apikey': _apiKey,
          'i': imdbId,
        },
      );

      final json = response.data;
      if (json == null || json['Response'] == 'False') {
        return null;
      }

      return FilmDataDto.fromJson(json);
    } on DioException catch (e) {
      onError?.call(e.error?.toString());
      //debugPrint('Ошибка OMDb: ${e.message}');
      return null;
    }
  }
}