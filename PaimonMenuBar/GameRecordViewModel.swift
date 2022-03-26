//
//  GameRecordViewModel.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/25.
//

import Foundation

let initGameRecord = GameRecord(
    retcode: 0, message: "OK",
    data: GameData(
        total_task_num: 4, max_resin: 160, resin_discount_num_limit: 0, current_resin: 0,
        current_expedition_num: 0, home_coin_recovery_time: "0", calendar_url: "", max_home_coin: 0,
        max_expedition_num: 0, finished_task_num: 0, is_extra_task_reward_received: false,
        current_home_coin: 0, remain_resin_discount_num: 0, resin_recovery_time: "0",
        expeditions: [Expeditions(status: "Finished", avatar_side_icon: "", remained_time: "0")]))

class GameRecordViewModel: ObservableObject {
    // Shared GameRecordVM across the application
    static let shared = GameRecordViewModel()

    @Published var gameRecord: GameRecord {
        didSet {
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
        } else {
            // If game record cannot be recovered, init with empty game record object
            gameRecord = initGameRecord
        }
    }

    func updateGameRecord() async {
        print("Fetching data...")
        guard let data = await getGameRecord() else { return }
        DispatchQueue.main.async {
            self.gameRecord = data
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
