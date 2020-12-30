//
//  ChatViewState.swift
//  swift_chat
//
//  Created by jims on 2020/12/16.
//

import Foundation
import MobileCoreServices
import UIKit

enum MsgType  {
    case SYSTEM
    case AT
    case EMOJI
    case TEXT
} //@，表情，文字，系统提示

enum MsgState  {
    case UNTRANS
    case TRANSING
    case TRANSED
}

struct MessageContent : Codable , Equatable{
    public var mType: String = "TEXT"
    public var mContent: String = ""
}

struct ChatMessage : Codable, Equatable, Identifiable {

    public var id = UUID()
    public var mTime = ""
    public var mID = 0
    public var mMsgTime = 0
    public var mSendID = 0
    public var mSenderHeader = 0
    public var mSendNick: String = ""
    public var mMsgState: Int = 0
    public var mContents: MessageContent = MessageContent()
    public var mTransContents: MessageContent = MessageContent()
    public var stateSelect = false

    public func isSelf() -> Bool {
        return mSendID == 0
    }

    static func copyMsg(srcMsg: ChatMessage, newid: Bool = false) -> ChatMessage {
        var msg = ChatMessage()
        msg.id=srcMsg.id
        msg.mTime = srcMsg.mTime
        if (newid) {
            msg.mID = beginID
            beginID+=1
        }else{
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

    static public var randomMsg: ChatMessage {
        let msgindex = Int(Int(arc4random()) % testcontents.count)

        var newmsg = MessageContent()
        newmsg.mType = "TEXT"
        newmsg.mContent = testcontents[msgindex]

        var newmsg2 = MessageContent()
        newmsg2.mType = "TEXT"
        newmsg2.mContent = testcontents[msgindex]

        var msg = ChatMessage()
        msg.mID = beginID
        beginID += 1
        let sender = Int(Int(arc4random()) % testnames.count)
        msg.mSendID = sender
        msg.mSenderHeader = sender
        msg.mSendNick = testnames[sender]
        let nowDate = Date.init()
        msg.mMsgTime = Int(nowDate.timeIntervalSince1970)
        msg.mMsgState = 0
        msg.mContents = newmsg
        msg.mTransContents = newmsg2
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        msg.mTime = dateformatter.string(from: nowDate)
        return msg
        
    }
    
    static public var testmsg: ChatMessage {
        let msgindex = 20

        var newmsg = MessageContent()
        newmsg.mType = "TEXT"
        newmsg.mContent = testcontents[msgindex]

        var newmsg2 = MessageContent()
        newmsg2.mType = "TEXT"
        newmsg2.mContent = testcontents[msgindex]

        var msg = ChatMessage()
        msg.mID = beginID
        beginID += 1
        let sender = 0
        msg.mSendID = sender
        msg.mSenderHeader = sender
        msg.mSendNick = testnames[sender]
        //let nowDate = Date.init()
        //msg.mMsgTime = Int(nowDate.timeIntervalSince1970)
        msg.mMsgState = 0
        msg.mContents = newmsg
        msg.mTransContents = newmsg2
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //msg.mTime = dateformatter.string(from: nowDate)
        return msg
        
    }

    static private var beginID = 1
    static private var testnames = ["醉青楼", "蓝色幻想", "导演", "㐭蒻峯", "nodream", "sos", "小宇殿下Alex","做程序死路一条", "ific", "blank"]
    static private var testcontents = [
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
    ]
    
}

extension String {
   //获取子字符串
    func substingInRange(_ r: Range<Int>) -> String {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy:r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy:r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

class ChatChannel : Codable, Identifiable {
    
    public var id = UUID()
    public var isSelect = false
    public var channelName = "频道"
    public var lastMsg = ""
    public var lastTime = ""
    public var channelIndex = 0
    public var chatMsgs = [ChatMessage]()

    func updateInfo() {
        if (chatMsgs.count > 0) {
            let msg = chatMsgs[chatMsgs.count-1]
//            let msgsize = msg.mContents.mContent.count
//            let endIndex = msgsize < 5 ? msgsize : 5
//            lastMsg = msg.mContents.mContent.substingInRange(0..<endIndex)
//            if (!lastMsg.isEmpty) {
//                lastMsg = "$lastMsg..."
//            }
            lastMsg = msg.mContents.mContent
            lastTime = msg.mTime
        }
    }
}

class ChatEmojiState {
    public static var str=""
    public static var emojis = [
        "😀","😄","😆","🤣","🙂","😉","😇","🤩",
        "🤨","😙","😛","🤪","🤑","🤭","🤔","🤨",
        "😶","😒","😬","😌","😪","😴","🤒","🤢",
        "😵","🤠","😕","😲","😎","😨","🤓","😍",
        "😥","😭","😱","😓","😤","😡","👿","💀",
        "👹","👻","👽","🙈","🙉","🙊","💋","💕",
        "🐵","🐶","🐱","🐎","🐮","🐷","🐭","🐰",
        "🐔","🐦","🐍","🐛","👋","🤚","👌","🤟",
        "🤙","👈","👉","👆","👇","👍","👎","👊",
        "👏","👐","🤝","🙏","💪","👦","👧","👶",
    ]
    public static var bigEmoji = [
        "expression_01", "expression_02", "expression_03", "expression_04",
        "expression_05", "expression_06", "expression_07", "expression_08",
        "expression_09", "expression_10", "expression_11", "expression_12",
        "expression_12", "expression_14", "expression_15", "expression_16",
        "expression_17", "expression_18", "expression_19", "expression_20",
    ]
}


class ChatViewState : ObservableObject {
    public var chatChannels  = [ChatChannel]()
    public var chatMsgs  = [ChatMessage]()
    public var inputText = ""


    public var designWidownWidth = 720
    public var designWidownHeight = 1080

    public var emojiHeight = 400
    public var keyboardHeight = 0
    public var showMenu = false
    public var showEmoji = false
    
    static private  var _instance:ChatViewState?=nil;
    static public func newState()->ChatViewState {
        if _instance != nil {
            return _instance!
        }else{
            _instance=ChatViewState()
            _instance?.initState()
            return _instance!
        }
        
        
    }
    
    func updateView() {
        objectWillChange.send()
        
    }

    func initState( ) {
        let channel1 = ChatChannel()
        channel1.isSelect = true
        channel1.channelIndex = 0
        chatChannels.append(channel1)

        let channel2 = ChatChannel()
        channel2.isSelect = false
        channel2.channelIndex = 1
        chatChannels.append(channel2)

        for _ in 1...5 {
            addRandomMsg(channelIndex: 0)
        }
        for _ in 1...10 {
            addRandomMsg(channelIndex: 1)
        }
        chatMsgs = chatChannels[0].chatMsgs
    }
    
    func keyboardShow(note: Notification)  {
//        guard let userInfo = note.userInfo else {return}
//        guard let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else{return}
//        //获取键盘弹起的高度
//        let keyboardTopYPosition = SCREENHEIGHT - keyboardRect.height
        self.showEmoji=false
        self.updateView()
        
    }

    func refreshMsg( ) {
        delayCall(seconds: 1.5) {
            for i in 0 ..< self.chatChannels.count {
                if (self.chatChannels[i].isSelect) {
                    self.addRandomMsg(channelIndex:i, addFront:true)
                    self.addRandomMsg(channelIndex:i, addFront:true)
                    self.addRandomMsg(channelIndex:i, addFront:true)
                    self.addRandomMsg(channelIndex:i, addFront:true)
                    self.addRandomMsg(channelIndex:i, addFront:true)
                    self.chatMsgs = self.chatChannels[i].chatMsgs
                    break;
                }
            }
            self.updateView()
        }
        
    }

    func addCurrentMsg() {
        for i in 0 ..< chatChannels.count {
            if (chatChannels[i].isSelect) {
                addRandomMsg(channelIndex: i)
                chatMsgs = chatChannels[i].chatMsgs
            }
        }
        updateView()
        
    }

    func addRandomMsg(channelIndex: Int, addFront: Bool = false) {
        let newmsg = ChatMessage.randomMsg
        if (addFront) {
            chatChannels[channelIndex].chatMsgs.insert(newmsg, at: 0)
        } else {
            chatChannels[channelIndex].chatMsgs.append(newmsg)
        }

        chatChannels[channelIndex].updateInfo()

    }

    func onKeyboardHeightChange(newHeight: Int) {
        if (keyboardHeight != newHeight) {
            keyboardHeight = newHeight
            
            if (keyboardHeight > 0) {
                showEmoji = false
            }
            self.updateView()
        }

    }

    func onMenuClick() {
        showMenu = !showMenu
        if (showMenu) {
            showEmoji = false
        }
        self.updateView()
        
    }

    func onChannelChange(channelIndex: Int) -> Bool{
        if (chatChannels[channelIndex].isSelect) {
            return false
        }
        for chatchannel in chatChannels {
            chatchannel.isSelect = false
        }
        chatChannels[channelIndex].isSelect = true
        chatMsgs = chatChannels[channelIndex].chatMsgs
        showMenu = false
        self.updateView()
        return true
    }

    func onInputChange(newInput: String) {
        inputText = newInput
    }

    func onInputAdd(newInput: String) {
        inputText += newInput
    }

    func onInputEmoji(newInput: String) {
        inputText += newInput
        
    }

    func onInputBigEmoji(bigIndex: Int) {
        var newmsg = ChatMessage.randomMsg
        newmsg.mSendID = 0
        newmsg.mContents.mContent = String(bigIndex)
        newmsg.mContents.mType =  "EMOJI"

        for chatchannel in chatChannels {
            if (chatchannel.isSelect) {
                chatchannel.chatMsgs.append(newmsg)
                chatMsgs = chatchannel.chatMsgs
            }
        }
        updateView()
    }

    func onSendInput() {
        var newmsg = ChatMessage.randomMsg
        newmsg.mSendID = 0
        newmsg.mContents.mContent = inputText
        inputText = ""
        for chatchannel in chatChannels {
            if (chatchannel.isSelect) {
                chatchannel.chatMsgs.append(newmsg)
                chatMsgs = chatchannel.chatMsgs
            }
        }
        
        updateView()
        
    }

    func onEmojiClick() {
        if (showMenu) {
            return
        }
        showEmoji = !showEmoji
        if (showEmoji && keyboardHeight > 0) {
            
        } else {
            
        }
        updateView()
    }


    func onTransMsg(msgid: Int) {
        for i in 0 ..< chatMsgs.count {
            if (chatMsgs[i].mID == msgid) {
                chatMsgs[i] = ChatMessage.copyMsg(srcMsg: chatMsgs[i])
                chatMsgs[i].mMsgState = 1
            }
        }

        updateView()
        
        delayCall(seconds:2) {
            for i in 0 ..< self.chatMsgs.count  {
                if (self.chatMsgs[i].mID == msgid) {
                    self.chatMsgs[i] = ChatMessage.copyMsg(srcMsg: self.chatMsgs[i])
                    self.chatMsgs[i].mMsgState = 2
                }
            }
            self.updateView()
        }
    }

    func onLongPressMsg(msgid: Int) {
        for  i in 0 ..< chatMsgs.count {
            if (chatMsgs[i].stateSelect) {
                chatMsgs[i] = ChatMessage.copyMsg(srcMsg: chatMsgs[i])
                chatMsgs[i].stateSelect = false
            }
        }
        for i in 0 ..< chatMsgs.count {
            if (chatMsgs[i].mID == msgid) {
                chatMsgs[i] = ChatMessage.copyMsg(srcMsg: chatMsgs[i])
                chatMsgs[i].stateSelect = true
            }
        }
        self.updateView()

    }

    func onCopyMsg() {
        for i in 0 ..< chatMsgs.count {
            if (chatMsgs[i].stateSelect) {
                chatMsgs[i] = ChatMessage.copyMsg(srcMsg: chatMsgs[i])
                chatMsgs[i].stateSelect = false
                
                UIPasteboard.general.string = chatMsgs[i].mContents.mContent
                
            }
        }
        self.updateView()
        
    }
    
//    func getCurrentFirstMsgId()->Int {
//        return chatMsgs[0].id
//    }
//
//    func getCurrentLastMsgId() -> Int {
//        return chatMsgs[chatMsgs.count-1].id
//    }

    func delayCall(seconds: TimeInterval, call: @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { (timer) in
            call()
        }
    }

}
