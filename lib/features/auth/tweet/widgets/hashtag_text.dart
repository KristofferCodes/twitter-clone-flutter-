import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallet.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpans.add(TextSpan(
          text: '$element  ',
          style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ));
      } else if (element.startsWith('www.')) {
        textSpans.add(TextSpan(
          text: '$element  ',
          style: const TextStyle(color: Pallete.blueColor, fontSize: 16),
        ));
      } else {
        textSpans.add(TextSpan(
          text: '${element} ',
          style: const TextStyle(
            fontSize: 16,
          ),
        ));
      }
    });

    return RichText(text: TextSpan(children: textSpans));
  }
}
