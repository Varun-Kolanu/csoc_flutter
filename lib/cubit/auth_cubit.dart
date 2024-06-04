import 'package:csoc_flutter/models/user_model.dart';
import 'package:csoc_flutter/repositories/user_repository.dart';
import 'package:csoc_flutter/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;

  AuthCubit(this._userRepository) : super(AuthInitial());

  Future<void> signinWithGoogle() async {
    emit(AuthLoading());
    final result = await AuthService().signInWithGoogle();
    if (result == null) {
      emit(const AuthError("Google sign in failed"));
    } else {
      final userCredentials = result.user;

      if (userCredentials != null) {
        Map<String, dynamic> userMap = UserModel(
                email: userCredentials.email,
                id: userCredentials.uid,
                name: userCredentials.displayName)
            .toJson();

        _userRepository.createUser(userCredentials.uid, userMap).then((value) {
          emit(AuthSuccess(value));
        }).catchError((error) {
          emit(const AuthError("Failed to create user"));
        });
      } else {
        emit(const AuthError("No User Found"));
      }
    }
  }

  Future<void> signOut() async {
    await AuthService().firebaseAuth.signOut();
    emit(AuthInitial());
  }
}
