import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:to_do_apps/ui/theme.dart';

//create a stateless widget for button
class MyButton extends StatelessWidget {

  final String label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15
            ),
          ),
        ),
      ),
    );
  }
}
