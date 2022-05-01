//
//  GameRecordUpdater.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/25.
//

import Combine
import Defaults
import Foundation
import Network
import SwiftUI

class GameRecordUpdater {
    static let shared = GameRecordUpdater()

    /**
     Fetch latest game record. After finished, UI will be updated accordingly.
     */
    func fetchGameRecordAndRenderNow() async -> GameRecord? {
        if let data = await getGameRecord() {
            DispatchQueue.main.async {
                Defaults[.lastGameRecord] = data
            }
            return data
        } else {
            return nil
        }
    }

    private var lastUpdateAt: DispatchTime = .init(uptimeNanoseconds: 0)
    private var updateTask: Task<Void, Never>?

    /**
     Unlike fetchGameRecordAndRenderNow, this is throttle-protected so that not each call will cause an update.
     Also it will return immediately, schedules an update in the background.

     Must be called in the main thread to avoid race condition.
     **/
    func tryFetchGameRecordAndRender() {
        assert(Thread.isMainThread)

        guard updateTask == nil else {
            // If there is an on-flying request, skip.
            print("Fetch skipped, there is on-flying request")
            return
        }
        let now = DispatchTime.now()
        if now.uptimeNanoseconds - lastUpdateAt.uptimeNanoseconds < 30 * UInt64(1e9) {
            // If last request is started within 30 seconds, skip.
            print("Fetch skipped, a fetch was performed recently")
            return
        }
        print("Try to update game record now")
        lastUpdateAt = now
        updateTask = Task {
            _ = await fetchGameRecordAndRenderNow()
            updateTask = nil
        }
    }

    /** Must be called in the main thread to avoid race condition. */
    func clearGameRecord() {
        assert(Thread.isMainThread)
        Defaults[.lastGameRecord] = GameRecord.empty
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
            self?.tryFetchGameRecordAndRender()
        }
        networkActivityMon.start(queue: DispatchQueue.main)
    }

    // MARK: - Self-Update the record according to the interval

    private var updateTimer: Timer?

    private func resetUpdateTimer() {
        assert(Thread.isMainThread)

        if updateTimer != nil {
            updateTimer?.invalidate()
        }
        updateTimer = Timer.scheduledTimer(withTimeInterval: Defaults[.recordUpdateInterval], repeats: true) { _ in
            print("Scheduled update is triggered")
            self.tryFetchGameRecordAndRender()
        }
    }

    // MARK: -

    private var initialized = false

    init() {
        startNetworkActivityUpdater()
        resetUpdateTimer()

        Defaults.observe(.recordUpdateInterval) { _ in
            self.onRecordUpdateIntervalChanged()
        }.tieToLifetime(of: self)

        Defaults.observe(.lastGameRecord) { _ in
            self.onGameRecordChanged()
        }.tieToLifetime(of: self)

        initialized = true
    }

    private func onGameRecordChanged() {
        assert(Thread.isMainThread)

        guard initialized else { return }

        print("GameRecord is updated: ", Defaults[.lastGameRecord])
        AppDelegate.shared.updateStatusBar()
    }

    private func onRecordUpdateIntervalChanged() {
        assert(Thread.isMainThread)

        guard initialized else { return }

        print("RecordUpdateInterval is changed: ", Defaults[.recordUpdateInterval])
        resetUpdateTimer()
    }
}
