import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PersistentWebView extends StatefulWidget {
  final WebViewController controller;

  const PersistentWebView({super.key, required this.controller});

  @override
  State<PersistentWebView> createState() => _PersistentWebViewState();
}

class _PersistentWebViewState extends State<PersistentWebView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) => setState(() => _isLoading = true),
        onPageFinished: (_) => setState(() => _isLoading = false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: widget.controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
      ],
    );
  }
}
