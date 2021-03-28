import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';

enum MsgType { SYSTEM, AT, EMOJI, TEXT } //@，表情，文字，系统提示

enum MsgState { UNTRANS, TRANSING, TRANSED }

class MessageContent {
  var mType = MsgType.TEXT;
  var mContent = "";
}

class ChatMessage {
  var mTime = "";
  var mID = 0;
  var mMsgTime = 0;
  var mSendID = 0;
  var mSenderHeader = 0;
  var mSendNick = "";
  var mMsgState = MsgState.UNTRANS;
  var mContents = new MessageContent();
  var mTransContents = new MessageContent();
  var stateSelect = false;

  isSelf() {
    return mSendID == 0;
  }

  static randomMsg() {
    var msgindex = Random(DateTime.now().millisecond + beginID * 1000 * 1000)
        .nextInt(testcontents.length);

    var newmsg = new MessageContent();
    newmsg.mType = MsgType.TEXT;
    newmsg.mContent = testcontents[msgindex];

    var newmsg2 = new MessageContent();
    newmsg2.mType = MsgType.TEXT;
    newmsg2.mContent = testcontents[msgindex];

    var msg = new ChatMessage();
    msg.mID = beginID++;
    var sender = Random(DateTime.now().millisecond + beginID * 1000 * 1000)
        .nextInt(testnames.length);
    msg.mSendID = sender;
    msg.mSenderHeader = sender;

    msg.mSendNick = testnames[sender];
    msg.mMsgTime = DateTime.now().second;
    msg.mMsgState = MsgState.UNTRANS;

    msg.mContents = newmsg;
    msg.mTransContents = newmsg2;
    msg.mTime = DateTime.now().toString();

    return msg;
  }

  static copyMsg(ChatMessage srcMsg, bool newid) {
    var msg = new ChatMessage();
    msg.mTime = srcMsg.mTime;
    if (newid) {
      msg.mID = beginID++;
    } else {
      msg.mID = srcMsg.mID;
    }

    msg.mSendID = srcMsg.mSendID;
    msg.mMsgTime = srcMsg.mMsgTime;
    msg.mSenderHeader = srcMsg.mSenderHeader;
    msg.mSendNick = srcMsg.mSendNick;
    msg.mMsgState = srcMsg.mMsgState;
    msg.mContents = srcMsg.mContents;
    msg.mTransContents = srcMsg.mTransContents;

    return msg;
  }

  static var beginID = 1;
  static var testnames = [
    "醉青楼",
    "蓝色幻想",
    "导演",
    "㐭蒻峯",
    "nodream",
    "sos",
    "小宇殿下Alex",
    "做程序死路一条",
    "ific",
    "blank"
  ];
  static var testcontents = [
    "离线完整体积有37G左右...",
    "msdn itellu ",
    "没有吗",
    "对哦,有的",
    "哪里",
    "那上面只有在线安装启动程序",
    "对吧 兄弟",
    "我告你那就是搬运官方",
    "难",
    "速度快啊",
    "vs自己怼个离线又不难",
    "挂个梯子就好了",
    "这个要搞多久",
    "我现在半天没动",
    "挂个梯子吧",
    "离线包贼大",
    "不会啊,我关掉梯子也不慢,应该是你网络问题吧",
    "我记得下载vs2017离线版也不用梯子啊",
    "好像挂一晚上也就完了",
    "你们是生成这么多东西吗",
    "不用梯子的,我是开机挂梯子,习惯性的,刚刚关闭了看速度",
    "正常的",
    "这个下载完是不是直接就是一个离线安装包了",
    "他这个也没个进度",
    "一直0.02",
    "我正好也更新一下",
    "我的竟然一直不动",
    "ilruntime支持手机真机调试不？",
    "支持",
    "有ip就能调试",
    "牛批，直接wifi连IP端口就行？",
    "是",
  ];
}

class ChatChannel {
  var isSelect = false;
  var channelName = "频道";
  var lastMsg = "";
  var lastTime = "";
  var channelIndex = 0;
  var chatMsgs = Queue<ChatMessage>();

  updateInfo() {
    if (chatMsgs.length > 0) {
      var msg = chatMsgs.last;
      var msgsize = msg.mContents.mContent.length;
      lastMsg = msg.mContents.mContent.substring(0, msgsize);
      if (msgsize < 8) {
        lastMsg = msg.mContents.mContent.substring(0, msgsize);
      } else {
        lastMsg = msg.mContents.mContent.substring(0, 8);
      }

      if (lastMsg != "") {
        lastMsg = lastMsg + "...";
      }
      lastTime = msg.mTime;
    }
  }
}

