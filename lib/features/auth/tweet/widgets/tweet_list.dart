import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/auth/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/auth/tweet/widgets/tweet_card.dart';

import '../../../../constants/appwrite_constants.dart';
import '../../../../models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
                data: (data) {
                  if (data.events.contains(
                      'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.create')) {
                    tweets.insert(0, Tweet.fromMap(data.payload));
                  }

                  return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      });
                },
                error: ((error, stackTrace) => ErrorText(
                      error: error.toString(),
                    )),
                loading: () {
                  return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      });
                },
              );
        },
        error: ((error, stackTrace) => ErrorText(
              error: error.toString(),
            )),
        loading: () => const Loader());
  }
}
