import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainment_services/core/data/app_data.dart';
import 'package:entertainment_services/home/cubit/home_state.dart';
import 'package:entertainment_services/login/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void getUser() async {
    emit(HomeLoading());
    final result = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
        .get();

    if (result.data() != null) {
      userModel = UserModel.fromJson(result.data()!);
      emit(HomeSuccess());
    } else {
      emit(HomeError('Something went wrong'));
    }
  }
}
