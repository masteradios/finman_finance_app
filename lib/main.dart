import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';
import 'package:stocksapp/features/community/domain/communityProvider.dart';
import 'package:stocksapp/features/expensetracker/domain/expenseprovider.dart';
import 'package:stocksapp/features/learning/manager/learningProvider.dart';
import 'package:stocksapp/features/learning/presentation/pages/learningpage.dart';
import 'package:stocksapp/features/multiplayer_game/domain/socket_provider.dart';
import 'package:stocksapp/features/trade/domain/tradeprovider.dart';
import 'package:stocksapp/features/welcome/presentation/pages/splashScreen.dart';

import 'features/multiplayer_game/presentation/pages/game_graph_page.dart';
import 'features/welcome/domain/getSharedPrefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      //     apiKey: "AIzaSyDLx3D4eweAg5TIyiPmvOkpTv0TZmTi8a8",
      //     authDomain: "stocksample-f2836.firebaseapp.com",
      //     projectId: "stocksample-f2836",
      //     storageBucket: "stocksample-f2836.appspot.com",
      //     messagingSenderId: "127791928551",
      //     appId: "1:127791928551:web:08f6e78c7152741d963e42",
      //     measurementId: "G-BDMVK7NZ7K"),
      );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServiceProvider()),
        ChangeNotifierProvider(create: (_) => WelcomeProvider()),
        ChangeNotifierProvider(create: (_) => LearningProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => TradeProvider()),
        ChangeNotifierProvider(create: (_) => SocketProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Onboarding App',
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffa9dbca),
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
