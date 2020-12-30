//
//  ChatEmoji.swift
//  swift_chat
//
//  Created by jims on 2020/12/21.
//

import Foundation
import SwiftUI
//import iPages

func emojiRow(i:Int, eventHandler: ((ChatViewEvent) -> Void)? = nil)->some View {
    HStack() {
        ForEach(0 ..< 8) { j in
            if(i*8+j < ChatEmojiState.emojis.count) {
                Button(action:  {
                    if eventHandler != nil {
                        eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventEmojiAdd, intParam: i*8+j))
                    }
                }) {
                    Text(ChatEmojiState.emojis[i*8+j])
                        .font(.system(size: 32))
                }
                
            }
        }
    }
}

func emojiPage(eventHandler: ((ChatViewEvent) -> Void)? = nil)->some View {
    VStack() {
        ForEach(0 ..< ChatEmojiState.emojis.count/8) { i in
            emojiRow(i:i, eventHandler:eventHandler)
        }
    }
}

func bigEmojiRow(i:Int, eventHandler: ((ChatViewEvent) -> Void)? = nil)->some View {
    HStack() {
        //VStack().frame(width: 10)
        ForEach(0 ..< 4) { j in
            if(i*4+j < ChatEmojiState.bigEmoji.count) {
                Button(action:  {
                    if eventHandler != nil {
                        eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventBigEmojiAdd, intParam: i*4+j))
                    }
                }) {
                    
                    Image(ChatEmojiState.bigEmoji[i*4+j])
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 78, height: 78)
                }
                .frame(width: 80, height: 80)
                
            }
        }
        //VStack().frame(width: 10)
    }
}

func bigEmojiPage(eventHandler: ((ChatViewEvent) -> Void)? = nil)->some View {
    VStack() {
        ForEach(0 ..< ChatEmojiState.bigEmoji.count/4) { i in
            bigEmojiRow(i:i, eventHandler:eventHandler)
        }
    }
}


struct ChatEmojiView: View {
    struct ViewState {
        var textInput:String=""
        var isLoading:Bool=false
    }
    @State var eventHandler: ((ChatViewEvent) -> Void)? = nil
    @State var viewState: ViewState=ViewState()
    @State private var selection: Int = 0
 
    var body: some View {
        VStack {
            
            TabView {
                ScrollView {
                    emojiPage(eventHandler: eventHandler)
                }
                ScrollView {
                    bigEmojiPage(eventHandler: eventHandler)
                }
            }
            //.frame(width: UIScreen.main.bounds.width, height: 200)
            .tabViewStyle(PageTabViewStyle())
            .background(RoundedRectangle(cornerRadius: 4).foregroundColor(colorSecond))
            .padding(EdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1))
            
            HStack {
                VStack(){}.frame(width:6)
                Button(action: {
//                    if eventHandler != nil {
//                        eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventEmoji))
//                    }
                }) {
                    Text("😀")
                        .font(.system(size: 34))
                }.frame(width: 36, height: 36)
                Button(action: {
//                    if eventHandler != nil {
//                        eventHandler?(ChatViewEvent(enentType: ChatViewEventType.EventEmoji))
//                    }
                }) {
                    Image(ChatEmojiState.bigEmoji[0])
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 34, height: 34)
                }.frame(width: 36, height: 36)
                Spacer()
            }
            .frame(height:38)
        }
        .padding(EdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1))
        .frame(height:200)
        
    }
    
}
