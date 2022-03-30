//
//  GameRecord.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/24.
//

import Foundation

struct GameRecord: Codable {
    var retcode: Int
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
