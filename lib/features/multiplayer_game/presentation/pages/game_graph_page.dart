import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/constants.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';
import 'package:stocksapp/features/multiplayer_game/data/socket_services.dart';
import 'package:stocksapp/features/multiplayer_game/domain/socket_provider.dart';
import 'package:stocksapp/features/trade/data/source/getData.dart';
import 'package:stocksapp/features/trade/domain/tradeprovider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../trade/data/models/stock.dart';

class GameGraphPage extends StatefulWidget {
  const GameGraphPage({super.key});

  @override
  State<GameGraphPage> createState() => _GameGraphPageState();
}

class _GameGraphPageState extends State<GameGraphPage> {
  List<StockData> _stocks = [];
  bool _isLoading = false;
  SocketService _socketService = SocketService();
  IO.Socket socket = IO.io(host, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });
  @override
  void initState() {
    // TODO: implement initState
    getData();
    //_socketService.connect(context: context);
    // socket = IO.io(host, <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': true,
    // });
    socket.connect();

    super.initState();
  }

  void addPoints(
      {required String username,
      required double points,
      required bool isBought,
      required String stockName}) {
    socket.emit('score', {
      'username': username,
      'points': points,
      "stockName": stockName,
      "isBought": isBought
    });
  }

  void sendMessage({required bool isBought}) {
    addPoints(
      username: FirebaseAuth.instance.currentUser!.email!,
      stockName: stockImages[Provider.of<TradeProvider>(context, listen: false)
              .currentStockIndex]
          .name,
      points: Provider.of<SocketProvider>(context, listen: false).currentPrice,
      isBought: isBought,
    );
  }

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    _stocks = await TradeService().getStockData(
        stockName: stockImages[0].name, period: '5d', context: context);
    setState(() {
      _isLoading = false;
    });
  }

  void _buyItem(
      {required double buyingPrice, required double userMoney}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"myMoney": userMoney - buyingPrice});
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Provider.of<AuthServiceProvider>(context, listen: false)
        .updateUserDetails(UserModel.fromJson(snapshot));
  }

  void _sellItem(
      {required double sellingPrice, required double userMoney}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"myMoney": userMoney + sellingPrice});
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Provider.of<AuthServiceProvider>(context, listen: false)
        .updateUserDetails(UserModel.fromJson(snapshot));
  }

  void closeItem({
    required MyPortFolioItem item,
    required double currentPrice,
    required UserModel user,
  }) async {
    if (item.isBuying) {
      double profit = currentPrice - item.buyingPrice!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"myMoney": user.myMoney + profit + item.buyingPrice!});
      socket.emit('close', [
        {'userName': user.email, 'profit': profit}
      ]);
    } else {
      double profit = item.sellingPrice! - currentPrice;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"myMoney": user.myMoney + profit + item.sellingPrice!});
      socket.emit('close', [
        {'userName': user.email, 'profit': profit}
      ]);
    }

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Provider.of<AuthServiceProvider>(context, listen: false)
        .updateUserDetails(UserModel.fromJson(snapshot));
  }

  @override
  Widget build(BuildContext context) {
    TradeProvider tradeProvider = Provider.of<TradeProvider>(context);
    SocketProvider _socketProvider = Provider.of<SocketProvider>(context);
    UserModel userModel = Provider.of<AuthServiceProvider>(context).userModel;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          tradeProvider.updateCurrentStock(newVal: index);
                          tradeProvider.updatePeriod(period: '5d');
                          MyPortFolioItem currentItem = MyPortFolioItem(
                              stockName:
                                  stockImages[tradeProvider.currentStockIndex]
                                      .name,
                              isBuying: true);
                          _socketProvider.ItemPresent(item: currentItem);
                          tradeProvider.getStocksData(
                              stockName: stockImages[index].name,
                              context: context);
                          setState(() {
                            _stocks = [];
                          });
                        },
                        child: buildStockIcon(
                            stockImage: stockImages[index].stockImage,
                            isSelected:
                                tradeProvider.currentStockIndex == index),
                      );
                    },
                    itemCount: stockImages.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                  child: Text(
                    stockImages[tradeProvider.currentStockIndex].name +
                        ' ' +
                        _socketProvider.currentPrice.toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                )
              ],
            ),
          ),
          (_stocks.isNotEmpty)
              ? Expanded(child: buildGraph(stocks: _stocks))
              : (tradeProvider.isLoading)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
                  : Expanded(child: buildGraph(stocks: tradeProvider.stocks)),
          (_socketProvider.isItemPresent)
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      //PortfolioItem portfolioItem=PortfolioItem(stock: stock!, quantity: 1);

                      //_buyItem(user, widget.stockData);
                      //setState(() {});
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text(
                      //         'Bought ${stockImages[tradeProvider.currentStockIndex].name}')));
                      MyPortFolioItem? item =
                          _socketProvider.getCurrentPortFolioItem(
                              stockName:
                                  stockImages[tradeProvider.currentStockIndex]
                                      .name);
                      closeItem(
                          item: item!,
                          currentPrice: _socketProvider.currentPrice,
                          user: userModel);
                      _socketProvider.removeCurrentPortfolioItem(
                          stockName: item.stockName);
                      _socketProvider.ItemPresent(item: item);
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      height: 70,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        onPressed: () {
                          //PortfolioItem portfolioItem=PortfolioItem(stock: stock!, quantity: 1);

                          //_buyItem(user, widget.stockData);
                          //setState(() {});
                          _socketProvider.addToMyPortFolio(
                              portFolioItem: MyPortFolioItem(
                                  stockName: stockImages[
                                          tradeProvider.currentStockIndex]
                                      .name,
                                  buyingPrice: _socketProvider.currentPrice,
                                  isBuying: false));
                          _socketProvider.ItemPresent(
                              item: MyPortFolioItem(
                                  stockName: stockImages[
                                          tradeProvider.currentStockIndex]
                                      .name,
                                  isBuying: false));
                          _sellItem(
                              sellingPrice: _socketProvider.currentPrice,
                              userMoney: userModel.myMoney);
                          sendMessage(isBought: false);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Sold ${stockImages[tradeProvider.currentStockIndex].name}')));
                        },
                        child: Text(
                          'Sell',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      height: 70,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        onPressed: (userModel.myMoney <
                                _socketProvider.currentPrice)
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 25, horizontal: 10),
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8))),
                                    content: Text(
                                      'Insufficient funds!!',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                );
                              }
                            : () {
                                _socketProvider.addToMyPortFolio(
                                    portFolioItem: MyPortFolioItem(
                                        stockName: stockImages[
                                                tradeProvider.currentStockIndex]
                                            .name,
                                        buyingPrice:
                                            _socketProvider.currentPrice,
                                        isBuying: true));
                                _socketProvider.ItemPresent(
                                    item: MyPortFolioItem(
                                        stockName: stockImages[
                                                tradeProvider.currentStockIndex]
                                            .name,
                                        isBuying: true));
                                _buyItem(
                                    buyingPrice: _socketProvider.currentPrice,
                                    userMoney: userModel.myMoney);
                                sendMessage(isBought: true);

                                // _closeItem(user, portfolioItem);
                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //     content: Text(portfolioItem.profit.toString())));
                              },
                        child: Text(
                          'Buy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

Widget buildGraph({required List<StockData> stocks}) {
  return Container(
    //margin: EdgeInsets.only(right: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildLegend(),
        SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
              enableDoubleTapZooming: true,
              //enableSelectionZooming: true
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            plotAreaBorderWidth: 0,
            tooltipBehavior: TooltipBehavior(
              enable: false,
            ),
            borderWidth: 0,
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipSettings: InteractiveTooltip(
                enable: true,
                format: '₹ point.y',
              ),
            ),
            primaryXAxis: DateTimeAxis(
              isVisible: false,
              dateFormat: DateFormat.d(),
              maximumLabels: 3,
              majorGridLines: MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              isVisible: false,
              majorGridLines: MajorGridLines(width: 0),
            ),
            series: <CartesianSeries<StockData, DateTime>>[
              LineSeries(
                color: Colors.green,
                enableTooltip: true,
                animationDuration: 600,
                xValueMapper: (StockData data, _) => data.dateTime,
                dataSource: stocks,
                yValueMapper: (StockData data, _) => data.high,
              ),
              LineSeries(
                color: Colors.blue,
                enableTooltip: true,
                animationDuration: 600,
                xValueMapper: (StockData data, _) => data.dateTime,
                dataSource: stocks,
                yValueMapper: (StockData data, _) => data.open,
              ),
              LineSeries(
                color: Colors.red,
                enableTooltip: true,
                animationDuration: 600,
                xValueMapper: (StockData data, _) => data.dateTime,
                dataSource: stocks,
                yValueMapper: (StockData data, _) => data.close,
              ),
              LineSeries(
                color: Colors.orange,
                enableTooltip: true,
                animationDuration: 600,
                xValueMapper: (StockData data, _) => data.dateTime,
                dataSource: stocks,
                yValueMapper: (StockData data, _) => data.low,
              )
            ]),
      ],
    ),
  );
}

Widget buildStockIcon({required String stockImage, required bool isSelected}) {
  return Container(
    height: 60,
    width: 60,
    margin: EdgeInsets.only(left: 10, right: 10),
    decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          width: (isSelected) ? 3 : 1,
          color: (isSelected) ? Colors.green : Colors.black,
        ),
        image: DecorationImage(
            image: NetworkImage(
          stockImage,
        ))),
  );
}

class BuildLegend extends StatelessWidget {
  const BuildLegend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 120,
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildLegendTile(
              color: Colors.redAccent,
              name: 'Close',
            ),
            BuildLegendTile(
              color: Colors.blue,
              name: 'Open',
            ),
            BuildLegendTile(
              color: Colors.green,
              name: 'High',
            ),
            BuildLegendTile(
              color: Colors.orange,
              name: 'Low',
            ),
          ],
        ));
  }
}

class BuildLegendTile extends StatelessWidget {
  final Color color;
  final String name;
  const BuildLegendTile({super.key, required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: color,
          size: 10,
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          name,
          style: GoogleFonts.poppins(),
        )
      ],
    );
  }
}
