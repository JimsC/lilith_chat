package com.example.chat

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.os.CountDownTimer
import android.view.inputmethod.InputMethodManager
import androidx.appcompat.app.AppCompatActivity
import com.example.chat4.R
import java.util.*


class ChatMessage {
    enum class MsgType {
        SYSTEM, AT, EMOJI, TEXT
    } //@，表情，文字，系统提示

    enum class MsgState {
        UNTRANS, TRANSING, TRANSED
    }

    class MessageContent {
        var mType: MsgType = MsgType.TEXT
        var mContent: String = ""
    }

    var mTime = ""
    var mID = 0
    var mMsgTime: Long = 0
    var mSendID = 0
    var mSenderHeader = 0
    var mSendNick: String = ""
    var mMsgState: MsgState = MsgState.UNTRANS
    var mContents: MessageContent = MessageContent()
    var mTransContents: MessageContent = MessageContent()
    var stateSelect = false

    fun isSelf(): Boolean {
        return mSendID == 0
    }

    companion object {
        fun copyMsg(srcMsg: ChatMessage, newid: Boolean = false): ChatMessage {
            val msg = ChatMessage()
            msg.mTime = srcMsg.mTime
            if (newid) {
                msg.mID = beginID++
            } else {
                msg.mID = srcMsg.mID
            }
            msg.mSendID = srcMsg.mSendID
            msg.mMsgTime = srcMsg.mMsgTime
            msg.mSenderHeader = srcMsg.mSenderHeader
            msg.mSendNick = srcMsg.mSendNick
            msg.mMsgState = srcMsg.mMsgState
            msg.mContents = srcMsg.mContents
            msg.mTransContents = srcMsg.mTransContents
            return msg
        }

        val randomMsg: ChatMessage
            get() {
                val msgindex = Random(Date().time + beginID * 1000 * 1000).nextInt(testcontents.size)

                val newmsg = MessageContent()
                newmsg.mType = MsgType.TEXT
                newmsg.mContent = testcontents[msgindex]

                val newmsg2 = MessageContent()
                newmsg2.mType = MsgType.TEXT
                newmsg2.mContent = testcontents[msgindex]

                val msg = ChatMessage()
                msg.mID = beginID++
                val sender = Random(Date().time + beginID * 100).nextInt(testnames.size)
                msg.mSendID = sender
                msg.mSenderHeader = sender
                msg.mSendNick = testnames[sender]
                msg.mMsgTime = Date().time
                msg.mMsgState = MsgState.UNTRANS

                msg.mContents = newmsg
                msg.mTransContents = newmsg2
                msg.mTime = Date().getToday()
                return msg
            }

        private var beginID = 1
        private val testnames = arrayOf("醉青楼", "蓝色幻想", "导演", "㐭蒻峯", "nodream", "sos", "小宇殿下Alex",
            "做程序死路一条", "ific", "blank")
        private val testcontents = arrayOf(
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
        )
    }
}

class ChatChannel {
    var isSelect = false
    var channelName = "频道"
    var lastMsg = ""
    var lastTime = ""
    var channelIndex = 0
    var chatMsgs: MutableList<ChatMessage> = arrayListOf()

    fun updateInfo() {
        if (chatMsgs.size > 0) {
            var msg = chatMsgs[chatMsgs.lastIndex]
            var msgsize = msg.mContents.mContent.length
            lastMsg = msg.mContents.mContent.substring(0, if (msgsize < 8) msgsize else 8)
            if (lastMsg.isNotEmpty()) {
                lastMsg = "$lastMsg..."
            }
            lastTime = msg.mTime
        }
    }
}

