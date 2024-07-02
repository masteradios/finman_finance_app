import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../data/model/newsmodel.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({
    super.key,
    required this.news,
  });

  final NewsModel news;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  late WebViewController _controller;
  @override
  void initState() {
    // TODO: implement initState

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.news.link));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
