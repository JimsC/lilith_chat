//
//  ChatView.swift
//  swift_chat
//
//  Created by jims on 2020/12/16.
//

import Foundation
import SwiftUI
//(255, 249, 241, 230)

let colorPrimary=Color(red: 179 / 255, green: 149 / 255, blue: 97 / 255)
let colorSecond=Color(red: 237 / 255, green: 216 / 255, blue: 191 / 255)
let colorThird=Color(red: 249 / 255, green: 241 / 255, blue: 230 / 255)

//255, 105, 99, 87
//255, 239, 227, 193
let fontColor1=Color(red: 105 / 255, green: 99 / 255, blue: 87 / 255)
let fontColor2=Color(red: 239 / 255, green: 227 / 255, blue: 193 / 255)

let headres=["head1","head2","head3","head4"]

let selectColors = [
    Color(red: 6 / 255, green: 1 / 255, blue: 0 / 255),
    Color(red: 54 / 255, green: 50 / 255, blue: 39 / 255),
    Color(red: 152 / 255, green: 143 / 255, blue: 134 / 255),
    Color(red: 242 / 255, green: 233 / 255, blue: 224 / 255),
]

let unselectColors = [
    Color(red: 255 / 255, green: 252 / 255, blue: 252 / 255),
    Color(red: 230 / 255, green: 218 / 255, blue: 206 / 255),
    Color(red: 164 / 255, green: 150 / 255, blue: 123 / 255),
    Color(red: 99 / 255, green: 81 / 255, blue: 57 / 255),
]

func getTransStatus(status:Int)->String{
    if 2==status {
        return "已翻译"
    }
    if 1==status {
        return "翻译中"
    }
    return ""
}

func getColor(isselect:Bool, index:Int)->Color {
    if isselect {
        return selectColors[index]
    }else{
        return unselectColors[index]
    }
}

func getShowNickName(chatMessage: ChatMessage)->String {
    if chatMessage.isSelf() {
        return " "
    }else{
        return chatMessage.mSendNick
    }
}

func SenderTile(headid:Int)->some View {
    Image(headres[headid%4])
        .renderingMode(.original)
        .resizable()
        .frame(width: 42, height: 42)
        .cornerRadius(21)
        .padding(.top, 12)
        .padding(.leading, 4)
}

func SenderContentTextTransed(chatMessage: ChatMessage, eventHandler: ((ChatViewEvent) -> Void)? = nil)  ->some View {
    HStack(alignment:.top) {
        
        VStack(alignment:.leading) {
            Text(chatMessage.mContents.mContent)
                .font(.system(size: 16))
                .foregroundColor(fontColor1)
                .environment(\.layoutDirection, .leftToRight)
                .onLongPressGesture(minimumDuration: 0.5) {
                    if eventHandler != nil {
                        eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventLongPress, intParam: chatMessage.mID))
                    }
                }
            Text(chatMessage.mTransContents.mContent)
                .font(.system(size: 16))
                .foregroundColor(fontColor1)
                .environment(\.layoutDirection, .leftToRight)
            
        }
        .padding(EdgeInsets(top: 6, leading: 4, bottom: 6, trailing: 4))
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(colorThird)
        )
        .padding(EdgeInsets(top: 0, leading: 0, bottom: -2, trailing: 0))
    }.overlay(
        SenderContentTextCopyBtn(chatMessage:chatMessage, eventHandler:eventHandler)
    )
}

func SenderContentTextUntransed(chatMessage: ChatMessage, eventHandler: ((ChatViewEvent) -> Void)? = nil)  ->some View {
    HStack(alignment:.top) {
        Text(chatMessage.mContents.mContent)
            .font(.system(size: 16))
            .padding(EdgeInsets(top: 6, leading: 4, bottom: 6, trailing: 4))
            .environment(\.layoutDirection, .leftToRight)
            .foregroundColor(fontColor1)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(colorThird)
            )
            .onLongPressGesture(minimumDuration: 0.1) {
                if eventHandler != nil {
                    eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventLongPress, intParam: chatMessage.mID))
                }
            }
        if(!chatMessage.isSelf() && chatMessage.mMsgState==0){
            Button(action:  {
                if eventHandler != nil {
                    eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventTrans, intParam: chatMessage.mID))
                }
            }) {
                Image("translation")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
        }
    }.overlay(
        SenderContentTextCopyBtn(chatMessage:chatMessage, eventHandler:eventHandler)
    )
}

