import 'package:equatable/equatable.dart';
import 'package:first_flutter_project/domain/models/card.dart';

class HomeState extends Equatable {
  final List<CardData>? data;
  final bool isLoading; //лоадер для первого поиска
  final bool isPaginationLoading; //лоадер для подгрузки внизу
  final String? error;

  const HomeState({
    this.data,
    this.isLoading = false,
    this.isPaginationLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<CardData>? data,
    bool? isLoading,
    bool? isPaginationLoading,
    String? error,
  }) =>
      HomeState(
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
    data,
    isLoading,
    isPaginationLoading,
    error,
  ];
}