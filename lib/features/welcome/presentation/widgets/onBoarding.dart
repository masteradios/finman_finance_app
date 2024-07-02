import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/authWelcomeScreen.dart';
import 'buildContainer.dart';
import 'buildPage.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _pageController = PageController();
  List<Widget> topBar = [];
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 4; i++) {
      list.add(buildContainer(i == _currentPage, (i == 1 || i == 2)));
    }
    return list;
  }

  void onTap() async {
    _pageController.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    if (_currentPage == 3) {
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setBool('tutorialDone', true);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AuthWelcomeScreen()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: _buildPageIndicator(),
            ),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  buildPage(
                      onTap: onTap,
                      scale: 1.6,
                      image: 'assets/game.png',
                      title: 'Learn Finance with Fun!!',
                      content: [
                        'Dive into interactive games and real-life scenarios that teach you budgeting, saving, and investing.'
                      ]),
                  buildPage(
                      onTap: onTap,
                      scale: 3.5,
                      image: 'assets/stock.png',
                      title: 'Real-Time Trading Simulations',
                      content: [
                        'Experience the thrill of stock trading with real-time simulations.',
                        'Learn the market dynamics, make informed decisions, and see your virtual portfolio grow.'
                      ]),
                  buildPage(
                      onTap: onTap,
                      scale: 3.5,
                      image: 'assets/bot.png',
                      title: 'Personalized Financial Guidance',
                      content: [
                        'Get personalized investment recommendations based on your goals and risk tolerance.',
                        'Use our financial calculators to compare different investment options and plan your financial future effectively.'
                      ]),
                  buildPage(
                      isLast: true,
                      onTap: onTap,
                      scale: 1.6,
                      image: 'assets/game.png',
                      title: 'Community and Challenges',
                      content: [
                        'Connect with peers, share your financial journey, and participate in community challenges.',
                        'Complete tasks assigned by your NGO and earn virtual currency to invest or spend within the app.'
                      ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
