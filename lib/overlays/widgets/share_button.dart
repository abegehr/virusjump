import 'package:flutter/material.dart';
import 'package:share/share.dart';

Future<void> share() => Share.share(
    'Check out this cool game: https://virusjump.page.link/download and stay at home!');

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: share,
          child: Image.asset(
            'assets/images/ui/share_button.png',
            width: 165,
            height: 50,
          ),
        ),
      ),
    );
  }
}
