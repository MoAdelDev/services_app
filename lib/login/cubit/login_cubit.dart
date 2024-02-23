import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainment_services/core/data/app_data.dart';
import 'package:entertainment_services/login/cubit/login_state.dart';
import 'package:entertainment_services/login/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user?.uid != null) {
        final data = await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .get();
        userModel = UserModel.fromJson(data.data()!);
        emit(LoginSuccess());
      } else {
        emit(LoginError('Email or password is incorrect'));
      }
    } on FirebaseAuthException catch (_) {
      emit(LoginError('Email or password is incorrect'));
    }
  }
}
