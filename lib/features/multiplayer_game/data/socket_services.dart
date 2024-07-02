import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stocksapp/constants.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/home/presentation/pages/homeScreen.dart';
import '../domain/socket_provider.dart';
import '../presentation/pages/gaming_page.dart';

class SocketService {
  late IO.Socket socket;

  void connect({required BuildContext context}) {
    socket = IO.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    SocketProvider _socketProvider =
        Provider.of<SocketProvider>(context, listen: false);
    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket.io server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket.io server');
    });

    socket.on('join', (data) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
      _socketProvider.updateMessage(isGameBegin: data['game_begin'] ?? false);
      _socketProvider.isWaiting(isWaiting: !data['game_begin']);
      if (data['game_begin']) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TransactionScreen();
        }));
      }
    });

    socket.on('message', (data) {
      try {
        print(data);
        _socketProvider.updateMessage(isGameBegin: data['game_begin'] ?? false);
      } catch (err) {
        print('errorrr' + err.toString());
      }
    });

    socket.on('game_start', (data) {
      print('Game Start: $data');
    });

    socket.on('game_over', (data) {
      print(data['winner']);
      print(data['max_points']);
      if (!data['game_begin']) {
        _socketProvider.updateMessage(isGameBegin: data['game_begin']);
        //leaveGame(username: FirebaseAuth.instance.currentUser!.email!);
        _socketProvider.deleteTransactions();
        //socket.dispose();
        disconnect();
        onBasicAlertPressed(context, data['message']);
      }
    });

    // //getStockValue();
    socket.on('get_stock', (data) {
      print(data);
      _socketProvider.updateCurrentPrice(newPrice: data['currentPrice']);
    });

    socket.on('score', (data) {
      try {
        SocketUser user = SocketUser.fromMap(data);
        _socketProvider.updateDetails(user: user, message: data['message']);
        print('Score Update: ${user.username} has profit: ${user.profit}');
      } catch (e) {
        print('Error parsing score data: $e');
      }
    });
  }

  void joinGame({required String username}) {
    socket.emit('join', {'username': username});
  }

  void leaveGame({required String username}) {
    socket.emit('leave', {'username': username});
  }

  void addPoints(
      {required String username,
      required double points,
      required bool isBought,
      required String stockName}) {
    socket.emit('score',
        {'username': username, 'points': points, "stockName": stockName});
  }

  void disconnect() {
    leaveGame(username: FirebaseAuth.instance.currentUser!.email!);

    socket.dispose();
  }
}

onBasicAlertPressed(context, message) {
  // Future.delayed(Duration(seconds: 5), () {
  //   Navigator.of(context).pop();
  //   Navigator.of(context).pop(); // Close the dialog
  // });
  Alert(
      onWillPopActive: true,
      closeFunction: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ShowCaseWidget(builder: (context) {
                      return HomeScreen();
                    })),
            (route) => false);
      },
      style: AlertStyle(
          backgroundColor: Colors.white, overlayColor: Colors.black12),
      context: context,
      content: Column(
        children: [
          Image.asset(
            'assets/winner.png',
            width: 190,
            height: 190,
          ),
          Text(message,
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 22))
        ],
      ),
      buttons: [
        DialogButton(
            color: Color(0xffa9dbca),
            child: Text(
              'Okay!!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowCaseWidget(builder: (context) {
                            return HomeScreen();
                          })),
                  (route) => false);
            })
      ]).show();
}
