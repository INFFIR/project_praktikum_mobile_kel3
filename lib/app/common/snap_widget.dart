import 'package:flutter/material.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/payment/payment_failed_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/payment/payment_pending_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/payment/payment_success_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SnapWidget extends StatefulWidget {
  final String url;
  const SnapWidget({
    super.key,
    required this.url,
  });

  @override
  State<SnapWidget> createState() => _SnapWidgetState();
}

class _SnapWidgetState extends State<SnapWidget> {
  WebViewController? _controller;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          //
        },
        onPageStarted: (String url) {
          if (url.contains('status_code=201&transaction_status=pending')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentPendingPage(),
                ));
          }
          if (url.contains('status_code=202&transaction_status=deny')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentFailedPage(),
                ));
          }
          if (url.contains('status_code=200&transaction_status=settlement')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentSuccessPage(),
                ));
          }
        },
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller!),
    );
  }
}
