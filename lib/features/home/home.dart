import 'package:flutter/material.dart';
import 'package:test_tg/features/tma_modal/domain/constants/urls.dart';
import 'package:test_tg/features/tma_modal/presentation/tma_modal_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _showCustomModal() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Modal',
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, anim1, anim2) {
        return TmaModalPage (url: Urls.mainUrl);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showCustomModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, 
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16), 
                textStyle: const TextStyle(fontSize: 20), 
                shape: RoundedRectangleBorder( 
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Tap on me', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
   
    );
  }
}