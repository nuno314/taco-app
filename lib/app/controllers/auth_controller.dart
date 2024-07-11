// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  AuthController() {
    usernameSignal = Signal("");
    passwordSignal = Signal("");
    authSignal = Signal(const AuthSignal());
  }

  final supabase = Supabase.instance.client;

  late final Signal<String> usernameSignal;
  late final Signal<String> passwordSignal;

  late final Signal<AuthSignal> authSignal;

  Future signUp({
    required String email,
    required String password,
  }) async {
    authSignal.set(
      authSignal.value.copyWith(
        isLoading: true,
      ),
    );
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
      );
      authSignal.set(
        authSignal.value.copyWith(
          isLoading: false,
          isSuccess: true,
        ),
      );
    } catch (e) {
      authSignal.set(
        authSignal.value.copyWith(
          isLoading: false,
          isError: true,
        ),
      );
    }

    authSignal.set(
      authSignal.value.copyWith(
        isLoading: false,
        isError: false,
        isSuccess: false,
      ),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    authSignal.set(
      authSignal.value.copyWith(
        isLoading: true,
      ),
    );
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      authSignal.set(
        authSignal.value.copyWith(
          isLoading: false,
          isSuccess: true,
        ),
      );
    } catch (e) {
      authSignal.set(
        authSignal.value.copyWith(
          isLoading: false,
          isError: true,
        ),
      );
    }

    authSignal.set(
      authSignal.value.copyWith(
        isLoading: false,
        isError: false,
        isSuccess: false,
      ),
    );
  }

  void dispose() {
    usernameSignal.dispose();
    passwordSignal.dispose();
  }
}

class AuthSignal {
  final bool isLoading;
  final bool? isSuccess;
  final bool? isError;

  const AuthSignal({
    this.isLoading = false,
    this.isSuccess,
    this.isError,
  });

  AuthSignal copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isError,
  }) {
    return AuthSignal(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess,
      isError: isError,
    );
  }
}
