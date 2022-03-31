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

    var body: some Scene {
        WindowGroup {
            if false {}
        }
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updaterViewModel: UpdaterViewModel.shared)
            }
        }

        Settings {
            SettingsView()
        }
    }
}
