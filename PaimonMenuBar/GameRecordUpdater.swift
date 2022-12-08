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
import UserNotifications

class GameRecordUpdater {
    static let shared = GameRecordUpdater()

    /**
     Fetch latest game record. After finished, UI will be updated accordingly.
     */
    func fetchGameRecordAndRenderNow() async -> GameRecord? {
        if let data = await getGameRecord() {
            DispatchQueue.main.async {
                Defaults[.lastGameRecord] = data
                Defaults[.fetchFailed] = false
            }
            return data
        } else {
            // sendLocalNotification(context: "⚠️ Data fetch failed, check your configuration") {}

            /**
             The new API is more likely to fail due to captcha. Instead of sending notification
             each time fetch fails, we update the UI when we encounter the captcha instead.
             */
            DispatchQueue.main.async {
                Defaults[.fetchFailed] = true
            }
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
        if now.uptimeNanoseconds - lastUpdateAt.uptimeNanoseconds < 8 * 60 * UInt64(1e9) {
            // If last request is started within 8 minutes, skip.
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

    // MARK: - Make a request to the remote API and update the record according to the interval

    private var apiUpdateTimer: Timer?

    private func resetApiUpdateTimer() {
        assert(Thread.isMainThread)

        if apiUpdateTimer != nil {
            apiUpdateTimer?.invalidate()
        }
        apiUpdateTimer = Timer
            .scheduledTimer(withTimeInterval: Defaults[.recordUpdateInterval] * 3600, repeats: true) { _ in
                print("Scheduled update is triggered")
                self.tryFetchGameRecordAndRender()
            }

        resetLocalUpdateTimer()
    }

    // MARK: - Self-Update the record according to the interval (which is 8 mins)

    private var localUpdateTimer: Timer?

    private func resetLocalUpdateTimer() {
        assert(Thread.isMainThread)

        if localUpdateTimer != nil {
            localUpdateTimer?.invalidate()
        }
        localUpdateTimer = Timer.scheduledTimer(withTimeInterval: 8 * 60, repeats: true, block: { _ in
            print("Local updater triggered.")

            guard self.updateTask == nil else {
                // If there is an on-flying network request, then skip.
                print("Local updater skipped, there is on-flying request")
                return
            }

            var gameRecord = Defaults[.lastGameRecord]
            guard gameRecord.fetchAt != nil else {
                print("Local updater skipped as there has never been an update from the API")
                return
            }

            // Update resin and recovery time
            if gameRecord.data.current_resin < gameRecord.data.max_resin {
                gameRecord.data.current_resin += 1
            }
            let resinRecoveryTime = Int(gameRecord.data.resin_recovery_time) ?? 0
            if resinRecoveryTime > 0 {
                let updatedTime = resinRecoveryTime - 8 * 60
                gameRecord.data
                    .resin_recovery_time =
                    String(updatedTime > 0 ? updatedTime : 0)
            }

            // Update expedition and their status
            for (index, expedition) in gameRecord.data.expeditions.enumerated() {
                let expeditionRemainedTime = Int(expedition.remained_time) ?? 0
                if expeditionRemainedTime > 0 {
                    let updatedRemainedTime = expeditionRemainedTime - 8 * 60
                    gameRecord.data.expeditions[index]
                        .remained_time = String(updatedRemainedTime > 0 ? updatedRemainedTime : 0)
                    if updatedRemainedTime <= 0 {
                        gameRecord.data.expeditions[index].status = "Finished"
                    }
                }
            }

            Defaults[.lastGameRecord] = gameRecord
        })
    }

    // MARK: - Record update at midnight to avoid today or tomorrow conflicts

    private func setupDayChangeUpdater() {
        assert(Thread.isMainThread)

        NotificationCenter.default.addObserver(forName: .NSCalendarDayChanged, object: nil, queue: .main) { _ in
            print("Day change (midnight) update is triggered")
            self.tryFetchGameRecordAndRender()
        }
    }

    // MARK: - Notification handler

    private func sendLocalNotification(context: LocalizedStringKey, completion: @escaping () -> Void) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
            else { return }

            let content = UNMutableNotificationContent()
            content.title = String.localized(context)
            content.sound = UNNotificationSound.default

            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            )

            center.add(request) { _ in
                completion()
            }
        }
    }

    // MARK: -

    private var initialized = false

    init() {
        startNetworkActivityUpdater()
        resetApiUpdateTimer()
//        resetLocalUpdateTimer()
        setupDayChangeUpdater()

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

        print("GameRecord is updated:", Defaults[.lastGameRecord])
        AppDelegate.shared.updateStatusBar()

        // Early return if user chooses not to push notifications
        guard Defaults[.isNotifyParametricReady] else { return }

        let parametricTransformerReady = Defaults[.lastGameRecord].data.transformer.recovery_time.reached

        /**
         Check for parametric transformer ready state - push notification only on:
         1. Parametric transformer ready
         2. User selected to notify when parametric transformer is ready
         3. Notification for parametric transformer ready state has not been sent
         */
        if parametricTransformerReady,
           Defaults[.hasNotifiedParametricReady] == false
        {
            sendLocalNotification(context: "Parametric transformer is ready") {
                // set .hasNotifiedParametricReady to true on notification delivery
                Defaults[.hasNotifiedParametricReady] = true
            }
        }

        // If parametric transformer is not ready but .hasNotifiedParametricReady is true, then reset the trigger
        if parametricTransformerReady == false,
           Defaults[.hasNotifiedParametricReady]
        {
            Defaults[.hasNotifiedParametricReady] = false
        }
    }

    private func onRecordUpdateIntervalChanged() {
        assert(Thread.isMainThread)

        guard initialized else { return }

        print("RecordUpdateInterval is changed: ", Defaults[.recordUpdateInterval])
        resetApiUpdateTimer()
    }
}
