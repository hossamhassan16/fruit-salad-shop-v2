import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      emit(AuthSuccess("Sign Up successful"));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Unknown error"));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess("Login successful"));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Unknown error"));
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(AuthSuccess("Reset email sent"));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Unknown error"));
    }
  }
}
