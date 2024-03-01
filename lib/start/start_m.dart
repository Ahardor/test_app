import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/parameters.dart';
import 'package:test_app/start/start.dart';
import 'package:http/http.dart' as http;

class StartState {
  StartState({
    this.authorized = false,
    this.emailValid = true,
    this.rt = "",
    this.jwt = "",
  });

  StartState copyWith({
    bool? authorized,
    bool? emailValid,
    String? rt,
    String? jwt,
  }) =>
      StartState(
        authorized: authorized ?? this.authorized,
        emailValid: emailValid ?? this.emailValid,
        rt: rt ?? this.rt,
        jwt: jwt ?? this.jwt,
      );

  bool authorized;
  bool emailValid;
  String rt;
  String jwt;
}

class StartManager extends Cubit<StartState> {
  StartManager() : super(StartState());

  var emailRegEx =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  void checkEmail() {
    var email = StartPage.emailCtrl.text;

    if (email.isEmpty || !RegExp(emailRegEx).hasMatch(email)) {
      emit(state.copyWith(authorized: false, emailValid: false));
    } else {}
  }

  void getCode(String email) {
    http
        .post(
      Uri.parse("${url}login"),
      body: '{"email": $email}',
    )
        .then((value) {
      emit(state.copyWith(authorized: true, emailValid: true));
    });
  }
}
