import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class SingUpPage extends StatefulWidget {
  @override
  _SingUpPage createState() => _SingUpPage();
}

class _SingUpPage extends State<SingUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> createUser(BuildContext context, String email, String username,
      String password) async {
    const String registerMutation = """
    mutation CreateUser(\$email: String!, \$password: String!, \$username: String!) {
      createUser(email: \$email, password: \$password, username: \$username) {
        user {
          id
          email
          username
        }
      }
    }
    """;

    final options = MutationOptions(
      document: gql(registerMutation),
      variables: {
        'email': email,
        'username': username,
        'password': password,
      },
    );

    final result = await client.value.mutate(options);
    if (result.hasException) {
      print("Error al crear usuario: ${result.exception.toString()}");
    } else {
      print("Usuario creado exitosamente");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
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
                  'SIGN UP',
                  style: TextStyle(
                    color: const Color(0xff262c40),
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: const Color(0xfff2f7fb), fontSize: 18),
                  decoration: InputDecoration(
                    fillColor: const Color(0xff839dd1),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: 'EMAIL',
                    hintStyle: TextStyle(color: const Color(0xfff2f7fb)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
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
                    String email = emailController.text;
                    String username = usernameController.text;
                    String password = passwordController.text;

                    if (email.isNotEmpty &&
                        username.isNotEmpty &&
                        password.isNotEmpty) {
                      await createUser(context, email, username, password);
                    }
                  },
                  child: Text(
                    'CREATE ACCOUNT',
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
                        EdgeInsets.symmetric(vertical: 18.0, horizontal: 68.0),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
