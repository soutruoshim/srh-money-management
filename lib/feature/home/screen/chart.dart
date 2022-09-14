import 'package:flutter/material.dart';
import 'package:monsey/common/constant/styles.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Coming soon!',
          style: title3(context: context),
        ),
      ),
    );
  }
}
