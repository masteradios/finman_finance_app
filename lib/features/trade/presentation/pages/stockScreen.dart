import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stocksapp/constants.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';
import 'package:stocksapp/features/multiplayer_game/presentation/pages/gaming_page.dart';
import 'package:stocksapp/features/trade/data/source/getData.dart';
import 'package:stocksapp/features/trade/domain/tradeprovider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/models/stock.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  bool _isLoading = false;
  List<StockData> _stocks = [];
  GlobalKey gameKey = GlobalKey();

  GlobalKey stockKey = GlobalKey();
  @override
  void initState() {
    getFirstData();
    startShowCase();
    super.initState();
  }

  void getFirstData() async {
    setState(() {
      _isLoading = true;
    });
    _stocks = await TradeService().getStockData(
        stockName: stockImages[0].name, context: context, period: '3mo');
    setState(() {
      _isLoading = false;
    });
  }

  startShowCase() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('tutorial_done') == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await prefs.setBool('tutorial_done', true);
        ShowCaseWidget.of(context).startShowCase([gameKey, stockKey]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TradeProvider tradeProvider = Provider.of<TradeProvider>(context);
    AuthServiceProvider _authProvider =
        Provider.of<AuthServiceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Rs. ' + _authProvider.userModel.myMoney.toString(),
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xffa9dbca),
      ),
      backgroundColor: Colors.white,
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  height: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        child: Row(
                          children: [
                            Showcase(
                              key: gameKey,
                              description: 'You can challenge other players',
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GamingPage()));
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  child: Icon(
                                    MdiIcons.swordCross,
                                    color: Color(0xffffa700),
                                    size: 30,
                                  ),
                                  radius: 28,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 2,
                              color: Colors.grey,
                              height: 40,
                            ),
                            Expanded(
                              child: Showcase(
                                key: stockKey,
                                description: 'Press the icon to see the stats',
                                child: ListView.builder(
                                    itemCount: stockImages.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          tradeProvider.updateCurrentStock(
                                              newVal: index);
                                          tradeProvider.getStocksData(
                                              stockName:
                                                  stockImages[index].name,
                                              context: context);

                                          setState(() {
                                            _stocks = [];
                                          });
                                        },
                                        child: buildStockIcon(
                                            stockImage:
                                                stockImages[index].stockImage,
                                            isSelected: tradeProvider
                                                    .currentStockIndex ==
                                                index),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          stockImages[tradeProvider.currentStockIndex].name,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ),
                (_stocks.isNotEmpty)
                    ? buildGraph(stocks: _stocks)
                    : (tradeProvider.isLoading)
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          )
                        : buildGraph(stocks: tradeProvider.stocks),
              ],
            ),
    );
  }
}

class BuildFlChart extends StatelessWidget {
  const BuildFlChart({
    super.key,
    required this.tradeProvider,
  });

  final TradeProvider tradeProvider;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.white,
        lineBarsData: [
          LineChartBarData(
            spots: tradeProvider.stocks
                .map((stock) => FlSpot(
                    stock.dateTime.millisecondsSinceEpoch.toDouble(),
                    stock.open))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: tradeProvider.stocks
                .map((stock) => FlSpot(
                    stock.dateTime.millisecondsSinceEpoch.toDouble(),
                    stock.close))
                .toList(),
            isCurved: true,
            color: Colors.red,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: tradeProvider.stocks
                .map((stock) => FlSpot(
                    stock.dateTime.millisecondsSinceEpoch.toDouble(),
                    stock.high))
                .toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: tradeProvider.stocks
                .map((stock) => FlSpot(
                    stock.dateTime.millisecondsSinceEpoch.toDouble(),
                    stock.low))
                .toList(),
            isCurved: true,
            color: Colors.orange,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (value, meta) {
                // Show titles only for specific intervals
                final DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());
                final String formattedDate = DateFormat('MMM').format(date);

                return SideTitleWidget(
                  fitInside: SideTitleFitInsideData(
                      enabled: true,
                      axisPosition: meta.axisPosition,
                      parentAxisSize: 10,
                      distanceFromEdge: 2),
                  axisSide: meta.axisSide,
                  space: 10.0,
                  child: Text(formattedDate, style: TextStyle(fontSize: 12)),
                );
              },
              reservedSize: 40,
            ),
          ),
          rightTitles: AxisTitles(
              drawBelowEverything: false,
              sideTitles: SideTitles(
                //interval: 0.1,
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  var style = GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Colors.black);
                  return SideTitleWidget(
                    angle: -0.5,
                    fitInside: SideTitleFitInsideData(
                        enabled: true,
                        axisPosition: 15,
                        parentAxisSize: 14,
                        distanceFromEdge: 10),
                    axisSide: meta.axisSide,
                    space: 10,
                    child: Text(value.toStringAsFixed(2), style: style),
                  );
                },
              )),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData:
            FlBorderData(show: false, border: Border.all(color: Colors.grey)),
        gridData: FlGridData(show: false),
      ),
    );
  }
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
                format: '₹ point.y\npoint.x',
              ),
            ),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMM(),
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
