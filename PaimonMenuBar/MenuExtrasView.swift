//
//  MenuView.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/25.
//

import Defaults
import Foundation
import Kingfisher
import SwiftUI

class RelativeFormatter {
    private let df = DateFormatter()

    init() {
        df.dateStyle = DateFormatter.Style.long
        df.timeStyle = DateFormatter.Style.short
        df.doesRelativeDateFormatting = true
    }

    func string(time: Date) -> String {
        return df.string(from: time)
    }
}

/// Return the formatted time interval in a human-readable string
/// - Parameter timeInterval: A time interval represented in seconds
/// - Returns: A human-readable string representing the time interval
private func formatTimeInterval(timeInterval: String) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    formatter.unitsStyle = .abbreviated
    return formatter.string(from: (TimeInterval(timeInterval) ?? TimeInterval("0"))!) ?? ""
}

/// Format a date that is of 'timeInterval' seconds away from now
/// - Parameter timeInterval: The number of seconds away from current time
/// - Returns: A human-readable string describing the future date
private func formatFutureDate(timeInterval: String) -> String {
    let currentTime = Date()
    let futureTime = currentTime.addingTimeInterval((TimeInterval(timeInterval) ?? TimeInterval("0"))!)

    if Calendar.current.isDateInToday(futureTime) {
        return "\(String.localized("Today")) \(futureTime.shortenedFormatted)"
    }
    if Calendar.current.isDateInTomorrow(futureTime) {
        return "\(String.localized("Tomorrow")) \(futureTime.shortenedFormatted)"
    }
    // This should not happen, but just in case.
    return futureTime.defaultFormatted
}

struct MenuExtrasView: View {
    @Default(.lastGameRecord) private var lastGameRecord

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                ResinView(
                    currentResin: lastGameRecord.data.current_resin,
                    maxResin: lastGameRecord.data.max_resin,
                    resinRecoveryTime: lastGameRecord.data.resin_recovery_time,
                    fetchAt: lastGameRecord.fetchAt
                )

                ExpeditionView(
                    expeditions: lastGameRecord.data.expeditions,
                    maxExpeditionNum: lastGameRecord.data.max_expedition_num,
                    currentExpeditionNum: lastGameRecord.data.current_expedition_num
                )

                DailyCommissionView(
                    finishedTaskNum: lastGameRecord.data.finished_task_num,
                    totalTaskNum: lastGameRecord.data.total_task_num
                )

                ExtraTaskRewardView(
                    remainResinDiscountNum: lastGameRecord.data.remain_resin_discount_num,
                    resinDiscountNumLimit: lastGameRecord.data.resin_discount_num_limit,
                    isExtraTaskRewardReceived: lastGameRecord.data.is_extra_task_reward_received
                )

                HomeCoinView(
                    currentHomeCoin: lastGameRecord.data.current_home_coin,
                    maxHomeCoin: lastGameRecord.data.max_home_coin,
                    homeCoinRecoveryTime: lastGameRecord.data.home_coin_recovery_time
                )

