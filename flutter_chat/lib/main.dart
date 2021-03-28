import 'dart:collection';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'GlobalUtils.dart';
import 'ChatMessageState.dart';
import 'AppIcon.dart';
import 'EmojiWidget.dart';

void main() {
  GlobalUtils.initDevice();
  //debugPaintSizeEnabled = true;
  runApp(MaterialApp(home: App()));
  // runApp(new MediaQuery(
  //     data: new MediaQueryData.fromWindow(window),
  //     child: new Directionality(
  //         textDirection: TextDirection.ltr, child: new App())));
  //runApp(App());
}

class App extends StatefulWidget {
  // This widget is the root of your application.

  App() {
    // 初始化路由
    //AppRouter.configureRoutes();
    // 初始化尺寸的全局变量
    GlobalUtils.initDevice();
  }

  @override
  AppWidget createState() => AppWidget();
}

class TileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: GlobalUtils.fitSize(62),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => {ChatViewState.instance.onMenuClick()},
            child: Icon(AppIcon.ic_showmenu),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "简体中文",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: GlobalUtils.colorSecond,
                    fontSize: GlobalUtils.fitSize(34),
                    decoration: TextDecoration.none),
              )
            ],
          )),
          GestureDetector(
            onTap: () => {ChatViewState.instance.addCurrentMsg()},
            child: Text(
              "Add",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: GlobalUtils.fitSize(30),
                  decoration: TextDecoration.none),
            ),
          ),
        ],
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  BodyWidget({Key key, @required this.chatMsgs}) : super(key: key);
  final Queue<ChatMessage> chatMsgs;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalUtils.colorSecond,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RefreshIndicator(
        onRefresh: ChatViewState.instance.refreshData,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: ChatViewState.instance.scrollController,
          itemCount: chatMsgs.length,
          itemBuilder: (context, index) {
            return buildChatElement(chatMsgs.elementAt(index));
          },
        ),
      ),
    );
  }
}

Widget chatElementHeader(ChatMessage chatmsg) {
  return Container(
      height: GlobalUtils.fitSize(100),
      width: GlobalUtils.fitSize(100),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 14),
      child: new CircleAvatar(
        radius: 36.0,
        backgroundImage: AssetImage("head1.jpg"),
      ));
}

Widget buildTextContent(ChatMessage chatmsg) {
  return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
    Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 249, 241, 230),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: GlobalUtils.fitSize(320),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide.none,
                    left: BorderSide.none,
                    right: BorderSide.none,
                    bottom: chatmsg.mMsgState == MsgState.TRANSED
                        ? BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid)
                        : BorderSide.none,
                  )),
                  child: Text(
                    chatmsg.mContents.mContent,
                    softWrap: true,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 105, 99, 87),
                        fontSize: GlobalUtils.fitSize(24),
                        decoration: TextDecoration.none),
                  ),
                ),
                chatmsg.mMsgState == MsgState.TRANSED
                    ? Container(
                        constraints: BoxConstraints(
                          maxWidth: GlobalUtils.fitSize(320),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        child: Wrap(
                          children: [
                            Text(
                              chatmsg.mContents.mContent,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 105, 99, 87),
                                  fontSize: GlobalUtils.fitSize(24),
                                  decoration: TextDecoration.none),
                            )
                          ],
                        ))
                    : Container(
                        height: 1,
                      ),
              ],
            ),
            chatmsg.stateSelect
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.black,
                    ),
                    child: GestureDetector(
                      onTap: () => {ChatViewState.instance.onCopyMsg()},
                      child: Text(
                        "Copy",
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                            fontSize: GlobalUtils.fitSize(18),
                            decoration: TextDecoration.none),
                      ),
                    ),
                  )
                : Container()
          ],
        )),
    !chatmsg.isSelf() && chatmsg.mMsgState == MsgState.UNTRANS
        ? Container(
            width: GlobalUtils.fitSize(30),
            height: GlobalUtils.fitSize(30),
            child: GestureDetector(
              onTap: () => {ChatViewState.instance.onTransMsg(chatmsg.mID)},
              child: Icon(AppIcon.ic_trans),
            ),
          )
        : Container(width: GlobalUtils.fitSize(10))
  ]);
}

Widget buildEmojiContent(ChatMessage chatmsg) {
  return Container(
    width: GlobalUtils.fitSize(140),
    height: GlobalUtils.fitSize(140),
    child: Image.asset(chatmsg.mContents.mContent + ".png"),
  );
}

