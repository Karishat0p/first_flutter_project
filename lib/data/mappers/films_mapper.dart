import 'package:flutter/material.dart';
import 'package:first_flutter_project/data/dtos/films_dto.dart';
import 'package:first_flutter_project/domain/models/card.dart';

extension FilmDataDtoToModel on FilmDataDto {
  CardData toDomain() => CardData(
    title ?? 'UNKNOWN',
    descriptionText: _makeDescriptionText(year, director, runtime, ratings),
    imageUrl: poster,
    imdbId: imdbId,
  );
}

extension ListFilmDtoToModel on List<FilmDataDto> {
  List<CardData> toDomain() => map((e) => e.toDomain()).toList();
}

String _makeDescriptionText(String? year, String? director, String? runtime, List<RatingDto>? ratings) {
  final ratingsText = ratings?.map((r) => '${r.source}: ${r.value}').join(', ') ?? '';
  return '$year - $director - $runtime\n$ratingsText';
}