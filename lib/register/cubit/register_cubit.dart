import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainment_services/core/data/app_data.dart';
import 'package:entertainment_services/login/user_model.dart';
import 'package:entertainment_services/register/cubit/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  void register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user?.uid != null) {
        UserModel user = UserModel(
          email,
          name,
          phone,
          'User',
          result.user!.uid,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .set(user.toJson());

        userModel = user;
        emit(RegisterSuccess());
      }
    } on FirebaseAuthException catch (e) {
      emit(RegisterError(e.message ?? ''));
    }
  }
}
