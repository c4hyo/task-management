import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ForgotPasswordView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ForgotPasswordView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ForgotPasswordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
