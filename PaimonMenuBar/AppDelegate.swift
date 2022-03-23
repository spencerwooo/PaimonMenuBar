//
//  AppDelegate.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/23.
//

import AppKit
import Foundation
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!
    private var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Close main APP window on initial launch
        if let window = NSApplication.shared.windows.first {
            window.close()
        }

        // Status bar icon (with button)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("FragileResin"))
            button.imagePosition = NSControl.ImagePosition.imageLeft
            button.title = "121 / 160"
        }

        setupMenus()
    }

    private func setupMenus() {
        let menu = NSMenu()

        // Submenu, preferences, and quit APP
        menu.addItem(NSMenuItem.separator())
        // TODO: fix this
        menu.addItem(NSMenuItem(title: "Preference", action: nil, keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }
}
