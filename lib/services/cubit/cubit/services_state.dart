part of 'services_cubit.dart';

sealed class ServicesState {}

final class ServicesInitial extends ServicesState {}

final class ServicesLoading extends ServicesState {}

final class ServicesLoaded extends ServicesState {
  final List<ServiceModel> services;
  ServicesLoaded({required this.services});
}

final class ServicesError extends ServicesState {
  final String message;
  ServicesError({required this.message});
}