                ParametricTransformerView(transformer: lastGameRecord.data.transformer)
            }
            .padding([.horizontal])
            .padding([.vertical], 8)
            .opacity(lastGameRecord.fetchAt == nil ? 0.4 : 1.0)
            .blur(radius: lastGameRecord.fetchAt == nil ? 4 : 0)

            if lastGameRecord.fetchAt == nil {
                VStack(spacing: 16) {
                    Spacer()

                    Image("KokomiSad").resizable().frame(width: 72, height: 72)
                    Text("NOT INITIALIZED")
                        .font(.custom("Avenir Next Bold", size: 24, relativeTo: .largeTitle).italic())
                    Text(
                        "Please go to _Preferences > Configuration_ and setup your in-game **_UID_**, **_server_**, and **_cookie_**."
                    )

                    Spacer()
                    HStack {
                        Label("Open preferences here", systemImage: "arrow.down")
                        Spacer()
                        Link(destination: URL(string: "https://paimon.swo.moe/#how-to-get-my-cookie")!) {
                            Button("?") {
                                print("Navigating to help page.")
                            }.clipShape(Circle()).shadow(radius: 1)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct ResinView: View {
    let currentResin: Int
    let maxResin: Int
    let resinRecoveryTime: String
    let fetchAt: Date?

    private let formatter = RelativeFormatter()

    var body: some View {
        VStack(spacing: 8) {
            Text((fetchAt != nil) ? "Update: \(formatter.string(time: fetchAt!))" : "Not updated")
                .font(.caption).opacity(0.4)

            HStack(spacing: 4) {
                Image("FragileResin")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("Current Resin")
                    .font(.subheadline)
                    .opacity(0.6)
                Spacer()
            }

            Text("\(currentResin)/\(maxResin)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("Avenir Next Bold", size: 25, relativeTo: .largeTitle).italic())

            HStack {
                Label("Fully replenished", systemImage: "moon.circle")
                Spacer()
                Text(formatTimeInterval(timeInterval: resinRecoveryTime))
                    .font(.custom("Avenir Next Demi Bold", size: 13, relativeTo: .body).italic())
            }
            HStack {
                Label("ETA", systemImage: "clock")
                Spacer()
                Text(formatFutureDate(timeInterval: resinRecoveryTime))
                    .font(.custom("Avenir Next Demi Bold", size: 13, relativeTo: .body).italic())
            }
            Divider()
        }
    }
}

struct ExpeditionView: View {
    let expeditions: [Expeditions]
    let maxExpeditionNum: Int
    let currentExpeditionNum: Int

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Expeditions \(currentExpeditionNum)/\(maxExpeditionNum)")
                    .font(.subheadline)
                    .opacity(0.6)
                Spacer()
                Image("Expedition").resizable().frame(width: 18, height: 18)
            }

            ForEach(expeditions, id: \.self) { expedition in
                ExpeditionItemView(
                    status: expedition.status, avatar: expedition.avatar_side_icon,
                    remainedTime: expedition.remained_time
                )
            }

            Divider()
        }
    }
}

struct ExpeditionItemView: View {
    let status: String
    let avatar: String
    let remainedTime: String

    // 20 hours in seconds
    let totalExpeditionTime: Float = 20 * 60 * 60

    var body: some View {
        HStack {
            KFImage.url(URL(string: avatar))
                .resizable()
                .placeholder { Color.gray.opacity(0.3) }
                .clipShape(Circle())
                .overlay(Circle().stroke(status == "Finished" ? Color.green : Color.gray))
                .frame(width: 22, height: 22)

            VStack(spacing: 6) {
                HStack {
                    Text(status == "Finished" ? String.localized("Complete") : String.localized("Exploring"))
                    Spacer()
                    Text(formatTimeInterval(timeInterval: remainedTime))
                        .font(.custom("Avenir Next Demi Bold", size: 13, relativeTo: .body).italic())
                }

                ProgressView(value: totalExpeditionTime - (Float(remainedTime) ?? 0), total: totalExpeditionTime)
                    .progressViewStyle(LinearProgressViewStyle(tint: status == "Finished" ?
                            Color.green : Color(red: 0.89, green: 0.90, blue: 0.92)))
                    .frame(height: 1).scaleEffect(x: 1, y: 0.4, anchor: .center)
            }
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
            Text("Daily commissions")
            Spacer()
            Text("\(totalTaskNum - finishedTaskNum) left")
                .font(.custom("Avenir Next Demi Bold", size: 13, relativeTo: .body).italic())
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
            Text("Realm currency")
            Spacer()
            Text("\(currentHomeCoin)/\(maxHomeCoin)")
                .font(.custom("Avenir Next Demi Bold", size: 13, relativeTo: .body).italic())
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
            Text("Weekly bosses")
            Spacer()
            Text("\(remainResinDiscountNum) left")
                .font(.custom("Avenir Next Demi Bold", size: 13, relativeTo: .body).italic())
        }
    }
}

struct ParametricTransformerView: View {
    let transformer: Transformer

    func formatRecoveryTime(recoveryTime: RecoveryTime) -> String {
        if recoveryTime.reached {
            return "Ready"
        } else {
            return recoveryTime
                .Day != 0 ? "\(recoveryTime.Day) \(String.localized(recoveryTime.Day == 1 ? "day" : "days"))" :
                recoveryTime
                .Hour != 0 ? "\(recoveryTime.Hour) \(String.localized(recoveryTime.Hour == 1 ? "hour" : "hours"))"
                : "\(recoveryTime.Minute) \(String.localized(recoveryTime.Minute == 1 ? "min" : "mins"))"
        }
    }

    var body: some View {
        HStack {
            Image("ParametricTransformer")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .center)
            Text("Parametric transformer")
            Spacer()
            Text(transformer.obtained ? formatRecoveryTime(recoveryTime: transformer.recovery_time) : "Unavailable")
                .font(.custom("Avenir Next Demi Bold", size: 13, relativeTo: .body).italic())
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuExtrasView()
            .frame(width: 290.0)
            .frame(height: 472.0)
    }
}