func SenderContentTextCopyBtn(chatMessage: ChatMessage, eventHandler: ((ChatViewEvent) -> Void)? = nil)  ->some View {
    
    HStack {
        if chatMessage.stateSelect {
            Button(action:  {
                if eventHandler != nil {
                    eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventCopy, intParam: chatMessage.mID))
                }
            }) {
                Text("复制")
                    .lineLimit(1)
                    .font(.system(size: 16))
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(Color.black)
                    )
            }
        }
    }
    
    
}

func SenderContentEmoji(chatMessage: ChatMessage) ->some View {
    //"expression_01"
    //ChatEmojiState.bigEmoji[Int(chatMessage.mContents.mContent)!]
    Image(ChatEmojiState.bigEmoji[Int(chatMessage.mContents.mContent)!])
        .renderingMode(.original)
        .resizable()
        .frame(width: 120, height: 120)
        .cornerRadius( 6)
}


func SenderTransStatus(status:Int)->some View {
    HStack() {
        Text(getTransStatus(status: status))
            .lineLimit(1)
            .font(.system(size: 10))
            .foregroundColor(Color.white)
            .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color.black)
            )
        Spacer()
    }
}

func SenderContentDetail(chatMessage: ChatMessage, eventHandler: ((ChatViewEvent) -> Void)? = nil)->some View {
    VStack(alignment: .leading) {
        HStack() {
            Text(getShowNickName(chatMessage: chatMessage))
                .lineLimit(1)
                .font(.system(size: 12))
                .foregroundColor(fontColor1)
            Spacer()
        }
        
        HStack(){}.frame(height:2)
        if (chatMessage.mContents.mType ==  "EMOJI") {
            SenderContentEmoji(chatMessage: chatMessage)
        } else {
            if chatMessage.mMsgState==2  {
                SenderContentTextTransed(chatMessage: chatMessage)
                    //.offset(x: 50, y: 0), alignment: .bottom
            }else{
                SenderContentTextUntransed(chatMessage: chatMessage, eventHandler:eventHandler)
            }
            if (chatMessage.mMsgState==2 ||  chatMessage.mMsgState==1) {
                SenderTransStatus(status: chatMessage.mMsgState)
            }
        }
        
    }
    .padding(.horizontal, 2)
}

func SenderContent(chatMessage: ChatMessage, eventHandler: ((ChatViewEvent) -> Void)? = nil)->some View {
    VStack {
        if(chatMessage.isSelf()){
            HStack(alignment: .top) {
                SenderTile(headid:chatMessage.mSenderHeader)
                SenderContentDetail(chatMessage:chatMessage, eventHandler:eventHandler)
                Spacer(minLength: 50)
            }.environment(\.layoutDirection, .rightToLeft)
        }else{
            HStack(alignment: .top) {
                SenderTile(headid:chatMessage.mSenderHeader)
                SenderContentDetail(chatMessage:chatMessage, eventHandler:eventHandler)
                Spacer(minLength: 50)
            }
        }
        HStack(){}.frame(height:4)
    }
}

func mainPageTitle(eventHandler: ((ChatViewEvent) -> Void)? = nil)->some View {
    HStack(alignment:.center) {
        
        Button(action: {
            if eventHandler != nil {
                eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventMenu))
            }
        }) {
            Image("list")
                .renderingMode(.original)
                .resizable()
                .frame(width: 28, height: 28)
        }.frame(width: 30, height: 30)
        
        Spacer()
        Text("简体中文")
            .foregroundColor(fontColor2)
        //fontColor2
        Spacer()
        Button(action: {
            if eventHandler != nil {
                eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventTestAdd))
            }
        }) {
            Text("Add")
        }
        
    }.frame(height:32).padding(.horizontal, 6)
}

