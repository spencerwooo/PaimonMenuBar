//
//  PaimonMenuBarApp.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/23.
//

import SwiftUI

@main
struct PaimonMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject var gameRecordVM = GameRecordViewModel.shared

    var body: some Scene {
        WindowGroup {
            if false {}
        }

        Settings {
            SettingsView()
        }
    }
}
