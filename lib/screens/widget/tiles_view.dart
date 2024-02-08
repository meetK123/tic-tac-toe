import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class TilesView extends StatelessWidget {
  const TilesView({super.key, this.callBack, this.drawText, this.myTextRenderBox, this.myTextKey});

  final Function()? callBack;
  final String? drawText;

  final RenderBox? myTextRenderBox;
  final Key? myTextKey;

  @override
  Widget build(BuildContext context) {
    return
      TouchRippleEffect(
        rippleColor:Colors.white,
        borderRadius: BorderRadius.circular(10.0).r,
        onTap: () {
          HapticFeedback.mediumImpact();
          if (callBack != null) callBack!();
        },
        child: ClipRect(
          child: BackdropFilter(
            filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0).r,
                color: Colors.grey.shade200.withOpacity(0.5)
            /*    gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent.shade100,
                    Colors.deepPurpleAccent.shade200,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),*/
                /*  boxShadow:const [
                    BoxShadow(
                      color: Colors.deepPurple,
                      blurRadius: 3.0,
                   //  spreadRadius: 5.0,
                      offset: Offset(
                        10.0,
                        10.0,
                      ),
                    ),
                  ],*/
              ),
              child: Center(
                child: Text(
                  drawText ?? '',
                  key: myTextKey,
                  style: TextStyle(
                    fontSize: 50.0.sm,
                    fontWeight: FontWeight.bold,
                    color: drawText == 'X' ? Colors.yellow : Colors.cyanAccent,
                    shadows: <Shadow>[
                      Shadow(
                        offset: const Offset(5.0, 5.0),
                        blurRadius: 3.0,
                        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                      ),
                    ],
                    //foreground:  Paint()..shader = getTextGradient(myTextRenderBox),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }

  Shader? getTextGradient(RenderBox? renderBox) {
    if (renderBox == null) return null;
    return const LinearGradient(
      colors: <Color>[Colors.deepOrange, Colors.lightGreenAccent],
    ).createShader(Rect.fromLTWH(renderBox.localToGlobal(Offset.zero).dx, renderBox.localToGlobal(Offset.zero).dy, renderBox.size.width, renderBox.size.height));
  }
}
