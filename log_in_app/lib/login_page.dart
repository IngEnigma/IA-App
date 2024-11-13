import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'singup_page.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> authenticateUser(
      BuildContext context, String username, String password) async {
    const String authMutation = """
    mutation TokenAuth(\$username: String!, \$password: String!) {
      tokenAuth(username: \$username, password: \$password) {
        token
      }
    }
    """;

    final options = MutationOptions(
      document: gql(authMutation),
      variables: {
        'username': username,
        'password': password,
      },
    );

    final result = await client.value.mutate(options);
    if (result.hasException) {
      Provider.of<MyAppState>(context, listen: false)
          .setError("Error en la autenticación");
    } else {
      final token = result.data?['tokenAuth']['token'];
      Provider.of<MyAppState>(context, listen: false).updateToken(token);
      print("Token: $token");
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LOG IN',
                  style: TextStyle(
                    color: const Color(0xff262c40),
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: const Color(0xfff2f7fb), fontSize: 18),
                  decoration: InputDecoration(
                    fillColor: const Color(0xff839dd1),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: 'USERNAME',
                    hintStyle: TextStyle(color: const Color(0xfff2f7fb)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: const Color(0xfff2f7fb), fontSize: 18),
                  decoration: InputDecoration(
                    fillColor: const Color(0xff839dd1),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: 'PASSWORD',
                    hintStyle: TextStyle(color: const Color(0xfff2f7fb)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String username = usernameController.text;
                    String password = passwordController.text;

                    if (username.isNotEmpty && password.isNotEmpty) {
                      await authenticateUser(context, username, password);
                    }
                  },
                  child: Text(
                    'LOG IN',
                    style:
                        TextStyle(color: const Color(0xfff2f7fb), fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4a5989),
                    foregroundColor: const Color(0xfff2f7fb),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 18.0, horizontal: 117.0),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      color: const Color(0xff4a5989),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
