//
//  AppDelegate.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/23.
//

import AppKit
import Defaults
import Foundation
import SwiftUI
import UserNotifications

final class AppDelegate: NSObject, NSApplicationDelegate {
    private(set) static var shared: AppDelegate!

    private var statusItem: NSStatusItem!
    private var statusButton: NSStatusBarButton!
    private var menuItemMain: NSHostingView<MenuExtrasView>!

    /** updateStatusBar and updateStatusIcon must be called in the main thread to avoid race condition. */
    func updateStatusBar() {
        assert(Thread.isMainThread)

        updateStatusIcon()

        let gameRecord = Defaults[.lastGameRecord]
        if gameRecord.fetchAt == nil {
            statusButton.title = "-/160" // Cookie Not configured
        } else {
            statusButton.title = "\(gameRecord.data.current_resin)/\(gameRecord.data.max_resin)"
        }

        let currentExpeditionNum = gameRecord.data.current_expedition_num
        menuItemMain.frame = NSRect(x: 0, y: 0, width: 290, height: 292 + currentExpeditionNum * 36)
    }

    func updateStatusIcon() {
        assert(Thread.isMainThread)

        statusButton.imagePosition = NSControl.ImagePosition.imageLeading
        statusButton.image = NSImage(named: NSImage.Name("FragileResin"))

        // This sets the resin icon in the statusbar as monochrome if isTemplate == true
        statusButton.image?.isTemplate = Defaults[.isStatusIconTemplate]

        statusButton.image?.size.width = 19
        statusButton.image?.size.height = 19
    }

    @objc private func openSettingsView() {
        if #available(macOS 13, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }

        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        NSApp.windows.first?.makeKeyAndOrderFront(self)
    }

    func applicationDidFinishLaunching(_: Notification) {
        AppDelegate.shared = self

        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if error != nil {
                print("Notification permission not granted.")
            } else {
                print("Notification permission granted.")
            }
        }

        // Update game record on initial launch
        print("App is started")
        GameRecordUpdater.shared.tryFetchGameRecordAndRender()

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
            .addItem(NSMenuItem(title: String.localized("Preferences"), action: #selector(openSettingsView),
                                keyEquivalent: ","))
        menu
            .addItem(NSMenuItem(title: String.localized("Quit"), action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q"))

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = menu
        statusButton = statusItem.button

        updateStatusBar()
    }
}
