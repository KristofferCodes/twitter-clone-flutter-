import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/auth/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/auth/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/auth/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/auth/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/theme/pallet.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../common/error_page.dart';
import '../../../../common/loading_page.dart';
import '../../../../models/tweet_model.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
            data: (user) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 35,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Retweeted
                            if (tweet.retweetedBy.isNotEmpty)
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsConstants.retweetIcon,
                                    color: Pallete.greyColor,
                                    height: 20,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${tweet.retweetedBy} Retweeted',
                                    style: const TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    user.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19),
                                  ),
                                ),
                                Text(
                                  '@${user.name} . ${timeago.format(
                                    tweet.tweetedAt,
                                    locale: 'en_short',
                                  )}',
                                  style: const TextStyle(
                                      color: Pallete.greyColor, fontSize: 17),
                                ),
                              ],
                            ),
                            //Replied to
                            HashtagText(text: tweet.text),
                            if (tweet.tweetType == TweetType.image)
                              CarouselImage(imageLinks: tweet.imageLinks),
                            if (tweet.link.isNotEmpty) ...[
                              const SizedBox(
                                height: 4,
                              ),
                              AnyLinkPreview(
                                  borderRadius: 25,
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: 'https://${tweet.link}'),
                            ],
                            Container(
                              margin: const EdgeInsets.only(top: 20, right: 20),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TweetIconButton(
                                      onTap: () {},
                                      text: (tweet.commentIds.length +
                                              tweet.reshareCount +
                                              tweet.likes.length)
                                          .toString(),
                                      pathName: AssetsConstants.viewsIcon,
                                    ),
                                    TweetIconButton(
                                      onTap: () {},
                                      text:
                                          (tweet.commentIds.length).toString(),
                                      pathName: AssetsConstants.commentIcon,
                                    ),
                                    TweetIconButton(
                                      onTap: () {
                                        ref
                                            .read(tweetControllerProvider
                                                .notifier)
                                            .reshareTweet(
                                                tweet, currentUser, context);
                                      },
                                      text: (tweet.reshareCount).toString(),
                                      pathName: AssetsConstants.retweetIcon,
                                    ),
                                    LikeButton(
                                      onTap: (isLiked) async {
                                        ref
                                            .read(tweetControllerProvider
                                                .notifier)
                                            .likeTweet(tweet, currentUser);
                                        return !isLiked;
                                      },
                                      isLiked:
                                          tweet.likes.contains(currentUser.uid),
                                      size: 25,
                                      likeBuilder: ((isLiked) {
                                        return isLiked
                                            ? SvgPicture.asset(
                                                AssetsConstants.likeFilledIcon,
                                                color: Pallete.redColor,
                                              )
                                            : SvgPicture.asset(
                                                AssetsConstants
                                                    .likeOutlinedIcon,
                                                color: Pallete.greyColor,
                                              );
                                      }),
                                      likeCount: tweet.likes.length,
                                      countBuilder: (likeCount, isLiked, text) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2.0),
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                                color: isLiked
                                                    ? Pallete.redColor
                                                    : Pallete.greyColor,
                                                fontSize: 16),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.share_outlined,
                                          size: 20,
                                          color: Pallete.greyColor,
                                        )),
                                  ]),
                            ),
                            const SizedBox(height: 1),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(color: Pallete.greyColor),
                ],
              );
            },
            error: ((error, stackTrace) => ErrorText(
                  error: error.toString(),
                )),
            loading: () => const Loader());
  }
}
