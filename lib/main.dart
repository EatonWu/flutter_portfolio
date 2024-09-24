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
      builder: (context, state) => const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
    GoRoute(
      name: '404',
      path: '/404',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          appBar: AppBar(title: const Text('404')),
          body: const Center(child: Text('404')),
        ),
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
    super.initState();
    // Start a timer that adds a new splash every 0.5 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_circleCount < _maxCircles) {
        setState(() {
          var randomListOfColors = generateRandomListOfColors(20);
          var randomColor1 = randomListOfColors[Random().nextInt(randomListOfColors.length)];
          var randomColor2 = randomListOfColors[Random().nextInt(randomListOfColors.length)];
          splashes.add(
              radialGradientColorSplash(
                  randomColor1,
                  randomColor2
              )
          );
          _circleCount++;
        });
      } else {
        _timer?.cancel(); // Stop the timer once the limit is reached
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure timer is canceled when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('signature.png'),
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
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
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page not found'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // massive shrug emoji
            Text('🤷‍♂️', style: TextStyle(fontSize: 96)),
            Text('Page not found', style: TextStyle(fontSize: 24)),
            Text('404'),
          ],
        ),
      ),
    );
  }
}
