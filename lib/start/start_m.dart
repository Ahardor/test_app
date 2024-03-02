import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/parameters.dart';
import 'package:test_app/start/start.dart';
import 'package:http/http.dart' as http;

// App states
enum States { start, invalidEmail, codeSent, invalidCode, authorized }

class StartState {
  StartState({
    this.currentState = States.start,
    this.rt = "",
    this.jwt = "",
    this.email = "",
    this.userId = "",
  });

  StartState copyWith({
    States? currentState,
    String? rt,
    String? jwt,
    String? email,
    String? userId,
  }) =>
      StartState(
        currentState: currentState ?? this.currentState,
        email: email ?? this.email,
        rt: rt ?? this.rt,
        jwt: jwt ?? this.jwt,
        userId: userId ?? this.userId,
      );

  States currentState;
  String rt;
  String jwt;
  String email;
  String userId;
}

class StartManager extends Cubit<StartState> {
  StartManager() : super(StartState());

  // Regular expression to check email format
  var emailRegEx =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  // Switch button click function based on state
  void press() {
    switch (state.currentState) {
      case States.start:
        checkEmail();
        break;
      case States.invalidEmail:
        checkEmail();
        break;
      case States.codeSent:
        checkCode();
        break;
      case States.invalidCode:
        checkCode();
        break;
      default:
        break;
    }
  }

  // Refresh page if code is sent but email has been changed
  void refresh() {
    if (StartPage.emailCtrl.text != state.email && state.email != "") {
      emit(StartState(currentState: States.start));
      print("refreshed");
    }
  }

  // Check email format and send code
  void checkEmail() {
    var email = StartPage.emailCtrl.text;

    if (email.isEmpty || !RegExp(emailRegEx).hasMatch(email)) {
      emit(state.copyWith(currentState: States.invalidEmail));
    } else {
      getCode(email);
    }
  }

  // Send code and wait for user input
  void getCode(String email) {
    http
        .post(
      Uri.parse("${url}login"),
      body: '{"email": "$email"}',
    )
        .then((value) {
      if (value.statusCode != 200) {
        print(value.body);
      } else {
        emit(state.copyWith(currentState: States.codeSent, email: email));
      }
    });
  }

  // Check code format and get JWT and RT
  void checkCode() {
    String code = StartPage.codeCtrl.text;

    if (code.isEmpty || code.length != 6 || int.tryParse(code) == null) {
      emit(state.copyWith(currentState: States.invalidCode));
    } else {
      http
          .post(
        Uri.parse("${url}confirm_code"),
        body: '{"email": "${StartPage.emailCtrl.text}", "code": $code}',
      )
          .then((value) {
        if (value.statusCode != 200) {
          emit(state.copyWith(currentState: States.invalidCode));
        } else {
          var resp = jsonDecode(value.body);

          emit(state.copyWith(
            currentState: States.authorized,
            rt: resp["refresh_token"],
            jwt: resp["jwt"],
          ));

          //Set timer to refresh JWT after 1 hour
          Future.delayed(const Duration(minutes: 59), () => refreshToken());
          getUserId();
        }
      });
    }
  }

  // Get user id using JWT
  void getUserId() {
    http.get(Uri.parse("${url}auth"),
        headers: {"Auth": "Bearer ${state.jwt}"}).then((value) {
      if (value.statusCode != 200) {
        print(value.body);
      } else {
        var resp = jsonDecode(value.body);
        emit(state.copyWith(userId: resp["user_id"]));
      }
    });
  }

  // Self looping function to refresh JWT every time it expires
  void refreshToken() {
    print("Refreshing time");
    http
        .post(
      Uri.parse("${url}refresh_token"),
      body: '{"token": "${state.rt}"}',
    )
        .then((value) {
      if (value.statusCode != 200) {
        print(value.body);
      } else {
        var resp = jsonDecode(value.body);

        emit(state.copyWith(
          currentState: States.authorized,
          rt: resp["refresh_token"],
          jwt: resp["jwt"],
        ));

        // Set timer again
        Future.delayed(const Duration(minutes: 59), () => refreshToken());
      }
    });
  }
}
