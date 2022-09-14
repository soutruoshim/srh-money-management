import 'package:flutter/material.dart';
import 'package:monsey/app/widget_support.dart';
import 'package:monsey/common/constant/styles.dart';

class Premium extends StatelessWidget {
  const Premium({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.createSimpleAppBar(
        context: context,
        hasLeading: true,
      ),
      body: Center(
        child: Text(
          'Coming soon!',
          style: title3(context: context),
        ),
      ),
    );
  }
}
