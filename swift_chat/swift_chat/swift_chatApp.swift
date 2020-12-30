//
//  swift_chatApp.swift
//  swift_chat
//
//  Created by jims on 2020/12/16.
//

import SwiftUI
import Foundation
/**

 
 */

var size=UIScreen.main.bounds.size

@main
struct swift_chatApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(width: size.width, height: size.height)
                .environmentObject(ChatViewState.newState())
        }
    }
}