object ChatEmojiState {
    var emojis = arrayOf(
        "\uD83D\uDE00", "\uD83D\uDE04", "\uD83D\uDE06", "\uD83E\uDD23", "\uD83D\uDE42", "\uD83D\uDE09", "\uD83D\uDE07", "\uD83E\uDD29",
        "\uD83E\uDD28", "\uD83D\uDE19", "\uD83D\uDE1B", "\uD83E\uDD2A", "\uD83E\uDD11", "\uD83E\uDD2D", "\uD83E\uDD14", "\uD83E\uDD28",
        "\uD83D\uDE36", "\uD83D\uDE12", "\uD83D\uDE2C", "\uD83D\uDE0C", "\uD83D\uDE2A", "\uD83D\uDE34", "\uD83E\uDD12", "\uD83E\uDD22",
        "\uD83D\uDE35", "\uD83E\uDD20", "\uD83D\uDE15", "\uD83D\uDE32", "\uD83D\uDE0E", "\uD83D\uDE28", "\uD83E\uDD13", "\uD83D\uDE0D",
        "\uD83D\uDE25", "\uD83D\uDE2D", "\uD83D\uDE31", "\uD83D\uDE13", "\uD83D\uDE24", "\uD83D\uDE21", "\uD83D\uDC7F", "\uD83D\uDC80",
        "\uD83D\uDC79", "\uD83D\uDC7B", "\uD83D\uDC7D", "\uD83D\uDE48", "\uD83D\uDE49", "\uD83D\uDE4A", "\uD83D\uDC8B", "\uD83D\uDC95",
        "\uD83D\uDC35", "\uD83D\uDC36", "\uD83D\uDC31", "\uD83D\uDC0E", "\uD83D\uDC2E", "\uD83D\uDC37", "\uD83D\uDC2D", "\uD83D\uDC30",
        "\uD83D\uDC14", "\uD83D\uDC26", "\uD83D\uDC0D", "\uD83D\uDC1B", "\uD83D\uDC4B", "\uD83E\uDD1A", "\uD83D\uDC4C", "\uD83E\uDD1F",
        "\uD83E\uDD19", "\uD83D\uDC48", "\uD83D\uDC49", "\uD83D\uDC46", "\uD83D\uDC47", "\uD83D\uDC4D", "\uD83D\uDC4E", "\uD83D\uDC4A",
        "\uD83D\uDC4F", "\uD83D\uDC50", "\uD83E\uDD1D", "\uD83D\uDE4F", "\uD83D\uDCAA", "\uD83D\uDC66", "\uD83D\uDC67", "\uD83D\uDC76"
    )
    var bigEmoji = arrayOf(
        R.drawable.expression_01, R.drawable.expression_02, R.drawable.expression_03, R.drawable.expression_04,
        R.drawable.expression_05, R.drawable.expression_06, R.drawable.expression_07, R.drawable.expression_08,
        R.drawable.expression_09, R.drawable.expression_10, R.drawable.expression_11, R.drawable.expression_12,
        R.drawable.expression_12, R.drawable.expression_14, R.drawable.expression_15, R.drawable.expression_16,
        R.drawable.expression_17, R.drawable.expression_18, R.drawable.expression_19, R.drawable.expression_20,
    )
}

class ChatViewState {
    var chatChannels: MutableList<ChatChannel> = arrayListOf()
    var chatMsgs: MutableList<ChatMessage> = arrayListOf()
    var inputText = ""


    var designWidownWidth = 720
    var designWidownHeight = 1080

    var emojiHeight = 400
    var keyboardHeight = 0
    var showMenu = false
    var showEmoji = false
    var appContext: AppCompatActivity? = null
    var viewUpdater: (() -> Unit)? = null
    var viewScroller: ((Boolean) -> Unit)? = null
    var viewKeyboardChange: ((Boolean) -> Unit)? = null
    var viewInputChange: (() -> Unit)? = null

    fun initState(context: AppCompatActivity) {
        appContext = context
        val dm = context.resources.displayMetrics
        designWidownWidth = dm.widthPixels
        designWidownHeight = dm.heightPixels
        emojiHeight = 400.fitPx

        val channel1 = ChatChannel()
        channel1.channelIndex = 0
        channel1.isSelect = true
        chatChannels.add(channel1)

        val channel2 = ChatChannel()
        channel2.channelIndex = 1
        chatChannels.add(channel2)

        for (i in 1..5) {
            addRandomMsg(0)
        }
        for (i in 1..10) {
            addRandomMsg(1)
        }
        chatMsgs = chatChannels[0].chatMsgs
        viewUpdater = {
            println("no viewUpdater")
        }
        viewScroller = {
            println("no viewScroller")
        }

        viewKeyboardChange = {
            println("no viewKeyboardChange")
        }
        viewInputChange = {
            println("no viewInputChange")
        }
    }

    fun refreshMsg(refreshover: () -> Unit) {
        delayCall(1.5f) {
            for (i in 0 until chatChannels.size) {
                if (chatChannels[i].isSelect) {
                    addRandomMsg(i, true)
                    addRandomMsg(i, true)
                    addRandomMsg(i, true)
                    addRandomMsg(i, true)
                    addRandomMsg(i, true)
                }
            }
            viewUpdater?.invoke()
        }

        delayCall(2f) {
            refreshover()
        }
    }

    fun addCurrentMsg() {
        for (i in 0 until chatChannels.size) {
            if (chatChannels[i].isSelect) {
                addRandomMsg(i)
            }
        }
        viewUpdater?.invoke()
        viewScroller?.invoke(true)
    }

    fun addRandomMsg(channelIndex: Int, addFront: Boolean = false) {
        val newmsg = ChatMessage.randomMsg
        if (addFront) {
            chatChannels[channelIndex].chatMsgs.add(0, newmsg)
        } else {
            chatChannels[channelIndex].chatMsgs.add(newmsg)
        }

        chatChannels[channelIndex].updateInfo()

    }

