import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/controllers/auth_controller.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

import '/app/controllers/controller.dart';

class SignUpController extends Controller {
  late final AuthSolidController authController;
  @override
  construct(BuildContext context) {
    super.construct(context);
    authController = Solid.get<AuthSolidController>(context);
    signUpSignal = Signal(SignUpStateInitial());
  }

  Signal<AuthSignal> get authSignal => authController.authSignal;
  late final Signal<SignUpState> signUpSignal;
  SignUpState get signUpState => signUpSignal.value;

  Future signUp({
    required String email,
    required String password,
  }) {
    return authController
        .signUp(
      email: email,
      password: password,
    )
        .then((success) {
      if (success) {
        signUpSignal.set(signUpState.copyWith<SignUpSuccessState>());
      }
    });
  }
}

class _ViewModel {
  const _ViewModel();

  _ViewModel copyWith() {
    return _ViewModel();
  }
}

abstract class SignUpState {
  final _ViewModel viewModel;

  const SignUpState(this.viewModel);

  T copyWith<T extends SignUpState>({
    _ViewModel? viewModel,
  }) {
    return _factories[T == SignUpState ? runtimeType : T]!(
      viewModel ?? this.viewModel,
    );
  }
}

class SignUpStateInitial extends SignUpState {
  const SignUpStateInitial({
    _ViewModel viewModel = const _ViewModel(),
  }) : super(viewModel);
}

class SignUpSuccessState extends SignUpState {
  SignUpSuccessState({
    _ViewModel viewModel = const _ViewModel(),
  }) : super(viewModel);
}

final _factories = <Type,
    Function(
  _ViewModel viewModel,
)>{
  SignUpStateInitial: (viewModel) => SignUpStateInitial(
        viewModel: viewModel,
      ),
  SignUpSuccessState: (viewModel) => SignUpSuccessState(
        viewModel: viewModel,
      ),
};
