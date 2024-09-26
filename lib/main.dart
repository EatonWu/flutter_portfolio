import 'dart:io';
import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:portfolio_site/RadialGradientColorSplash.dart';
import 'package:portfolio_site/resume_pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:pdfx/pdfx.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'carousel_widget.dart';

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
        child: AboutPage(title: 'About Page')
      ),
    ),
    GoRoute(
      name: 'demos',
      path: '/demos',
      routes: <RouteBase>[
        GoRoute(
          path: 'cgg',
          name: 'demo',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const DemoPage(title: 'CGG Demo')
          ),
        ),
      ],
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const DemoPage(title: 'Demos')
      ),
    ),
    GoRoute(
      name: 'test',
      path: '/test',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const TestPage()
      ),
    ),
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
          // 222223FF get color from hex
          secondary: const Color(0xFF222223),
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
  final int _maxCircles = 200;

  @override
  void initState() {
    // random value between 50 and 500
    var randomDuration = 30;
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
          // cancel timer and start new timer with new random duration
          randomDuration = 30;
          _circleCount++;

          _timer?.cancel();
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
                _circleCount++;
              });
            } else {
              _timer?.cancel();
            }
          });
        });
      } else {
        _timer?.cancel();
      }
    });

    // for (var i = 0; i < 75; i++) {
    //   var randomListOfColors = generateRandomListOfColors(30);
    //   var randomColor1 = randomListOfColors[Random().nextInt(randomListOfColors.length)];
    //   var randomColor2 = randomListOfColors[Random().nextInt(randomListOfColors.length)];
    //   splashes.add(
    //       radialGradientColorSplash(
    //           randomColor1,
    //           randomColor2
    //       )
    //   );
    //   _circleCount++;
    // }
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
    var backgroundColor = Theme.of(context).colorScheme.secondary;
    return Column(
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('signature.png'),
            ],
          ),
        ),
        const Flexible(child: NavTabBar()),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // circle buttons with github, linkedin, and email
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () async {
                          Uri url = Uri.parse("https://www.github.com/EatonWu");
                          // open github
                          if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.code),
                            Text(' GitHub'),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            Uri url = Uri.parse("https://www.linkedin.com/in/eaton-wu/");
                            if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.person),
                              Text(' LinkedIn'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Uri url = Uri.parse("mailto:eatonwu100@hotmail.com");
                          // if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
                          //   throw 'Could not launch $url';
                          // }
                          await Clipboard.setData(const ClipboardData(text: "eatonwu100@hotmail.com"));
                          Fluttertoast.showToast(msg: "Email copied to clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: backgroundColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                              webPosition: 'center'); // bottom-center
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.email),
                            Text(' Email'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class NavTabBar extends StatefulWidget {
  const NavTabBar({super.key});
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

class AboutPage extends StatefulWidget {
  AboutPage({super.key, required this.title});

  final pdfPinchController = PdfControllerPinch(
    document: PdfDocument.openAsset('EatonWuResume.pdf'),

  );
  final String title;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Title(
      title: widget.title,
      color: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            double aspectRatio = constraints.maxWidth / constraints.maxHeight;

            bool isWide = aspectRatio > 1.5;

            return Column(
              children: [
                Image.asset('signature.png'),
                NavTabBar(),
                Expanded(
                  child: isWide
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child:
                        Container(child:
                          Column(children: [
                            Expanded(child:
                              Container(
                                child: CarouselWidget(),
                            )),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(child: Container(width: constraints.maxWidth / 2, height: 1, color: primaryColor)),
                                  ],
                                );
                              },
                            ),
                            const Expanded(child: BioWidget()),
                          ],
                        ))
                      ),
                      Expanded(child:
                        Container(
                          child: ResumePdf()
                        )
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      Expanded(child: Container(
                        child: Column(children: [
                          Expanded(child: Container(
                            child: CarouselWidget(),
                          )),
                          Expanded(child: const BioWidget()),
                        ],
                        )),
                      ),
                      Expanded(child: Container(child: ResumePdf()),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}



class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double aspectRatio = constraints.maxWidth / constraints.maxHeight;

          bool isWide = aspectRatio > 1.5;

          return Column(
            children: [
              Image.asset('signature.png'),
              NavTabBar(),
              Expanded(
                child: isWide
                    ? Row(
                  children: [
                    Expanded(child: Container(color: Colors.blue)),
                    Expanded(child: Container(
                        child: ResumePdf()
                    )
                    ),
                  ],
                )
                    : Column(
                  children: [
                    Expanded(child: Container(color: Colors.blue)),
                    Expanded(child: Container(child: ResumePdf()),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class IconLabelElevatedButton extends StatelessWidget {
  const IconLabelElevatedButton({super.key, required this.icon, required this.label, required this.link});

  final IconData icon;
  final String label;
  final String link;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Uri url = Uri.parse(link);
        // open github
        if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
          throw 'Could not launch $url';
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Text(label),
        ],
      ),
    );
  }
}

class BioWidget extends StatelessWidget {
  const BioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text("Hi! Above are images of some things that I've done.\n"
                  "I'm an alumnus of the Rochester Institute of Technology (2024 with a Bachelors of Science in Computer Science).\n"
                  "My primary interests are embedded systems, web development, and machine learning.\n"
                  "You can find some of my projects under active development below.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Flexible(
                child: IconLabelElevatedButton(icon: Icons.code, label: ' Company search/apply', link: 'https://github.com/EatonWu/search_and_apply')),
              Flexible(child: Padding(padding: const EdgeInsets.all(4.0),),),
              Flexible(
                child: IconLabelElevatedButton(icon: Icons.code, label: ' Machine learning in Rust', link: 'https://github.com/EatonWu/RustML')),
              Flexible(child: Padding(padding: const EdgeInsets.all(4.0),),),
              Flexible(
                child: IconLabelElevatedButton(icon: Icons.code, label: ' Open source algorithmic trading backtesting crate', link: 'https://github.com/EatonWu/free-quant')),
              Flexible(child: Padding(padding: const EdgeInsets.all(4.0),),),
              Flexible(
                child: IconLabelElevatedButton(icon: Icons.code, label: ' This website, developed using flutter :)', link: 'https://github.com/EatonWu/flutter_portfolio')),
            ],
          ),
        ),
      ],
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
