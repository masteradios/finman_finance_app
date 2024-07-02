import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';
import 'package:stocksapp/features/multiplayer_game/data/socket_services.dart';
import 'package:stocksapp/features/multiplayer_game/domain/socket_provider.dart';
import 'package:stocksapp/features/multiplayer_game/presentation/pages/game_graph_page.dart';
import 'package:stocksapp/features/multiplayer_game/presentation/pages/waitingScreen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stocksapp/features/trade/domain/tradeprovider.dart';
import '../../../../constants.dart';
import 'joinScreen.dart';

class GamingPage extends StatefulWidget {
  const GamingPage({super.key});

  @override
  State<GamingPage> createState() => _GamingPageState();
}

class _GamingPageState extends State<GamingPage> {
  final SocketService _socketService = SocketService();
  IO.Socket socket = IO.io(host, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  String _message = '';
  double _profit = 0.0;
  String _username = '';
  bool _waiting = false;
  String _winner = '';

  @override
  void initState() {
    super.initState();
    socket.connect();

    //_socketService.connect(context: context);
    socket.on('join', (data) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          content: Text(
            data['message'],
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
        ),
      );
      // _socketProvider.updateMessage(isGameBegin: data['game_begin'] ?? false);
      //_socketProvider.isWaiting(isWaiting: !data['game_begin']);
      if (data['game_begin']) {
        // socket.emit('get_stock', [
        //   {"stockName": "INFY"}
        // ]);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TransactionScreen();
        }));
      }
    });

    socket.on('message', (data) {
      try {
        print(data);
        //_socketProvider.updateMessage(isGameBegin: data['game_begin'] ?? false);
      } catch (err) {
        print('errorrr' + err.toString());
      }
    });
  }

  void _leaveGame(String username) {
    _socketService.leaveGame(username: username);
  }

  void _addPoints(double points) {
    //_socketService.addPoints(
    //  username: FirebaseAuth.instance.currentUser!.email!, points: points);
  }

  void onTapJoin() {
    socket
        .emit('join', {'username': FirebaseAuth.instance.currentUser!.email!});
    // _socketService.joinGame(
    //     username: FirebaseAuth.instance.currentUser!.email!);
    setState(() {
      _waiting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SocketProvider _socketProvider = Provider.of<SocketProvider>(context);
    return Scaffold(
      body: (_waiting)
          ? BuildWaitingScreen()
          : BuildJoinScreen(
              callback: onTapJoin,
            ),
    );
  }
}

Widget ShowTimer() {
  return TimerCountdown(
    timeTextStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 22),
    colonsTextStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 22),
    enableDescriptions: false,
    format: CountDownTimerFormat.minutesSeconds,
    endTime: DateTime.now().add(
      Duration(
        minutes: 5,
        seconds: 00,
      ),
    ),
    onEnd: () {
      print("Timer finished");
    },
  );
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  final SocketService _socketService = SocketService();
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    _socketService.connect(context: context);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void sendMessage() {
    _socketService.addPoints(
      username: FirebaseAuth.instance.currentUser!.email!,
      stockName: stockImages[Provider.of<TradeProvider>(context, listen: false)
              .currentStockIndex]
          .name,
      points: Provider.of<SocketProvider>(context, listen: false).currentPrice,
      isBought: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: ShowTimer(),
          ),
          // floatingActionButton: FloatingActionButton(
          //   child: Text('Find Score'),
          //   onPressed: () {
          //     //sendMessage();
          //   },
          // ),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.green,
                      labelStyle: GoogleFonts.poppins(fontSize: 16),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.green,
                      tabs: [Text('Activity'), Text('Data')],
                      controller: _tabController,
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                BuildTransactionList(),
                GameGraphPage(),
              ],
            ),
          ),
        ));
  }
}

// Custom SliverPersistentHeaderDelegate for TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class BuildTransactionList extends StatefulWidget {
  const BuildTransactionList({super.key});

  @override
  State<BuildTransactionList> createState() => _BuildTransactionListState();
}

class _BuildTransactionListState extends State<BuildTransactionList> {
  @override
  Widget build(BuildContext context) {
    AuthServiceProvider authProvider =
        Provider.of<AuthServiceProvider>(context);
    SocketProvider _socketProvider = Provider.of<SocketProvider>(context);
    return (_socketProvider.socketUsers.isEmpty)
        ? Center(
            child: Text('Start to kar'),
          )
        : Column(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    authProvider.userModel.myMoney.toString(),
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 22),
                  )),
              Expanded(
                child: ListView.builder(
                    controller: _socketProvider.controller,
                    shrinkWrap: true,
                    itemCount: _socketProvider.socketUsers.length,
                    itemBuilder: (context, index) {
                      bool isCurrentUser =
                          _socketProvider.socketUsers[index].username ==
                              authProvider.userModel.email;
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 6.0, bottom: 6, left: 5, right: 5),
                        child: (!isCurrentUser)
                            ? Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  tileColor: (isCurrentUser)
                                      ? Colors.green
                                      : Colors.redAccent,

                                  title: Text(
                                    _socketProvider.socketMessages[index],
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  // title: Text(
                                  //   _socketProvider.socketUsers[index].username,
                                  //   style: GoogleFonts.poppins(
                                  //       color: Colors.white,
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w700),
                                  // ),
                                  // trailing: Text(
                                  //   _socketProvider.socketUsers[index].profit
                                  //       .toString(),
                                  //   style: GoogleFonts.poppins(
                                  //       color: Colors.white,
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w700),
                                  // ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  tileColor: (isCurrentUser)
                                      ? Colors.green
                                      : Colors.redAccent,
                                  title: Text(
                                    _socketProvider.socketMessages[index],
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),

                                  // title: Text(
                                  //   _socketProvider.socketUsers[index].username,
                                  //   style: GoogleFonts.poppins(
                                  //       color: Colors.white,
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w700),
                                  // ),
                                  // trailing: Text(
                                  //   _socketProvider.socketUsers[index].profit
                                  //       .toString(),
                                  //   style: GoogleFonts.poppins(
                                  //       color: Colors.white,
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w700),
                                  // ),
                                ),
                              ),
                      );
                    }),
              ),
            ],
          );
  }
}
