import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/start/start.dart';

class StartState {
  StartState({
    this.authorized = false,
    this.emailValid = true,
  });

  StartState copyWith({
    bool? authorized,
    bool? emailValid,
  }) =>
      StartState(
        authorized: authorized ?? this.authorized,
        emailValid: emailValid ?? this.emailValid,
      );

  bool authorized;
  bool emailValid;
}

class StartManager extends Cubit<StartState> {
  StartManager() : super(StartState());

  var emailRegEx =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  void checkEmail() {
    var email = StartPage.emailCtrl.text;

    if (email.isEmpty || !RegExp(emailRegEx).hasMatch(email)) {
      emit(state.copyWith(authorized: false, emailValid: false));
    }
  }
}
