//
//  MenuView.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/24.
//

import Foundation
import SwiftUI

/// Return the formatted time interval in a human-readable string
/// - Parameter timeInterval: A time interval represented in seconds
/// - Returns: A human-readable string representing the time interval
private func formatTimeInterval(timeInterval: String) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    formatter.unitsStyle = .abbreviated
    return formatter.string(from: TimeInterval(timeInterval)!)!
}

private func formatFutureDate(timeInterval: String) -> String {
    let currentTime = Date()
    let futureTime = currentTime.addingTimeInterval(TimeInterval(timeInterval)!)

    if Calendar.current.isDateInToday(futureTime) {
        return "今日 \(futureTime.formatted(date: .omitted, time: .shortened))"
    }
    if Calendar.current.isDateInTomorrow(futureTime) {
        return "明日 \(futureTime.formatted(date: .omitted, time: .shortened))"
    }
    // This should not happen, but just in case.
    return futureTime.formatted()
}

struct MenuView: View {
    @State private var gameRecord: GameRecord?

    var body: some View {
        VStack(spacing: 8) {
//            Text("更新于 16:13")
//                .font(.caption)
//                .foregroundColor(.gray)

            HStack {
                Image("FragileResin")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("当前树脂")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }.frame(maxWidth: .infinity, alignment: .leading)

            Text(gameRecord != nil ? "\(gameRecord!.data.current_resin)/\(gameRecord!.data.max_resin)" : "-/-")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.largeTitle).monospaced().bold())

            Divider()

            HStack {
                Label("距离全部恢复", systemImage: "hourglass.circle")
                    .foregroundColor(.gray)
                Spacer()
                Text(gameRecord != nil ? formatTimeInterval(timeInterval: gameRecord!.data.resin_recovery_time) : "-")
            }
            HStack {
                Label("全部恢复于", systemImage: "clock")
                    .foregroundColor(.gray)
                Spacer()
                Text(gameRecord != nil ? formatFutureDate(timeInterval: gameRecord!.data.resin_recovery_time) : "-")
            }

            Divider()

            HStack {
                Text("洞天财瓮").font(.subheadline).foregroundColor(.gray)
            }.frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            Button {
                Task {
                    let resp = await getGameRecord()
                    if resp == nil {
                        return
                    }
                    gameRecord = resp
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
        }
        .padding()
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().frame(width: 280, height: 400)
    }
}
