import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/parameters.dart';
import 'package:test_app/start/start_m.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  static var emailCtrl = TextEditingController();
  static var codeCtrl = TextEditingController();

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartManager, StartState>(
      builder: (context, state) {
        // Debugging current app state
        debugPrint("${state.currentState}");
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(
            toolbarHeight: 80,
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Login  ',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  children: [
                    WidgetSpan(
                      child: Image.asset(
                        'assets/user.png',
                        width: 25,
                      ),
                    ),
                    const TextSpan(
                      text: "\nWelcome back",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //different content based on current state
              children: state.currentState == States.authorized
                  ? [
                      Flexible(child: Image.asset("assets/start.png")),
                      const SizedBox(height: 20),
                      Text(
                        "Your ID:",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: AppColors.accent,
                        ),
                      ),
                      // User id
                      Text(
                        state.userId == "" ? "Waiting for ID" : state.userId,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: AppColors.accent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]
                  : [
                      Flexible(child: Image.asset("assets/start.png")),
                      const SizedBox(height: 20),
                      Text(
                        "Enter Your Email",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 50),
                      StartTextField(
                        ctrl: StartPage.emailCtrl,
                        valid: state.currentState != States.invalidEmail,
                      ),
                      const SizedBox(height: 20),
                      // Only shown if code is sent
                      if (state.currentState == States.codeSent ||
                          state.currentState == States.invalidCode)
                        StartTextField(
                          ctrl: StartPage.codeCtrl,
                          valid: state.currentState != States.invalidCode,
                          hintText: "Code",
                          errorText: "Code is not valid",
                        ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            context.read<StartManager>().press();
                          },
                          child: Text(
                            // Different writings based on current state
                            state.currentState == States.codeSent ||
                                    state.currentState == States.invalidCode
                                ? 'Confirm'
                                : 'Send Code',
                            style: const TextStyle(
                                fontSize: 20, fontFamily: 'Outfit'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text("Or"),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You Don't have an account?",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          // Placeholder button
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
            ),
          ),
        );
      },
    );
  }
}

// Stylized TextField widget
// ignore: must_be_immutable
class StartTextField extends StatefulWidget {
  StartTextField(
      {super.key,
      required this.valid,
      this.hintText = "Enter email",
      this.errorText = "Please enter valid email!",
      required this.ctrl});

  bool valid;
  String hintText, errorText;
  TextEditingController ctrl;

  @override
  State<StartTextField> createState() => _StartTextFieldState();
}

class _StartTextFieldState extends State<StartTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          widget.valid = true;
          context.read<StartManager>().refresh();
        });
      },
      controller: widget.ctrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        hintText: widget.hintText,
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        hoverColor: Colors.transparent,
        errorText: !widget.valid ? widget.errorText : null,
        errorStyle: const TextStyle(
            color: Colors.red, fontSize: 14, fontFamily: 'Outfit'),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.accent, width: 1),
        ),
      ),
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
