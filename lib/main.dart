// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:quotes2/pages/homepage.dart';
import 'package:quotes2/pages/quoteoftheday.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes by king w',
      debugShowCheckedModeBanner: false,
      home: entryScreen(),
      routes: {'/splashScreenPageView': (context) => splashScreenPageView()},
    );
  }
}

class splashScreenPageView extends StatefulWidget {
  const splashScreenPageView({super.key});

  @override
  State<splashScreenPageView> createState() => _splashScreenPageViewState();
}

class _splashScreenPageViewState extends State<splashScreenPageView> {
  final PageController _pageController = PageController(viewportFraction: 1.0);


  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final int? currentPage = _pageController.page?.round();
      if (currentPage == 0) {
        precacheImage(AssetImage('assets/images/14.jpg'), context);
      }
      else if (currentPage==1){
        precacheImage(AssetImage('assets/images/splash 12.jpg'), context);
        precacheImage(AssetImage('assets/images/splash 11.jpg'), context);
      }
    });
  
  }

@override
  void dispose() {
_pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: PageView(
        controller: _pageController,
        children: [
        Splashscreen1(pageController: _pageController,),
        Splashscreen2(),
      ]),
    );
  }
}

class entryScreen extends StatelessWidget {
  const entryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      if (!context.mounted) return;
      await precacheImage(AssetImage('assets/images/splash 11.jpg'), context);
      await precacheImage(AssetImage('assets/images/14.jpg'), context);
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/splashScreenPageView');
      }
    });
    return Scaffold(
      backgroundColor: Colors.black,
        body:
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  Icons.format_quote_sharp,
                  color: const Color.fromARGB(255, 47, 57, 74),
                  size: 50,
                ),
              ),
              Center(
                  child: Text(
                ' QUOTES BY KING W',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ))
            ],
          ),
        ),
      
    );
  }
}

class Splashscreen1 extends StatelessWidget {
  final PageController pageController;
  const Splashscreen1({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
 Container(
  color: Colors.black,
   child: FadeInImage(placeholder: MemoryImage(kTransparentImage), image:           // Background Image
             AssetImage('assets/images/splash 11.jpg',),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fadeInDuration: const Duration(milliseconds: 500),
      ),
 ),
          // Content Overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Get inspired by wisdom of the past',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Ensure text is visible
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Learn from great people in history on the best ways to maximize productivity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Ensure text is visible
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Splashscreen2 extends StatelessWidget {
  const Splashscreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
Container( color: Colors.black,
  child: FadeInImage(placeholder: MemoryImage(kTransparentImage), image:           // Background Image
              AssetImage('assets/images/14.jpg'),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fadeInDuration: const Duration(milliseconds: 500),
  ),
),
          // Content Overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Usability',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Ensure text is visible
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Quotes by King W is all about bringing knowledge from the past to make an impact in the future',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Ensure text is visible
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'With Adaptive Feedback',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Ensure text is visible
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Learn with Quotes by King W',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Ensure text is visible
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=> Quoteoftheday(),)
                    );
                  },
                  child: const Text('Proceed'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
