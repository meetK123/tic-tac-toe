import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_tac_game/screens/tic_tac_toe_screen.dart';
import 'package:tic_tac_game/values/constant.dart';

void main() => runApp(const TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(width, height),
      useInheritedMediaQuery: true,

      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Tic Tac Toe',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const TicTacToeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
