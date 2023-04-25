import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/auth/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/auth/tweet/widgets/tweet_card.dart';

import '../../../common/error_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/tweet_model.dart';

class TwitterReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) =>
      MaterialPageRoute(builder: (context) => TwitterReplyScreen(tweet: tweet));
  final Tweet tweet;
  const TwitterReplyScreen({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweets'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
              data: (tweets) {
                return ref.watch(getLatestTweetProvider).when(
                      data: (data) {
                        final lastestTweet = Tweet.fromMap(data.payload);

                        bool isTweetAlreadyPresent = false;
                        for (final tweetModel in tweets) {
                          if (tweetModel.id == lastestTweet.id) {
                            isTweetAlreadyPresent = true;
                            break;
                          }
                        }
                        if (!isTweetAlreadyPresent &&
                            lastestTweet.repliedTo == tweet.id) {
                          if (data.events.contains(
                              'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.create')) {
                            tweets.insert(0, Tweet.fromMap(data.payload));
                          } else if (data.events.contains(
                              'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.update')) {
                            // get id of current tweet
                            // var tweet = Tweet.fromMap(data.payload);
                            // final tweetId = tweet.id;

                            final startingPoint =
                                data.events[0].lastIndexOf('documents.');
                            final endPoint =
                                data.events[0].lastIndexOf('.update');
                            final tweetId = data.events[0]
                                .substring(startingPoint + 10, endPoint);

                            var tweet = tweets
                                .where((element) => element.id == tweetId)
                                .first;

                            final tweetIndex = tweets.indexOf(tweet);
                            tweets.removeWhere(
                                (element) => element.id == tweetId);

                            tweet = Tweet.fromMap(data.payload);
                            tweets.insert(tweetIndex, tweet);
                          }
                        }

                        return Expanded(
                          child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              }),
                        );
                      },
                      error: ((error, stackTrace) => ErrorText(
                            error: error.toString(),
                          )),
                      loading: () {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              }),
                        );
                      },
                    );
              },
              error: ((error, stackTrace) => ErrorText(
                    error: error.toString(),
                  )),
              loading: () => const Loader())
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: TextField(
          onSubmitted: (value) {
            ref.read(tweetControllerProvider.notifier).shareTweet(
                images: [], text: value, context: context, repliedTo: tweet.id);
          },
          decoration: const InputDecoration(
            hintText: 'Tweet your reply',
          ),
        ),
      ),
    );
  }
}
