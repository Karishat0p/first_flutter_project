import 'package:json_annotation/json_annotation.dart';

part 'films_dto.g.dart';

@JsonSerializable(createToJson: false)
class FilmsSearchDto {
  @JsonKey(name: 'Search')
  final List<FilmDataDto>? search;

  @JsonKey(name: 'totalResults')
  final String? totalResults;

  @JsonKey(name: 'Response')
  final String? response;

  const FilmsSearchDto({
    this.search,
    this.totalResults,
    this.response,
  });

  factory FilmsSearchDto.fromJson(Map<String, dynamic> json) =>
      _$FilmsSearchDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FilmDataDto {
  @JsonKey(name: 'Title')
  final String? title;

  @JsonKey(name: 'Year')
  final String? year;

  @JsonKey(name: 'Poster')
  final String? poster;

  @JsonKey(name: 'imdbID')
  final String? imdbId;

  @JsonKey(name: 'Director')
  final String? director;

  @JsonKey(name: 'Plot')
  final String? plot;

  @JsonKey(name: 'Genre')
  final String? genre;

  @JsonKey(name: 'Runtime')
  final String? runtime;

  @JsonKey(name: 'Ratings')
  final List<RatingDto>? ratings;

  const FilmDataDto({
    this.title,
    this.year,
    this.poster,
    this.imdbId,
    this.director,
    this.plot,
    this.genre,
    this.runtime,
    this.ratings,
  });

  factory FilmDataDto.fromJson(Map<String, dynamic> json) =>
      _$FilmDataDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class RatingDto {
  @JsonKey(name: 'Source')
  final String? source;

  @JsonKey(name: 'Value')
  final String? value;

  const RatingDto({this.source, this.value});

  factory RatingDto.fromJson(Map<String, dynamic> json) =>
      _$RatingDtoFromJson(json);
}