class ChatEmojiState {
  static var emojis = [
    [
      "\uD83D\uDE00",
      "\uD83D\uDE04",
      "\uD83D\uDE06",
      "\uD83E\uDD23",
      "\uD83D\uDE42",
      "\uD83D\uDE09",
      "\uD83D\uDE07",
      "\uD83E\uDD29",
    ],
    [
      "\uD83E\uDD28",
      "\uD83D\uDE19",
      "\uD83D\uDE1B",
      "\uD83E\uDD2A",
      "\uD83E\uDD11",
      "\uD83E\uDD2D",
      "\uD83E\uDD14",
      "\uD83E\uDD28",
    ],
    [
      "\uD83D\uDE36",
      "\uD83D\uDE12",
      "\uD83D\uDE2C",
      "\uD83D\uDE0C",
      "\uD83D\uDE2A",
      "\uD83D\uDE34",
      "\uD83E\uDD12",
      "\uD83E\uDD22",
    ],
    [
      "\uD83D\uDE35",
      "\uD83E\uDD20",
      "\uD83D\uDE15",
      "\uD83D\uDE32",
      "\uD83D\uDE0E",
      "\uD83D\uDE28",
      "\uD83E\uDD13",
      "\uD83D\uDE0D",
    ],
    [
      "\uD83D\uDE25",
      "\uD83D\uDE2D",
      "\uD83D\uDE31",
      "\uD83D\uDE13",
      "\uD83D\uDE24",
      "\uD83D\uDE21",
      "\uD83D\uDC7F",
      "\uD83D\uDC80",
    ],
    [
      "\uD83D\uDC79",
      "\uD83D\uDC7B",
      "\uD83D\uDC7D",
      "\uD83D\uDE48",
      "\uD83D\uDE49",
      "\uD83D\uDE4A",
      "\uD83D\uDC8B",
      "\uD83D\uDC95",
    ],
    [
      "\uD83D\uDC35",
      "\uD83D\uDC36",
      "\uD83D\uDC31",
      "\uD83D\uDC0E",
      "\uD83D\uDC2E",
      "\uD83D\uDC37",
      "\uD83D\uDC2D",
      "\uD83D\uDC30",
    ],
    [
      "\uD83D\uDC14",
      "\uD83D\uDC26",
      "\uD83D\uDC0D",
      "\uD83D\uDC1B",
      "\uD83D\uDC4B",
      "\uD83E\uDD1A",
      "\uD83D\uDC4C",
      "\uD83E\uDD1F",
    ],
    [
      "\uD83E\uDD19",
      "\uD83D\uDC48",
      "\uD83D\uDC49",
      "\uD83D\uDC46",
      "\uD83D\uDC47",
      "\uD83D\uDC4D",
      "\uD83D\uDC4E",
      "\uD83D\uDC4A",
    ],
    [
      "\uD83D\uDC4F",
      "\uD83D\uDC50",
      "\uD83E\uDD1D",
      "\uD83D\uDE4F",
      "\uD83D\uDCAA",
      "\uD83D\uDC66",
      "\uD83D\uDC67",
      "\uD83D\uDC76"
    ]
  ];
  static var bigEmoji = [
    [
      "expression_01",
      "expression_02",
      "expression_03",
      "expression_04",
    ],
    [
      "expression_05",
      "expression_06",
      "expression_07",
      "expression_08",
    ],
    [
      "expression_09",
      "expression_10",
      "expression_11",
      "expression_12",
    ],
    [
      "expression_13",
      "expression_14",
      "expression_15",
      "expression_16",
    ],
    [
      "expression_17",
      "expression_18",
      "expression_19",
      "expression_20",
    ]
  ];
}

typedef void ViewUpdater();

class ChatViewState {
  var chatChannels = <ChatChannel>[];
  var chatMsgs = Queue<ChatMessage>();
  var inputText = "";

  var designWidownWidth = 720;
  var designWidownHeight = 1080;

  var emojiHeight = 400;
  var keyboardHeight = 0;
  var showMenu = false;
  var showEmoji = false;
  var emojiPage = 0;
  ViewUpdater viewUpdater;
  ScrollController scrollController;
  TextEditingController textController;
  PageController pageController;
  // var appContext = null;
  // var viewUpdater = null;
  // var viewScroller = null;
  // var viewKeyboardChange = null;
  // var viewInputChange = null;

  ChatViewState._privateConstructor();

  static final ChatViewState instance = ChatViewState._privateConstructor();

