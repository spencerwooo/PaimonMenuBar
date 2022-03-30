//
//  GameRecordViewModel.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/25.
//

import Foundation
import SwiftUI

let initGameRecord = GameRecord(
    retcode: 0, message: "OK",
    data: GameData(
        current_resin: 0, max_resin: 160, resin_recovery_time: "", finished_task_num: 0,
        total_task_num: 4, is_extra_task_reward_received: false, remain_resin_discount_num: 0,
        resin_discount_num_limit: 3, current_expedition_num: 0, max_expedition_num: 5,
        expeditions: [Expeditions(status: "Finished", avatar_side_icon: "", remained_time: "")],
        current_home_coin: 0, max_home_coin: 2400, home_coin_recovery_time: "", calendar_url: "",
        transformer: Transformer(
            obtained: true,
            recovery_time: RecoveryTime(Day: 0, Hour: 0, Minute: 0, Second: 0, reached: false), wiki: "")))

class GameRecordViewModel: ObservableObject {
    // Shared GameRecordVM across the application
    static let shared = GameRecordViewModel()

    @Published var hostingView: NSHostingView<AnyView>?
    @Published var gameRecord: GameRecord = initGameRecord {
        didSet {
            // Update hostingView frame height on gameRecord change
            let currentExpeditionNum = gameRecord.data.current_expedition_num
            hostingView?.frame = NSRect(x: 0, y: 0, width: 280, height: 265 + currentExpeditionNum * 32)
            // Save game record to userdefaults on change
            saveGameRecord()
        }
    }

    // Game record key saved in userdefaults
    let gameRecordKey = "game_record"

    init() {
        // Try to load game record from user defaults
        if let data = UserDefaults.standard.data(forKey: gameRecordKey),
           let decodedGameRecord = try? JSONDecoder().decode(GameRecord.self, from: data)
        {
            gameRecord = decodedGameRecord
        }
    }

    func updateGameRecord() async -> GameRecord? {
        print("Fetching data...")
        if let data = await getGameRecord() {
            DispatchQueue.main.async {
                self.gameRecord = data
            }
            return data
        } else {
            return nil
        }
    }

    func clearGameRecord() {
        gameRecord = initGameRecord
    }

    func saveGameRecord() {
        if let encodedGameRecord = try? JSONEncoder().encode(gameRecord) {
            UserDefaults.standard.set(encodedGameRecord, forKey: gameRecordKey)
        }
    }
}
