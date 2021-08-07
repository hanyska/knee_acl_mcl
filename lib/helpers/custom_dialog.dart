import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget footer;

  CustomDialog({
    required this.title,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDialogBorderRadius),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: new BoxDecoration(
          color: kWhite,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(kDialogBorderRadius),
          boxShadow: [
            BoxShadow(
              color: kBlack.withOpacity(0.3),
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 15.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            body,
            SizedBox(height: 20.0),
            footer,
            SizedBox(height: 5.0),
          ],
        ),
      )
    );
  }
}