  stateUpdate(bool scrollbottom) {
    if (viewUpdater != null) {
      viewUpdater();
      if (scrollbottom) {
        Timer(Duration(milliseconds: 100), () {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 100), curve: Curves.ease);
        });
      }
    }
  }

  addRandomMsg(int channelIndex, bool addFront) {
    var newmsg = ChatMessage.randomMsg();
    if (addFront) {
      chatChannels[channelIndex].chatMsgs.addFirst(newmsg);
    } else {
      chatChannels[channelIndex].chatMsgs.addLast(newmsg);
    }

    chatChannels[channelIndex].updateInfo();
  }

  initState() {
    var channel1 = ChatChannel();
    channel1.channelIndex = 0;
    channel1.isSelect = true;
    chatChannels.add(channel1);

    var channel2 = ChatChannel();
    channel2.channelIndex = 1;
    chatChannels.add(channel2);

    for (var i = 0; i < 5; i++) {
      addRandomMsg(0, false);
    }
    for (var i = 0; i < 5; i++) {
      addRandomMsg(1, false);
    }
    chatMsgs = chatChannels[0].chatMsgs;
    scrollController = new ScrollController();
    textController = new TextEditingController();
    pageController = new PageController();
    textController.addListener(() {
      print("the page is:" + pageController.page.toString());
    });
  }

  addCurrentMsg() {
    for (var i = 0; i < chatChannels.length; i++) {
      if (chatChannels[i].isSelect) {
        addRandomMsg(i, false);
      }
    }
    stateUpdate(true);
  }

  refreshMsg() {
    for (var i = 0; i < chatChannels.length; i++) {
      if (chatChannels[i].isSelect) {
        addRandomMsg(i, true);
        addRandomMsg(i, true);
        addRandomMsg(i, true);
        addRandomMsg(i, true);
        addRandomMsg(i, true);
      }
    }
    stateUpdate(true);
  }

  Future refreshData() async {
    await Future.delayed(Duration(seconds: 2), () {
      refreshMsg();
    });
  }

  onKeyboardHeightChange() {}

  onMenuClick() {
    showMenu = !showMenu;
    stateUpdate(false);
    }

  onChannelChange(ChatChannel channel) {
    if (channel.isSelect) {
      return;
    }
    for (var i = 0; i < chatChannels.length; i++) {
      chatChannels[i].isSelect = false;
    }

    channel.isSelect = true;
    chatMsgs = channel.chatMsgs;
    showMenu = false;
    stateUpdate(false);
  }

  onInputEmoji(String newInput) {
    var newtext = textController.text + newInput;
    textController.text = newtext;
  }

  onInputBigEmoji(String bigEmojiPath) {
    var newmsg = ChatMessage.randomMsg();
    newmsg.mSendID = 0;
    newmsg.mContents.mContent = bigEmojiPath;
    newmsg.mContents.mType = MsgType.EMOJI;

    for (var i = 0; i < chatChannels.length; i++) {
      if (chatChannels[i].isSelect) {
        chatChannels[i].chatMsgs.add(newmsg);
      }
    }
    stateUpdate(true);
  }

  onSendInput() {
    var newmsg = ChatMessage.randomMsg();
    newmsg.mSendID = 0;
    newmsg.mContents.mContent = textController.text;
    textController.text = "";
    for (var i = 0; i < chatChannels.length; i++) {
      if (chatChannels[i].isSelect) {
        chatChannels[i].chatMsgs.add(newmsg);
      }
    }
    stateUpdate(true);
  }

  onEmojiClick() {
    if (showMenu) {
      return;
    }
    showEmoji = !showEmoji;
    stateUpdate(true);
  }

  onEmojiPageChange(int pageIndex, bool withanim) {
    if (withanim) {
      pageController.animateToPage(pageIndex,
          duration: Duration(milliseconds: 400), curve: Curves.ease);
    }

    emojiPage = pageIndex;
    stateUpdate(false);
  }

  getPageIndex() {
    return emojiPage;
  }

  onTransMsg(int msgid) {
    for (var i = 0; i < chatMsgs.length; i++) {
      var chatmsg = chatMsgs.elementAt(i);
      if (chatmsg.mID == msgid) {
        chatmsg.mMsgState = MsgState.TRANSING;
      }
    }
    Timer(Duration(seconds: 2), () {
      for (var i = 0; i < chatMsgs.length; i++) {
        var chatmsg = chatMsgs.elementAt(i);
        if (chatmsg.mID == msgid) {
          chatmsg.mMsgState = MsgState.TRANSED;
        }
        stateUpdate(false);
      }
    });
    stateUpdate(false);
  }

  onLongPressMsg(int msgid) {
    for (var i = 0; i < chatMsgs.length; i++) {
      var chatmsg = chatMsgs.elementAt(i);
      if (chatmsg.stateSelect) {
        chatmsg.stateSelect = false;
      }
    }
    for (var i = 0; i < chatMsgs.length; i++) {
      var chatmsg = chatMsgs.elementAt(i);
      if (chatmsg.mID == msgid) {
        chatmsg.stateSelect = true;
      }
    }
    stateUpdate(false);
  }

  onCopyMsg() {
    for (var i = 0; i < chatMsgs.length; i++) {
      var chatmsg = chatMsgs.elementAt(i);
      if (chatmsg.stateSelect) {
        chatmsg.stateSelect = false;
        //copy
        ClipboardData data =
            new ClipboardData(text: chatmsg.mContents.mContent);
        Clipboard.setData(data);
      }
    }
    stateUpdate(false);
  }
}
