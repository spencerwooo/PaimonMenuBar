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

/// Format a date that is of 'timeInterval' seconds away from now
/// - Parameter timeInterval: The number of seconds away from current time
/// - Returns: A human-readable string describing the future date
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
    @State private var gameRecord = GameRecord(
        retcode: 0, message: "OK",
        data: GameData(
            total_task_num: 4, max_resin: 200, resin_discount_num_limit: 0, current_resin: 0,
            current_expedition_num: 0, home_coin_recovery_time: "0", calendar_url: "", max_home_coin: 0,
            max_expedition_num: 0, finished_task_num: 0, is_extra_task_reward_received: false,
            current_home_coin: 0, remain_resin_discount_num: 0, resin_recovery_time: "0",
            expeditions: [Expeditions(status: "Finished", avatar_side_icon: "", remained_time: "0")]))

    var body: some View {
        VStack(spacing: 8) {
            ResinView(
                currentResin: gameRecord.data.current_resin, maxResin: gameRecord.data.max_resin,
                resinRecoveryTime: gameRecord.data.resin_recovery_time)

            ExpeditionView(
                expeditions: gameRecord.data.expeditions,
                maxExpeditionNum: gameRecord.data.max_expedition_num,
                currentExpeditionNum: gameRecord.data.current_expedition_num)

            DailyCommissionView(
                finishedTaskNum: gameRecord.data.finished_task_num,
                totalTaskNum: gameRecord.data.total_task_num)

            HomeCoinView(
                currentHomeCoin: gameRecord.data.current_home_coin,
                maxHomeCoin: gameRecord.data.max_home_coin,
                homeCoinRecoveryTime: gameRecord.data.home_coin_recovery_time)

            ExtraTaskRewardView(
                remainResinDiscountNum: gameRecord.data.remain_resin_discount_num,
                resinDiscountNumLimit: gameRecord.data.resin_discount_num_limit,
                isExtraTaskRewardReceived: gameRecord.data.is_extra_task_reward_received)
        }
        .padding([.horizontal, .top])
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .task {
            guard let resp = await getGameRecord() else { return }
            gameRecord = resp
        }
    }
}

struct ResinView: View {
    let currentResin: Int
    let maxResin: Int
    let resinRecoveryTime: String

    var body: some View {
        HStack {
            Image("FragileResin")
                .resizable()
                .frame(width: 16, height: 16)
            Text("当前树脂")
                .font(.subheadline)
                .opacity(0.6)
            Spacer()
        }

        Text("\(currentResin)/\(maxResin)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(.largeTitle).monospaced().bold())

        HStack {
            Label("距离全部恢复", systemImage: "hourglass.circle")
            Spacer()
            Text(formatTimeInterval(timeInterval: resinRecoveryTime))
                .font(.body.monospaced().bold())
        }
        HStack {
            Label("全部恢复于", systemImage: "clock")
            Spacer()
            Text(formatFutureDate(timeInterval: resinRecoveryTime))
                .font(.body.monospaced().bold())
        }

        Divider()
    }
}

struct ExpeditionView: View {
    let expeditions: [Expeditions]
    let maxExpeditionNum: Int
    let currentExpeditionNum: Int

    var body: some View {
        HStack {
            Text("探索派遣 \(currentExpeditionNum)/\(maxExpeditionNum)")
                .font(.subheadline)
                .opacity(0.6)
            Spacer()
        }

        VStack {
            ForEach(expeditions, id: \.self) { expedition in
                ExpeditionItemView(
                    status: expedition.status, avatar: expedition.avatar_side_icon,
                    remainedTime: expedition.remained_time)
            }
        }

        Divider()
    }
}

struct ExpeditionItemView: View {
    let status: String
    let avatar: String
    let remainedTime: String

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: avatar)) { image in
                image.resizable()
            } placeholder: { Color.gray.opacity(0.3) }
                .clipShape(Circle())
                .overlay(Circle().stroke(status == "Finished" ? Color.green : Color.gray))
                .frame(width: 20, height: 20)
            Text(status == "Finished" ? "探险完成" : "剩余探索时间")
            Spacer()
            Text(formatTimeInterval(timeInterval: remainedTime))
                .font(.system(.body).monospaced().bold())
        }
    }
}

struct DailyCommissionView: View {
    let finishedTaskNum: Int
    let totalTaskNum: Int

    var body: some View {
        HStack {
            Image("Commision")
                .resizable()
                .frame(width: 20, height: 20, alignment: .leading)
            Text("每日委托")
            Spacer()
            Text("\(finishedTaskNum)/\(totalTaskNum)")
                .font(.system(.body).monospaced().bold())
        }
    }
}

struct HomeCoinView: View {
    let currentHomeCoin: Int
    let maxHomeCoin: Int
    let homeCoinRecoveryTime: String

    var body: some View {
        HStack {
            Image("JarOfRiches")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .center)
            Text("洞天宝钱")
            Spacer()
            Text("\(currentHomeCoin)/\(maxHomeCoin)")
                .font(.system(.body).monospaced().bold())
        }.contextMenu {
            Menu("恢复时间") {}
        }
    }
}

struct ExtraTaskRewardView: View {
    let remainResinDiscountNum: Int
    let resinDiscountNumLimit: Int
    let isExtraTaskRewardReceived: Bool

    var body: some View {
        HStack {
            Image("Domain")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .center)
            Text("周本")
            Spacer()
            Text("\(remainResinDiscountNum)/\(resinDiscountNumLimit)")
                .font(.system(.body).monospaced().bold())
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