    fun onKeyboardHeightChange(newHeight: Int) {
        if (keyboardHeight != newHeight) {
            keyboardHeight = newHeight
            viewUpdater?.invoke()
            viewScroller?.invoke(false)
            if (keyboardHeight > 0) {
                showEmoji = false
            }
            delayCall(0.5f) {
                viewKeyboardChange?.invoke(keyboardHeight > 0)
            }

        }

    }

    fun onMenuClick() {
        showMenu = !showMenu
        if (showMenu) {
            val imm: InputMethodManager = appContext?.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            imm.hideSoftInputFromWindow(appContext!!.getWindow().getDecorView().getWindowToken(), 0)
            showEmoji = false
        }
        viewUpdater?.invoke()
    }

    fun onChannelChange(channelIndex: Int) {
        if (chatChannels[channelIndex].isSelect) {
            return
        }
        for (chatchannel in chatChannels) {
            chatchannel.isSelect = false
        }
        chatChannels[channelIndex].isSelect = true
        chatMsgs = chatChannels[channelIndex].chatMsgs
        showMenu = false
        viewUpdater?.invoke()
        viewScroller?.invoke(true)
    }

    fun onInputChange(newInput: String) {
        inputText = newInput
    }

    fun onInputAdd(newInput: String) {
        inputText += newInput
    }

    fun onInputEmoji(newInput: String) {
        inputText += newInput
        viewInputChange?.invoke()
    }

    fun onInputBigEmoji(bigIndex: Int) {
        val newmsg = ChatMessage.randomMsg
        newmsg.mSendID = 0
        newmsg.mContents.mContent = bigIndex.toString()
        newmsg.mContents.mType = ChatMessage.MsgType.EMOJI

        for (chatchannel in chatChannels) {
            if (chatchannel.isSelect) {
                chatchannel.chatMsgs.add(newmsg)
            }
        }

        viewUpdater?.invoke()
        viewScroller?.invoke(true)
    }

    fun onSendInput() {
        val newmsg = ChatMessage.randomMsg
        newmsg.mSendID = 0
        newmsg.mContents.mContent = inputText
        inputText = ""
        for (chatchannel in chatChannels) {
            if (chatchannel.isSelect) {
                chatchannel.chatMsgs.add(newmsg)
            }
        }
        viewUpdater?.invoke()
        viewScroller?.invoke(true)
    }

    fun onEmojiClick() {
        if (showMenu) {
            return
        }
        showEmoji = !showEmoji
        if (showEmoji && keyboardHeight > 0) {
            val imm: InputMethodManager = appContext?.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            imm.hideSoftInputFromWindow(appContext!!.getWindow().getDecorView().getWindowToken(), 0)
        } else {
            viewUpdater?.invoke()
        }
    }


    fun onTransMsg(msgid: Int) {
        for (i in 0 until chatMsgs.size) {
            if (chatMsgs[i].mID == msgid) {
                chatMsgs[i] = ChatMessage.copyMsg(chatMsgs[i])
                chatMsgs[i].mMsgState = ChatMessage.MsgState.TRANSING
            }
        }


        viewUpdater?.invoke()
        delayCall(2f) {
            for (i in 0 until chatMsgs.size) {
                if (chatMsgs[i].mID == msgid) {
                    chatMsgs[i] = ChatMessage.copyMsg(chatMsgs[i])
                    chatMsgs[i].mMsgState = ChatMessage.MsgState.TRANSED
                }
            }
            viewUpdater?.invoke()
        }
    }

    fun onLongPressMsg(msgid: Int) {
        for (i in 0 until chatMsgs.size) {
            if (chatMsgs[i].stateSelect) {
                chatMsgs[i] = ChatMessage.copyMsg(chatMsgs[i])
                chatMsgs[i].stateSelect = false
            }
        }
        for (i in 0 until chatMsgs.size) {
            if (chatMsgs[i].mID == msgid) {
                chatMsgs[i] = ChatMessage.copyMsg(chatMsgs[i])
                chatMsgs[i].stateSelect = true
            }
        }
        viewUpdater?.invoke()
    }

    fun onCopyMsg() {
        for (i in 0 until chatMsgs.size) {
            if (chatMsgs[i].stateSelect) {

                chatMsgs[i] = ChatMessage.copyMsg(chatMsgs[i])
                chatMsgs[i].stateSelect = false
                val clipboard = appContext?.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                val clip: ClipData = ClipData.newPlainText("simple text", chatMsgs[i].mContents.mContent)
                clipboard.setPrimaryClip(clip)
            }
        }
        viewUpdater?.invoke()
    }

    fun delayCall(seconds: Float, call: () -> Unit) {
        val countDownTimer = object : CountDownTimer((1000L * seconds).toLong(), 1000L) {
            override fun onTick(millisUntilFinished: Long) {
                // your logic for tick
            }

            override fun onFinish() {
                // your logic for finish
                call()
            }
        }
        countDownTimer.start()
    }

}