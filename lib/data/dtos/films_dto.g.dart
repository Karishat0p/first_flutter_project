// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'films_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilmsSearchDto _$FilmsSearchDtoFromJson(Map<String, dynamic> json) =>
    FilmsSearchDto(
      search: (json['Search'] as List<dynamic>?)
          ?.map((e) => FilmDataDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: json['totalResults'] as String?,
      response: json['Response'] as String?,
    );

FilmDataDto _$FilmDataDtoFromJson(Map<String, dynamic> json) => FilmDataDto(
      title: json['Title'] as String?,
      year: json['Year'] as String?,
      poster: json['Poster'] as String?,
      imdbId: json['imdbID'] as String?,
      director: json['Director'] as String?,
      plot: json['Plot'] as String?,
      genre: json['Genre'] as String?,
      runtime: json['Runtime'] as String?,
      ratings: (json['Ratings'] as List<dynamic>?)
          ?.map((e) => RatingDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

RatingDto _$RatingDtoFromJson(Map<String, dynamic> json) => RatingDto(
      source: json['Source'] as String?,
      value: json['Value'] as String?,
    );
