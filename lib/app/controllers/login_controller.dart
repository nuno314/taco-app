import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/controllers/auth_controller.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

import '/app/controllers/controller.dart';

class LoginController extends Controller {
  late final AuthSolidController authController;
  @override
  construct(BuildContext context) {
    super.construct(context);
    authController = Solid.get<AuthSolidController>(context);
    loginSignal = Signal(const LoginStateInitial());
  }

  Signal<AuthSignal> get authSignal => authController.authSignal;
  late final Signal<LoginState> loginSignal;
  LoginState get loginState => loginSignal.value;

  Future login({
    required String email,
    required String password,
  }) async {
    await authController
        .signIn(
      email: email,
      password: password,
    )
        .then((success) {
      if (success) {
        loginSignal.set(loginState.copyWith<LoginSuccessState>());
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

abstract class LoginState {
  final _ViewModel viewModel;

  const LoginState(this.viewModel);

  T copyWith<T extends LoginState>({
    _ViewModel? viewModel,
  }) {
    return _factories[T == LoginState ? runtimeType : T]!(
      viewModel ?? this.viewModel,
    );
  }
}

class LoginStateInitial extends LoginState {
  const LoginStateInitial({
    _ViewModel viewModel = const _ViewModel(),
  }) : super(viewModel);
}

class LoginSuccessState extends LoginState {
  LoginSuccessState({
    _ViewModel viewModel = const _ViewModel(),
  }) : super(viewModel);
}

final _factories = <Type,
    Function(
  _ViewModel viewModel,
)>{
  LoginStateInitial: (viewModel) => LoginStateInitial(
        viewModel: viewModel,
      ),
  LoginSuccessState: (viewModel) => LoginSuccessState(
        viewModel: viewModel,
      ),
};