Widget chatElementContent(ChatMessage chatmsg) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(height: GlobalUtils.fitSize(10)),
      chatmsg.isSelf()
          ? Container(
              height: GlobalUtils.fitSize(10),
            )
          : Text(
              chatmsg.mSendNick,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 105, 99, 87),
                  fontSize: GlobalUtils.fitSize(20),
                  decoration: TextDecoration.none),
            ),
      Container(height: GlobalUtils.fitSize(4)),
      chatmsg.mContents.mType == MsgType.TEXT
          ? GestureDetector(
              onLongPress: () =>
                  {ChatViewState.instance.onLongPressMsg(chatmsg.mID)},
              child: buildTextContent(chatmsg),
            )
          : buildEmojiContent(chatmsg),
      chatmsg.mMsgState == MsgState.UNTRANS
          ? Container(height: GlobalUtils.fitSize(10))
          : Column(
              children: [
                Container(height: GlobalUtils.fitSize(4)),
                Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      chatmsg.mMsgState == MsgState.TRANSING ? "翻译中" : "已翻译",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: GlobalUtils.colorSecond,
                          fontSize: GlobalUtils.fitSize(12),
                          decoration: TextDecoration.none),
                    )),
                Container(height: GlobalUtils.fitSize(4))
              ],
            )
    ],
  );
}

Widget buildChatElement(ChatMessage chatmsg) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    textDirection: chatmsg.isSelf() ? TextDirection.rtl : TextDirection.ltr,
    children: [
      chatElementHeader(chatmsg),
      chatElementContent(chatmsg),
    ],
  );
}

class InputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: GlobalUtils.fitSize(60),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => {ChatViewState.instance.onEmojiClick()},
            child: Container(
              width: GlobalUtils.fitSize(48),
              child: Icon(AppIcon.ic_emoji),
            ),
          ),
          Expanded(
              child: Material(
                  child: TextField(
            controller: ChatViewState.instance.textController,
            decoration: InputDecoration(fillColor: Colors.white, filled: true),
          ))),
          GestureDetector(
            onTap: () => {ChatViewState.instance.onSendInput()},
            child: Container(
              width: GlobalUtils.fitSize(100),
              height: GlobalUtils.fitSize(48),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              //color: Colors.lightBlueAccent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlueAccent,
                ),
                child: Text(
                  "发送",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: GlobalUtils.fitSize(26),
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          height: GlobalUtils.fitSize(62),
          child: Text(
            "消息",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: GlobalUtils.colorSecond,
                fontSize: GlobalUtils.fitSize(34),
                decoration: TextDecoration.none),
          ),
        ),
        Column(
          children: ChatViewState.instance.chatChannels
              .map((channel) => GestureDetector(
                    onTap: () =>
                        {ChatViewState.instance.onChannelChange(channel)},
                    child: Container(
                      height: GlobalUtils.fitSize(100),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        color: channel.isSelect
                            ? GlobalUtils.selectColors[3]
                            : GlobalUtils.unselectColors[3],
                      ),
                      child: Row(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 6),
                              child: new CircleAvatar(
                                radius: 36.0,
                                backgroundImage: AssetImage("head1.jpg"),
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                channel.channelName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: channel.isSelect
                                        ? GlobalUtils.selectColors[0]
                                        : GlobalUtils.unselectColors[0],
                                    fontSize: GlobalUtils.fitSize(22),
                                    decoration: TextDecoration.none),
                              ),
                              Text(
                                channel.lastMsg,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: channel.isSelect
                                        ? GlobalUtils.selectColors[1]
                                        : GlobalUtils.unselectColors[1],
                                    fontSize: GlobalUtils.fitSize(20),
                                    decoration: TextDecoration.none),
                              ),
                              Text(
                                channel.lastTime,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: channel.isSelect
                                        ? GlobalUtils.selectColors[2]
                                        : GlobalUtils.unselectColors[2],
                                    fontSize: GlobalUtils.fitSize(16),
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ))
              .toList(),
        )
      ],
    );
  }
}

class AppWidget extends State<StatefulWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatState = ChatViewState.instance;
    chatState.initState();
    chatState.viewUpdater = () => {setState(() {})};
  }

  ChatViewState chatState;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     appBar: null,
    //     body: );
    return Container(
        height: GlobalUtils.screenH,
        width: GlobalUtils.screenH,
        decoration: BoxDecoration(color: GlobalUtils.colorPrimary),
        child: Row(
          children: [
            chatState.showMenu
                ? Container(
                    width: GlobalUtils.fitSize(260), child: MenuWidget())
                : Container(
                    width: 0,
                  ),
            Container(
              width: GlobalUtils.screenW,
              child: Column(
                children: <Widget>[
                  TileWidget(),
                  Expanded(child: BodyWidget(chatMsgs: chatState.chatMsgs)),
                  InputWidget(),
                  chatState.showEmoji ? EmojiWidget() : EmojiEmptyWidget()
                ],
              ),
            ),
          ],
        ));
  }
}
