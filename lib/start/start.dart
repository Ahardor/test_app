import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/parameters.dart';
import 'package:test_app/start/start_m.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  static var emailCtrl = TextEditingController();

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
      builder: (context, state) => Scaffold(
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
            children: [
              Image.asset("assets/start.png"),
              const SizedBox(height: 30),
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
              EmailTextField(
                emailValid: state.emailValid,
              ),
              const SizedBox(height: 100),
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
                    context.read<StartManager>().checkEmail();
                  },
                  child: const Text(
                    'Send Code',
                    style: TextStyle(fontSize: 20, fontFamily: 'Outfit'),
                  ),
                ),
              ),
              const SizedBox(height: 100),
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
              const SizedBox(height: 60),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmailTextField extends StatefulWidget {
  EmailTextField({
    super.key,
    required this.emailValid,
  });

  bool emailValid;

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          widget.emailValid = true;
        });
      },
      controller: StartPage.emailCtrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        hintText: "Enter Email",
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        hoverColor: Colors.transparent,
        errorText: !widget.emailValid ? 'Please enter valid email!' : null,
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