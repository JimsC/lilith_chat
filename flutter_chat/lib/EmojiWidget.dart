import 'package:flutter/material.dart';

import 'GlobalUtils.dart';
import 'ChatMessageState.dart';

class NormalEmojiWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: ChatEmojiState.emojis
          .map((e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: e
                    .map((str) => Container(
                          height: GlobalUtils.fitSize(48),
                          width: GlobalUtils.fitSize(48),
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                          child: GestureDetector(
                            onTap: () =>
                                {ChatViewState.instance.onInputEmoji(str)},
                            child: Text(
                              str,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: GlobalUtils.fitSize(40),
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}

class BigEmojiWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: ChatEmojiState.bigEmoji
          .map((e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: e
                    .map((assetspath) => Container(
                          height: GlobalUtils.fitSize(100),
                          width: GlobalUtils.fitSize(100),
                          child: GestureDetector(
                            onTap: () => {
                              ChatViewState.instance.onInputBigEmoji(assetspath)
                            },
                            child: Image.asset(assetspath + ".png"),
                          ),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}

class EmojiEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      constraints: BoxConstraints(minHeight: 1),
    );
  }
}

class EmojiWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: GlobalUtils.fitSize(300)),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Column(
        children: [
          Container(
            height: GlobalUtils.fitSize(240),
            color: GlobalUtils.colorSecond,
            child: PageView(
              controller: ChatViewState.instance.pageController,
              onPageChanged: (int page) =>
                  {ChatViewState.instance.onEmojiPageChange(page, false)},
              children: [NormalEmojiWidget(), BigEmojiWidget()],
            ),
          ),
          Container(
            height: GlobalUtils.fitSize(60),
            child: Stack(
              children: [
                Positioned(
                  left: GlobalUtils.fitSize(1),
                  top: GlobalUtils.fitSize(1),
                  width: GlobalUtils.fitSize(48),
                  child: Container(
                    width: GlobalUtils.fitSize(48),
                    color: GlobalUtils.colorSecond,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: GlobalUtils.fitSize(60),
                      width: GlobalUtils.fitSize(48),
                      color: ChatViewState.instance.getPageIndex() == 0
                          ? GlobalUtils.colorSecond
                          : Colors.transparent,
                      child: GestureDetector(
                        onTap: () =>
                            {ChatViewState.instance.onEmojiPageChange(0, true)},
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          child: Text(
                            "\uD83D\uDE00",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: GlobalUtils.fitSize(32),
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: GlobalUtils.fitSize(60),
                      width: GlobalUtils.fitSize(48),
                      color: ChatViewState.instance.getPageIndex() == 1
                          ? GlobalUtils.colorSecond
                          : Colors.transparent,
                      child: GestureDetector(
                        onTap: () =>
                            {ChatViewState.instance.onEmojiPageChange(1, true)},
                        child: Image.asset("expression_01.png"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
