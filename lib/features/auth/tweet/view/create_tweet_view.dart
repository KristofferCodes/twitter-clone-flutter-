import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/theme/pallet.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetScreen());
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tweetTextController.dispose();
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          RoundedSmallButton(
              onTap: () {},
              label: 'Tweet',
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor)
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Pallete.blueColor,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: tweetTextController,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                    decoration: const InputDecoration(
                        hintText: "what's happening?",
                        hintStyle: TextStyle(
                            color: Pallete.greyColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                        border: InputBorder.none),
                    maxLines: null,
                  ),
                )
              ],
            ),
            if (images.isNotEmpty)
              CarouselSlider(
                  items: images.map((file) {
                    return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: Image.file(file));
                  }).toList(),
                  options: CarouselOptions(
                    height: 400,
                    enableInfiniteScroll: false,
                  ))
          ],
        ),
      )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
          color: Pallete.greyColor,
          width: 0.3,
        ))),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
            child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
            child: SvgPicture.asset(AssetsConstants.gifIcon),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
            child: SvgPicture.asset(AssetsConstants.emojiIcon),
          ),
        ]),
      ),
    );
  }
}