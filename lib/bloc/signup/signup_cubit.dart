import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nativ/data/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit(this._authRepository) : super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void isTraveler(bool value) {
    emit(state.copyWith(isTraveler: value, status: SignupStatus.initial));
  }

  void isNativ(bool value) {
    emit(state.copyWith(isNativ: value, status: SignupStatus.initial));
  }

  void isBoth(bool value) {
    emit(state.copyWith(
        isNativ: value, isTraveler: value, status: SignupStatus.initial));
  }

  Future<void> signupFormSubmitted() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      await _authRepository.signUp(
          email: state.email, password: state.password);
      emit(state.copyWith(status: SignupStatus.success));
    } catch (_) {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }
}
