//
//  MenuBarResinView.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/25.
//

import SwiftUI

struct MenuBarResinView: View {
    @StateObject var gameRecordVM = GameRecordViewModel.shared
    let timer = Timer.publish(every: 10 * 60, tolerance: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            Image("FragileResin")
                .resizable()
                .frame(width: 19, height: 19)
            Text("\(gameRecordVM.gameRecord.data.current_resin)/\(gameRecordVM.gameRecord.data.max_resin)")
                .font(.system(.body).monospaced().bold())
        }
        .onReceive(timer) { _ in
            Task {
                await gameRecordVM.updateGameRecord()
            }
        }
    }
}
