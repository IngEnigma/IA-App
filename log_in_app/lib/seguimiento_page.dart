import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:final_app/main.dart';
import 'package:provider/provider.dart';

class SeguimientoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.token.isEmpty) {
      return Center(
        child: Text("No login yet"),
      );
    } else {
      return Center(
        child: Text("Logged in"),
      );
    }
  }
}
