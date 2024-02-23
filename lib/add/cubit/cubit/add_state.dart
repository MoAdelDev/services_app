part of 'add_cubit.dart';

sealed class AddState {}

final class AddInitial extends AddState {}

final class AddLoading extends AddState {}

final class AddSuccess extends AddState {}

final class AddError extends AddState {
  final String error;
  AddError(this.error);
}

final class UploadImage extends AddState {
  UploadImage();
}
