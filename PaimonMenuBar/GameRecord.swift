//
//  GameRecord.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/24.
//

import Foundation

struct GameRecord: Codable {
    /**
     We specifically use nil to mark that this GameRecord is valid. The server will always present this field in the response.
     */
    var retcode: Int?
    var message: String

    var data: GameData
}

struct GameData: Codable {
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

struct Expeditions: Codable, Hashable {
    var status: String
    var avatar_side_icon: String
    var remained_time: String
}

struct Transformer: Codable {
    var obtained: Bool
    var recovery_time: RecoveryTime
    var wiki: String
}

struct RecoveryTime: Codable {
    var Day: Int
    var Hour: Int
    var Minute: Int
    var Second: Int
    var reached: Bool
}

enum GenshinServer: String, CaseIterable, Identifiable {
    case cn_gf01 // 天空岛
    case cn_qd01 // 世界树

    case os_usa // Global (NA)
    case os_euro // Global (EU)
    case os_asia // Global (Asia)
    case os_cht // Global (SAR)

    var id: String { rawValue }
}

func getGenshinServerName(server: GenshinServer) -> String {
    switch server {
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

func getCookieSiteUrl(server: GenshinServer) -> String {
    switch server {
    case .cn_gf01, .cn_qd01:
        return "https://bbs.mihoyo.com/ys"
    case .os_usa, .os_euro, .os_asia, .os_cht:
        return "https://www.hoyolab.com/home"
    }
}
