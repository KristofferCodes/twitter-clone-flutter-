import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/auth/explore/controller/explore_controller.dart';
import 'package:twitter_clone/theme/pallet.dart';

import '../../widgets/search_tile.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();

  bool showUser = false;

  @override
  Widget build(BuildContext context) {
    final appbarTextFieldBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Pallete.searchBarColor));
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            onSubmitted: (value) {
              setState(() {
                showUser = true;
              });
            },
            controller: searchController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
                fillColor: Pallete.searchBarColor,
                filled: true,
                enabledBorder: appbarTextFieldBorder,
                focusedBorder: appbarTextFieldBorder,
                hintText: 'search twitter'),
          ),
        ),
      ),
      body: showUser
          ? ref.watch(searchUserProvider(searchController.text)).when(
              data: (users) {
                return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = users[index];
                      return SearchTile(userModel: user);
                    });
              },
              error: (error, st) => ErrorText(error: error.toString()),
              loading: () => const Loader())
          : const SizedBox(),
    );
  }
}
