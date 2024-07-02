import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';
import 'package:stocksapp/features/community/presentation/pages/communityScreen.dart';
import 'package:stocksapp/features/trade/presentation/pages/stockScreen.dart';

import '../../../expensetracker/domain/expenseprovider.dart';
import '../widgets/buildHomeTile.dart';
import '../../../expensetracker/presentation/pages/expensetrackerScreen.dart';
import '../../../learning/presentation/pages/learningpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey moneyKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    startShowCase();
    super.initState();
  }

  startShowCase() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('money_tutorial_done') == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await prefs.setBool('money_tutorial_done', true);
        ShowCaseWidget.of(context).startShowCase([moneyKey]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<AuthServiceProvider>(context).userModel;
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            child: Showcase(
              descriptionAlignment: TextAlign.center,
              descTextStyle: GoogleFonts.poppins(color: Colors.black),
              key: moneyKey,
              description:
                  'Your Virtual Money. Complete learnings, upload expenses or contribute to community to gain currency',
              child: Text(
                'Rs. ' + user.myMoney.toString(),
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildHomeTile(
                  icon: Icons.menu_book_rounded,
                  title: 'Learn',
                  callback: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LearningPage(
                                  user: user,
                                )));
                  }),
              buildHomeTile(
                  icon: Icons.monetization_on,
                  title: 'Trade',
                  callback: () {
                    ShowCaseWidget(
                      builder: (context) => StockScreen(),
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowCaseWidget(
                                  builder: (context) => StockScreen(),
                                )));
                  }),
              buildHomeTile(
                  icon: Icons.account_tree_sharp,
                  title: 'Expenses',
                  callback: () {
                    Provider.of<ExpenseProvider>(context, listen: false)
                        .getAggregateExpenses();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowCaseWidget(
                            builder: (context) => ExpenseTrackerScreen(),
                          ),
                        ));
                  }),
              buildHomeTile(
                  icon: Icons.people_outline_outlined,
                  title: 'Community',
                  callback: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityScreen()));
                  }),
            ],
          ),
        ],
      ),
    ));
  }
}
