import 'package:flutter/material.dart';
import 'sidebar.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseScreen({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Sidebar(),
      body: body,
    );
  }
}
