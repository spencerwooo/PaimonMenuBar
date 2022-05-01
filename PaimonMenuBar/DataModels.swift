//
//  DataModels.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/24.
//

import Defaults
import Foundation

struct GameRecord: Codable, Defaults.Serializable {
    /**
     This field is not returned by server. Instead, it is set by us after fetching.
     When this field is not present, it means the record is not a real record (e.g. empty record).
     */
    var fetchAt: Date?

    var retcode: Int
    var message: String

    var data: GameData

    static let empty = GameRecord(
        fetchAt: nil, // Indicate an empty record
        retcode: 0,
        message: "OK",
        data: GameData(
            current_resin: 0, max_resin: 160, resin_recovery_time: "0", finished_task_num: 0,
            total_task_num: 4, is_extra_task_reward_received: false, remain_resin_discount_num: 0,
            resin_discount_num_limit: 3, current_expedition_num: 1, max_expedition_num: 5,
            expeditions: [Expeditions(status: "Finished", avatar_side_icon: "", remained_time: "0")],
            current_home_coin: 0, max_home_coin: 2400, home_coin_recovery_time: "0", calendar_url: "",
            transformer: Transformer(
                obtained: true,
                recovery_time: RecoveryTime(Day: 0, Hour: 0, Minute: 0, Second: 0, reached: false), wiki: ""
            )
        )
    )
}

struct GameData: Codable, Defaults.Serializable {
    var current_resin: Int
    var max_resin: Int
    var resin_recovery_time: String
    var finished_task_num: Int
    var total_task_num: Int
    var is_extra_task_reward_received: Bool
    var remain_resin_discount_num: Int
    var resin_discount_num_limit: Int
    var current_expedition_num: Int
    var max_expedition_num: Int

    var expeditions: [Expeditions]

    var current_home_coin: Int
    var max_home_coin: Int
    var home_coin_recovery_time: String
    var calendar_url: String

    var transformer: Transformer
}

struct Expeditions: Codable, Hashable, Defaults.Serializable {
    var status: String
    var avatar_side_icon: String
    var remained_time: String
}

struct Transformer: Codable, Defaults.Serializable {
    var obtained: Bool
    var recovery_time: RecoveryTime
    var wiki: String
}

struct RecoveryTime: Codable, Defaults.Serializable {
    var Day: Int
    var Hour: Int
    var Minute: Int
    var Second: Int
    var reached: Bool
}

enum GenshinServer: String, CaseIterable, Identifiable, Defaults.Serializable {
    case cn_gf01 // 天空岛
    case cn_qd01 // 世界树

    case os_usa // Global (NA)
    case os_euro // Global (EU)
    case os_asia // Global (Asia)
    case os_cht // Global (SAR)

    var id: String { rawValue }

    var serverName: String {
        switch self {
        case .cn_gf01:
            return "天空岛"
        case .cn_qd01:
            return "世界树"
        case .os_usa:
            return "NA"
        case .os_euro:
            return "EU"
        case .os_asia:
            return "Asia"
        case .os_cht:
            return "SAR"
        }
    }

    var isCNServer: Bool {
        switch self {
        case .cn_gf01, .cn_qd01:
            return true
        default:
            return false
        }
    }

    var cookieSiteUrl: String {
        switch self {
        case .cn_gf01, .cn_qd01:
            return "https://bbs.mihoyo.com/ys"
        case .os_usa, .os_euro, .os_asia, .os_cht:
            return "https://www.hoyolab.com/home"
        }
    }
}
