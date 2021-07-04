import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onClicked;
  final Color color;
  final Color textColor;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.onClicked,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: color,
          ),
          onPressed: onClicked as void Function()?,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}