import 'dart:ffi';
import 'package:final_app/singup_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:final_app/login_page.dart';
import 'package:final_app/logs_pages.dart';
import 'package:final_app/singup_page.dart';
import 'package:provider/provider.dart';

final HttpLink httpLink =
    HttpLink("https://apilogin-6iuf.onrender.com/graphql/");

final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);

void main() async {
  await initHiveForFlutter();
  runApp(MyApp());
}

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, appState, child) {
        if (!appState.isAuthenticated) {
          return LoginPage();
        }
        return child!;
      },
      child: child,
    );
  }
}

class MyAppState extends ChangeNotifier {
  String token = "";
  String error = "";
  bool get isAuthenticated => token.isNotEmpty;

  void updateToken(String newToken) {
    token = newToken;
    notifyListeners();
  }

  void setError(String errorMessage) {
    error = errorMessage;
    notifyListeners();
  }

  void logout() {
    token = "";
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Log In App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x6374ae)),
          ),
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = LoginPage();
        break;
      case 1:
        page = SingUpPage();
        break;
      case 2:
        page = LogsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.login),
                        label: 'Log In',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_add),
                        label: 'Sign Up',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Logs',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      final appState =
                          Provider.of<MyAppState>(context, listen: false);
                      if (value >= 2 && !appState.isAuthenticated) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } else {
                        setState(() {
                          selectedIndex = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.login),
                        label: Text('Log In'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_add),
                        label: Text('Sign Up'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Logs'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
