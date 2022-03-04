
import 'package:flutter/material.dart';

class Palette {
  //mapping
  // const MaterialColor(
  //     int primary,
  //     Map<int, Color> swatch
  //     )

  static const MaterialColor kToDark = const MaterialColor(
    0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff2525ea),//10%
      100: const Color(0xff2525ea),//20%
      200: const Color(0xff2525ea),//30%
      300: const Color(0xff2525ea),//40%
      400: const Color(0xff2525ea),//50%
      500: const Color(0xff2525ea),//60%
      600: const Color(0xff2525ea),//70%
      700: const Color(0xff2525ea),//80%
      800: const Color(0xff170907),//90%
      900: const Color(0xff000000),//100%
    },
  );
}