import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class RoundedWrapper extends StatelessWidget {
  final Widget? child;

  RoundedWrapper({
    Key? key,
    this.child,
  }): super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kVeryLightGrey,
        borderRadius: BorderRadius.circular(29)
      ),
      child: child,
    );
  }
}