func mainPageInput(initText:Binding<String>, eventHandler: ((ChatViewEvent) -> Void)? = nil)->some View {
    VStack(spacing: 0) {
        HStack(spacing: 12) {
            Button(action: {
                if eventHandler != nil {
                    eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventEmoji))
                }
            }) {
                Image("happy")
                    .renderingMode(.original)
                    .resizable()
            }.frame(width: 28, height: 28)
            
            TextField("", text: initText, onCommit: {
                eventHandler?(ChatViewEvent(enentType:ChatViewEventType.EventSendContent))
            })
            //.keyboardType(.emailAddress)
            .frame(height: 40)
            .background(Color.white)
            .cornerRadius(4)
            .onChange(of: "") { value in
                eventHandler?(ChatViewEvent(enentType:ChatViewEventType.EventTxtChange, stringParam:value))
            }
            
            Button(action: {
                eventHandler?(ChatViewEvent(enentType:ChatViewEventType.EventSendContent))
            }) {
                Text("发送")
                    .font(.system(size: 22))
                    .foregroundColor(Color.white)
            }
            .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(red: 3 / 255, green: 141 / 255, blue: 252 / 255)))
            
        }
        .frame(height: 52)
        .padding(.horizontal, 4)
        .background(colorPrimary)
        
    }
    .frame(height:  52)
}

func menuItem( chatChannel: ChatChannel, eventHandler: ((ChatViewEvent) -> Void)? = nil)->some View {
    HStack {
        VStack {}.frame(width:2)
        Image("head1")
            .renderingMode(.original)
            .resizable()
            .frame(width: 56, height: 56)
            .cornerRadius(28)
            .padding(.top, 12)
            .padding(.bottom, 12)
        VStack(alignment: .leading) {
            Text(chatChannel.channelName)
                .lineLimit(1)
                .font(.system(size: 14))
                .foregroundColor(getColor(isselect: chatChannel.isSelect, index:0))
            Text(chatChannel.lastMsg)
                .lineLimit(1)
                .font(.system(size: 12))
                .foregroundColor(getColor(isselect: chatChannel.isSelect, index:1))
            Text(chatChannel.lastTime)
                .lineLimit(1)
                .font(.system(size: 8))
                .foregroundColor(getColor(isselect: chatChannel.isSelect, index:2))
        }
    }
    .background(
        RoundedRectangle(cornerRadius: 4)
            .foregroundColor(getColor(isselect: chatChannel.isSelect, index:3)))
    .padding(.bottom, 2)
    .frame(width:UIScreen.main.bounds.width*0.4)
    .contentShape(Rectangle())      // << here !!
    .onTapGesture {
        if eventHandler != nil {
            eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventChannel, intParam: chatChannel.channelIndex))
        }
    }
}

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    @State var refreshIng: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 80) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 30) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    Text("下拉刷新")
                    
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

enum ChatViewEventType {
    case None
    case EventTrans
    case EventLongPress
    case EventCopy
    case EventNewMsg
    case EventTestAdd
    case EventMenu
    case EventEmoji
    case EventSendContent
    case EventTxtChange
    case EventEmojiAdd
    case EventBigEmojiAdd
    case EventChannel
}

class ChatViewEvent {
    var enentType:ChatViewEventType=ChatViewEventType.None
    var intParam:Int=0
    var stringParam:String=""
    
    init(enentType:ChatViewEventType=ChatViewEventType.None, intParam:Int=0, stringParam:String="") {
        self.enentType=enentType
        self.intParam=intParam
        self.stringParam=stringParam
    }
}

