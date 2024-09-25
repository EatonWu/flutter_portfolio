import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:portfolio_site/RadialGradientColorSplash.dart';
import 'dart:async';

final _router = GoRouter(
  initialLocation: '/home',
  errorBuilder: (context, state) {
    return const ErrorPage();
  },
  routes: <RouteBase>[
    GoRoute(
      name: 'home',
      path: '/home',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const MyHomePage(title: 'Portfolio Home'),
      ),
    ),
    GoRoute(
      name: 'about',
      path: '/about',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const AboutPage(title: 'About Page')
      ),
    ),
    GoRoute(
      name: 'demos',
      path: '/demos',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const DemoPage(title: 'Demos')
      ),
    )
  ],
);



void main() {
  // debugPaintSizeEnabled = true;
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // set primary color to a dark color

    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.blueGrey,
          surface: Colors.black87,
        ),
      ),
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> splashes = [];
  Timer? _timer;
  int _circleCount = 0;
  final int _maxCircles = 150;

  @override
  void initState() {
    // random value between 250 and 1000
    var randomDuration = Random().nextInt(750) + 250;
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: randomDuration), (timer) {
      if (_circleCount < _maxCircles) {
        setState(() {
          var randomListOfColors = generateRandomListOfColors(30);
          var randomColor1 = randomListOfColors[Random().nextInt(randomListOfColors.length)];
          var randomColor2 = randomListOfColors[Random().nextInt(randomListOfColors.length)];
          splashes.add(
              radialGradientColorSplash(
                  randomColor1,
                  randomColor2
              )
          );
          randomDuration = Random().nextInt(750) + 250;
          _circleCount++;
        });
      } else {
        _timer?.cancel();
      }
    });

    for (var i = 0; i < 50; i++) {
      var randomListOfColors = generateRandomListOfColors(30);
      var randomColor1 = randomListOfColors[Random().nextInt(randomListOfColors.length)];
      var randomColor2 = randomListOfColors[Random().nextInt(randomListOfColors.length)];
      splashes.add(
          radialGradientColorSplash(
              randomColor1,
              randomColor2
          )
      );
      _circleCount++;
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure timer is canceled when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: widget.title,
      color: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 1,
                    child: Stack(
                      // fit: StackFit.expand,
                      children: [
                        ...splashes,
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 5,
                      child: HomePageMainContent(),
                  ),
                  Flexible(
                    flex: 1,
                    child: Stack(
                      // fit: StackFit.expand,
                      children: [
                        ...splashes,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageMainContent extends StatelessWidget {
  const HomePageMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('signature.png'),
          ],
        ),
        NavTabBar(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // circle buttons with github, linkedin, and email
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text("Welcome!",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 96,
                          )
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // open github
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.code),
                        Text(' GitHub'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // open linkedin
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.person),
                          Text(' LinkedIn'),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // open email
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.email),
                        Text(' Email'),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        )
      ],
    );
  }
}

class NavTabBar extends StatefulWidget {
  int selectedIndex = 0;
  int size = 3;
  NavTabBar({super.key});
  @override
  State<NavTabBar> createState() => _NavTabBarState();
}

class _NavTabBarState extends State<NavTabBar> {
  @override
  Widget build(BuildContext context) {
    var currentLoc = GoRouterState.of(context).name;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            _router.go('/home');
          },
          child: currentLoc == 'home' ? const Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
            ),
          ) : const Text('Home'),
        ),
        Container(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
          height: 20,
        ),
        TextButton(
          onPressed: () {
            _router.go('/about');
          },
          child: currentLoc == 'about' ? const Text(
              'About',
              style: TextStyle(
                color: Colors.white,
              ),
          ) : const Text('About'),
        ),
        Container(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
          height: 20,
        ),
        TextButton(
          onPressed: () {
            _router.go('/demos');
          },
          child: currentLoc == 'demos' ? const Text(
              'Demos',
              style: TextStyle(
                color: Colors.white,
              ),
          ) : const Text('Demos'),
        ),
      ],
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('signature.png'),
          NavTabBar(),
          const Flexible(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('🤷‍♂️', style: TextStyle(fontSize: 96)),
                          Text('Page not found', style: TextStyle(fontSize: 24)),
                          Text('404'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Title(
      title: title,
      color: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        body: Column(
          children: [
            Image.asset('signature.png'),
            NavTabBar(),
            const Center(
              child: Text('About Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Title(
      title: title,
      color: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        body: Column(
          children: [
            Image.asset('signature.png'),
            NavTabBar(),
            const Center(
              child: Text('Demo Page'),
            ),
          ],
        ),
      ),
    );
  }
}
