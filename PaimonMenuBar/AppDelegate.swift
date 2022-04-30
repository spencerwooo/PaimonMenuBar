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
    
    static private(set) var shared: AppDelegate!
    
    /** Must be called in the main thread to avoid race condition. */
    func updateStatusBar() {
        assert(Thread.isMainThread)
        
        guard let button = statusItem.button else { return }
        
        button.imagePosition = NSControl.ImagePosition.imageLeading
        button.image = NSImage(named:NSImage.Name("FragileResin"))
        button.image?.isTemplate = true
        button.image?.size.width = 19
        button.image?.size.height = 19
        
        let gameRecord = GameRecordViewModel.shared.gameRecord
        if gameRecord.retcode == nil {
            button.title = "" // Cookie Not configured
        } else {
            button.title = String(gameRecord.data.current_resin)
        }
        
        let currentExpeditionNum = gameRecord.data.current_expedition_num
        // 271 = 299 (ViewHeight with Padding) - 28
        menuItemMain.frame = NSRect(x: 0, y: 0, width: 280, height: 271 + currentExpeditionNum * 28)
    }
    
    private var statusItem: NSStatusItem!
    private var menuItemMain: NSHostingView<MenuExtrasView>!

    @objc private func openSettingsView() {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        NSApp.windows.first?.makeKeyAndOrderFront(self)
    }

    func applicationDidFinishLaunching(_: Notification) {
        AppDelegate.shared = self
        
        // Update game record on initial launch
        print("App is started")
        GameRecordViewModel.shared.tryUpdateGameRecord()

        // Close main APP window on initial launch
        NSApp.setActivationPolicy(.accessory)
        if let window = NSApplication.shared.windows.first {
            window.close()
        }

        setupStatusBar()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        // Hide app icon in dock after all windows are closed
        NSApp.setActivationPolicy(.accessory)
        return false
    }

    private func setupStatusBar() {
        let menu = NSMenu()

        // Main menu area, render view as NSHostingView
        menuItemMain = NSHostingView(rootView: MenuExtrasView())
        let menuItem = NSMenuItem()
        menuItem.view = menuItemMain
        menu.addItem(menuItem)

        // Submenu, preferences, and quit APP
        menu.addItem(NSMenuItem.separator())
        menu
            .addItem(NSMenuItem(title: String(localized: "Preferences"), action: #selector(openSettingsView),
                                keyEquivalent: ","))
        menu
            .addItem(NSMenuItem(title: String(localized: "Quit"), action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q"))

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = menu
        
        updateStatusBar()
    }
}
