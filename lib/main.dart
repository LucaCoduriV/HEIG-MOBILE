import 'dart:developer';
import 'package:heig_front/screens/login_screen.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    VRouter(
      debugShowCheckedModeBanner: false, // VRouter acts as a MaterialApp
      mode: VRouterMode.history, // Remove the '#' from the url
      logs: VLogs.info, // Defines which logs to show, info is the default
      routes: [
        VWidget(
          path: '/login',
          widget: LoginWidget(),
          stackedRoutes: [
            ConnectedRoutes(), // Custom VRouteElement
          ],
        ),
        // This redirect every unknown routes to /login
        VRouteRedirector(
          redirectTo: '/login',
          path: r':_(.*)', // .* is a regexp which matching every paths
        ),
      ],
    ),
  );
}

class ConnectedRoutes extends VRouteElementBuilder {
  static final String profile = 'profile';

  static void toProfile(BuildContext context, String username) =>
      context.vRouter.to('/$username/$profile');

  static final String settings = 'settings';

  static void toSettings(BuildContext context, String username) =>
      context.vRouter.to('/$username/$settings');

  @override
  List<VRouteElement> buildRoutes() {
    return [
      VNester(
        path:
            '/:username', // :username is a path parameter and can be any value
        widgetBuilder: (child) => Builder(
          // Simply use a Builder if you need the context
          builder: (context) {
            // We can use the names to get the index, this is sometimes preferred to parsing the url
            final currentIndex =
                context.vRouter.names.contains(profile) ? 0 : 1;
            return MyScaffold(child, currentIndex: currentIndex);
          },
        ),
        nestedRoutes: [
          VWidget(
            path: profile,
            name: profile,
            widget: ProfileWidget(),
          ),
          VWidget(
            path: settings,
            name: settings,
            widget: SettingsWidget(),

            // Custom transition
            buildTransition: (animation, ___, child) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
          ),
        ],
      ),
    ];
  }
}

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String name = 'bob';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Enter your name to connect: '),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      onChanged: (value) => name = value,
                      initialValue: 'bob',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            // This FAB is shared and shows hero animations working with no issues
            FloatingActionButton(
              heroTag: 'FAB',
              onPressed: () {
                setState(() => (_formKey.currentState!.validate())
                    ? ConnectedRoutes.toProfile(context, name)
                    : null);
              },
              child: Icon(Icons.login),
            )
          ],
        ),
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MyScaffold(this.child, {required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('You are connected'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.info_outline), label: 'Info'),
        ],
        onTap: (int index) {
          // We can access this username via the path parameters
          final username = VRouter.of(context).pathParameters['username']!;
          if (index == 0) {
            ConnectedRoutes.toProfile(context, username);
          } else {
            ConnectedRoutes.toSettings(context, username);
          }
        },
      ),
      body: child,

      // This FAB is shared with login and shows hero animations working with no issues
      floatingActionButton: FloatingActionButton(
        heroTag: 'FAB',
        onPressed: () => VRouter.of(context).to('/login'),
        child: Icon(Icons.logout),
      ),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // VNavigationGuard allows you to react to navigation events locally
    return VWidgetGuard(
      // When entering or updating the route, we try to get the count from the local history state
      // This history state will be NOT null if the user presses the back button for example
      afterEnter: (context, __, ___) => getCountFromState(context),
      afterUpdate: (context, __, ___) => getCountFromState(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  VRouter.of(context).to(
                    context.vRouter.url,
                    isReplacement: true,
                    historyState: {'count': '${count + 1}'},
                  );
                  setState(() => count++);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueAccent,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    'Your pressed this button $count times',
                    style: buttonTextStyle,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  print('historyState: ${context.vRouter.historyState}');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueAccent,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    'Press to print historyState',
                    style: buttonTextStyle,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'This number is saved in the history state so if you are on the web leave this page and hit the back button to see this number restored!',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getCountFromState(BuildContext context) {
    print(
        'AFTER UPDATE with historyState: ${VRouter.of(context).historyState}');
    setState(() {
      count = (VRouter.of(context).historyState['count'] == null)
          ? 0
          : int.tryParse(VRouter.of(context).historyState['count'] ?? '') ?? 0;
    });
  }
}

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Did you see the custom animation when coming here?',
              style: textStyle.copyWith(fontSize: textStyle.fontSize! + 2),
            ),
          ],
        ),
      ),
    );
  }
}

final textStyle = TextStyle(color: Colors.black, fontSize: 16);
final buttonTextStyle = textStyle.copyWith(color: Colors.white);

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HEIG Front")),
      body: Text("body"),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // ...
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
