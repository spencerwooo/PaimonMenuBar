//
//  MenuBarResinView.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/25.
//

import Combine
import SwiftUI

struct MenuBarResinView: View {
    @StateObject var gameRecordVM = GameRecordViewModel.shared
    @ObservedObject var monitor = NetworkMonitor()
    @AppStorage("update_interval") private var updateInterval: Double = 60 * 6 // Resin restores every 6 minutes

    // Init timer before view appears
    @State var timer = Timer.publish(every: 60, tolerance: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            Image("FragileResin")
                .resizable()
                .frame(width: 19, height: 19)
            Text("\(gameRecordVM.gameRecord.data.current_resin)/\(gameRecordVM.gameRecord.data.max_resin)")
                .font(.system(.body).monospaced().bold())
        }
        .onAppear {
            // Update timer based on saved updateInterval after view loads
            self.timer = Timer.publish(every: updateInterval, tolerance: 10, on: .main, in: .common).autoconnect()
        }
        .onReceive(timer) { _ in
            Task {
                await gameRecordVM.updateGameRecord()
            }
        }
        .onChange(of: updateInterval) { interval in
            // Update timer when updateInterval changes in settings
            timer = Timer.publish(every: interval, tolerance: 10, on: .main, in: .common).autoconnect()
        }
        .onChange(of: monitor.isConnected) { connected in
            Task {
                // Update game record when application reconnects to the internet
                if connected {
                    await gameRecordVM.updateGameRecord()
                }
            }
        }
    }
}
