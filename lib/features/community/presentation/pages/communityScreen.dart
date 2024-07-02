import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/community/data/newsCategory.dart';
import 'package:stocksapp/features/community/data/source/getData.dart';
import 'package:stocksapp/features/community/domain/communityProvider.dart';

import '../../data/model/newsmodel.dart';
import 'newsDetailsScreen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late TabController _tabController;
  List<NewsModel> _news = [];
  @override
  void initState() {
    // TODO: implement initState
    //
    getData();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    _news =
        await NewService().getRssData(url: newsCategories[0], context: context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    CommunityProvider communityProvider =
        Provider.of<CommunityProvider>(context);
    List<NewsModel> news =
        (communityProvider.news != null) ? communityProvider.news! : [];
    return Scaffold(
      body: Column(
        children: [
          TabBar(
              onTap: (newVal) {
                communityProvider.updateCurrentCategory(newValue: newVal);
                communityProvider.getRssFeed(context: context);
                setState(() {
                  _news = [];
                });
              },
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
              unselectedLabelStyle: GoogleFonts.poppins(),
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              tabs: [
                Text(
                  'For You',
                ),
                Text('Companies'),
                Text('Market')
              ]),
          (_news.isNotEmpty)
              ? (_isLoading)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Expanded(child: BuildNewsFeed(news: _news))
              : (communityProvider.isLoading)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Expanded(
                      child: BuildNewsFeed(news: news),
                    ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Color(0xffa9dbca),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      extendBody: true,
    );
  }
}

class BuildNewsFeed extends StatelessWidget {
  const BuildNewsFeed({
    super.key,
    required this.news,
  });

  final List<NewsModel> news;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  news[index].title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  'Published : ' + news[index].published_time,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  news[index].summary,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewsDetailsScreen(news: news[index]);
                  }));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Read More',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: news.length,
    );
  }
}