struct ChatView: View {
    struct ViewState {
        var textInput:String=""
        var isLoading:Bool=false
    }
    @State var viewState: ViewState=ViewState()
    //@State var refreshData: RefreshData=RefreshData(isDone:$viewState.isLoading)
    @EnvironmentObject var chatViewState: ChatViewState
    @State var scrollViewProxy: ScrollViewProxy? = nil
    var drag: some Gesture {
        DragGesture()
          .onChanged { state in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
          }
          .onEnded { state in
            //print("ended")
        }
      }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(){
                if chatViewState.showMenu {
                    mainMenu
                }
                mainPage
            }
            .frame(height:geometry.size.height)
            .background(colorPrimary)
        }
    }
    
    var mainMenu:some View {
        VStack() {
            Text("消息")
                .foregroundColor(fontColor2)
                .frame(height:40)
            ForEach(chatViewState.chatChannels) {chatChannel in
                //print(chatChannel.channelName)
                menuItem(chatChannel: chatChannel, eventHandler:eventHandler)
            }
            Spacer()
        }
        .background(colorPrimary)
        .frame(width:UIScreen.main.bounds.width*0.4)
    }
    
    var mainPage:some View {
        
        VStack {
            mainPageTitle( eventHandler:eventHandler)
            VStack {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            // do your stuff when pulled
                            viewState.isLoading=true
                            eventHandler(event:ChatViewEvent(enentType: ChatViewEventType.EventNewMsg))
                        }
                        if updateScrollProxy(scrollProxy:scrollProxy) {
                            LazyVStack(spacing: 0) {
                                ForEach(chatViewState.chatMsgs) { chatMsg in
                                    SenderContent(chatMessage: chatMsg, eventHandler:eventHandler)
                                        .id(chatMsg.id)
                                }
                            }
                        }
                        
                    }.coordinateSpace(name: "pullToRefresh")
                }
                
                
            }
            .background(RoundedRectangle(cornerRadius: 4).foregroundColor(colorSecond))
            .padding(EdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 6))
            .gesture(drag)
            
            mainPageInput(initText: $viewState.textInput, eventHandler:eventHandler)
            if chatViewState.showEmoji {
                ChatEmojiView(eventHandler: eventHandler)
            }
            
        }
        .onAppear {
                //键盘抬起
                 NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.current) { (noti) in
                    chatViewState.onKeyboardHeightChange(newHeight:1)
                    
                 }
                 //键盘收起
              NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.current) { (noti) in
                chatViewState.onKeyboardHeightChange(newHeight:0)
                
                 }
             }
        .background(colorPrimary)
        .frame(width:UIScreen.main.bounds.width)
    }
    
    func updateScrollProxy(scrollProxy: ScrollViewProxy) -> Bool{
        scrollViewProxy=scrollProxy
        return true
    }
    
    func eventHandler(event:ChatViewEvent) {
        if event.enentType==ChatViewEventType.EventTrans {
            chatViewState.onTransMsg(msgid: event.intParam)
        }
        if event.enentType==ChatViewEventType.EventTestAdd {
            chatViewState.addCurrentMsg()
            delayScroll(istop: false)
            
        }
        if event.enentType==ChatViewEventType.EventNewMsg {
            chatViewState.refreshMsg()
            delayScroll(istop: true)
        }
        if event.enentType==ChatViewEventType.EventTxtChange {
            chatViewState.onInputChange(newInput: event.stringParam)
        }
        if event.enentType==ChatViewEventType.EventSendContent {
            chatViewState.onInputChange(newInput: viewState.textInput)
            chatViewState.onSendInput()
            viewState.textInput=""
            delayScroll(istop: false)
        }
        if event.enentType==ChatViewEventType.EventLongPress {
            chatViewState.onLongPressMsg(msgid: event.intParam)
        }
        if event.enentType==ChatViewEventType.EventCopy {
            chatViewState.onCopyMsg()
        }
        if event.enentType==ChatViewEventType.EventEmojiAdd {
            viewState.textInput += ChatEmojiState.emojis[event.intParam]
        }
        if event.enentType==ChatViewEventType.EventBigEmojiAdd {
            chatViewState.onInputBigEmoji(bigIndex:event.intParam)
            delayScroll(istop: false)
        }
        if event.enentType==ChatViewEventType.EventMenu {
            chatViewState.onMenuClick()
        }
        if event.enentType==ChatViewEventType.EventChannel {
            let change=chatViewState.onChannelChange(channelIndex:event.intParam)
            if change {
                delayScroll(istop: false)
            }
        }
        if event.enentType==ChatViewEventType.EventEmoji {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            chatViewState.onEmojiClick()
        }
    }
    
    func delayScroll(istop:Bool){
        chatViewState.delayCall(seconds: 0.2) {
            if scrollViewProxy != nil {
                var position=chatViewState.chatMsgs.count-1
                if istop || position < 0 { position = 0 }
                scrollViewProxy?.scrollTo(chatViewState.chatMsgs[position].id)
            }
        }
    }
}

struct MainView:View {
    var width:CGFloat
    var height:CGFloat
    var body: some View {
        NavigationView {
            ChatView()
            .navigationBarHidden(true)
        }

    }
}

struct SenderContent_Previews: PreviewProvider {
    static var previews: some View {
        //SenderContent(chatMessage:ChatMessage.testmsg)
        //Text("hehe")
        //let size=UIScreen.main.bounds.size
        MainView(width: 375, height: 667)
        
    }
}
