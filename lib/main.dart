import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/start/start.dart';
import 'package:test_app/start/start_m.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => StartManager(),
        child: const StartPage(),
      ),
      theme: ThemeData(
          // fontFamily: 'Outfit',
          ),
    );
  }
}
