import 'package:equatable/equatable.dart';

class LikeState extends Equatable {
  final List<String>? likedIds;

  const LikeState({this.likedIds = const []});

  LikeState copyWith({List<String>? likedIds}) => LikeState(
    likedIds: likedIds ?? this.likedIds,
  );

  @override
  List<Object?> get props => [likedIds];
}