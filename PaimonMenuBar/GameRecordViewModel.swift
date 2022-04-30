//
//  GameRecordViewModel.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/25.
//

import Foundation
import SwiftUI
import Network

private let emptyGameRecord = GameRecord(
    retcode: nil,  // Indicate that this is a mock record
    
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

/**
 This ViewModel also drives itself to update continuously.
 **/
class GameRecordViewModel: ObservableObject {
    /** Singleton GameRecordVM across the application **/
    static let shared = GameRecordViewModel()
    
    private var initialized = false

    /** The cached game record in userdefaults */
    @Published private(set) var gameRecord: GameRecord = emptyGameRecord {
        didSet {
            onGameRecordChanged()
        }
    }
    
    /** The record update interval set in userdefaults */
    // Note: Resin restores every 8 minutes
    @Published var recordUpdateInterval: Double = 60 * 8 {
        didSet {
            onRecordUpdateIntervalChanged()
        }
    }
    
    func updateGameRecordNow() async -> GameRecord? {
        if let data = await getGameRecord() {
            DispatchQueue.main.async {
                self.gameRecord = data
            }
            return data
        } else {
            return nil
        }
    }
    
    private var lastUpdateAt: DispatchTime = DispatchTime.init(uptimeNanoseconds: 0)
    private var updateTask: Task<Void, Never>?
    
    /**
     Unlike updateGameRecordNow, this is throttle-protected so that not each call will cause an update.
     Also it will return immediately, schedules an update in the background.
     
     Must be called in the main thread to avoid race condition.
     **/
    func tryUpdateGameRecord() {
        assert(Thread.isMainThread)
        
        guard updateTask == nil else {
            // If there is an on-flying request, skip.
            print("Fetch skipped, there is on-flying request")
            return
        }
        let now = DispatchTime.now()
        if now.uptimeNanoseconds - lastUpdateAt.uptimeNanoseconds < 60*UInt64(1e9) {
            // If last request is started within 1 minute, skip.
            print("Fetch skipped, a fetch was performed recently")
            return
        }
        lastUpdateAt = now
        updateTask = Task {
            _ = await updateGameRecordNow()
            updateTask = nil
        }
    }

    /** Must be called in the main thread to avoid race condition. */
    func clearGameRecord() {
        assert(Thread.isMainThread)
        
        gameRecord = emptyGameRecord
    }
    
    // MARK: - Self-Update the record when network is actve
    
    private let networkActivityMon = NWPathMonitor()
    
    private func startNetworkActivityUpdater() {
        assert(Thread.isMainThread)
        
        networkActivityMon.pathUpdateHandler = { [weak self] path in
            if path.status != .satisfied {
                return
            }
            print("Network is active")
            self?.tryUpdateGameRecord()
        }
        networkActivityMon.start(queue: DispatchQueue.main)
    }
    
    // MARK: -
    
    // MARK: - Self-Update the record according to the interval
    
    private var updateTimer: Timer?
    
    private func resetUpdateTimer() {
        assert(Thread.isMainThread)
        
        if updateTimer != nil {
            updateTimer?.invalidate()
        }
        updateTimer = Timer.scheduledTimer(withTimeInterval: recordUpdateInterval, repeats: true) { timer in
            print("Scheduled update is triggered")
            self.tryUpdateGameRecord()
        }
    }
    
    // MARK: -

    /** Key to access userdefaults **/
    private let recordKeyGameRecord = "game_record"
    private let recordKeySelfUpdateInterval = "update_interval"

    init() {
        // Try to load game record from user defaults
        if let data = UserDefaults.standard.data(forKey: recordKeyGameRecord),
           let decodedGameRecord = try? JSONDecoder().decode(GameRecord.self, from: data)
        {
            gameRecord = decodedGameRecord
        }
        
        if let interval = UserDefaults.standard.object(forKey: recordKeySelfUpdateInterval) as? Double {
            recordUpdateInterval = interval
        }
        
        initialized = true
        
        startNetworkActivityUpdater()
        resetUpdateTimer()
    }

    private func onGameRecordChanged() {
        assert(Thread.isMainThread)
        
        guard initialized else { return } // Ignore any value change when init is not finished
        
        print("GameRecord is updated\n", gameRecord)
        if let encodedGameRecord = try? JSONEncoder().encode(gameRecord) {
            UserDefaults.standard.set(encodedGameRecord, forKey: recordKeyGameRecord)
        }
        
        AppDelegate.shared.updateStatusBar()
    }
    
    private func onRecordUpdateIntervalChanged() {
        assert(Thread.isMainThread)
        
        guard initialized else { return } // Ignore any value change when init is not finished
        
        print("SelfUpdateInterval is changed to", recordUpdateInterval)
        UserDefaults.standard.set(recordUpdateInterval, forKey: recordKeySelfUpdateInterval)
        resetUpdateTimer()
    }
}
