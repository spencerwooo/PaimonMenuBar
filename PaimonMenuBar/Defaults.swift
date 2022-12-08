//
//  Defaults.swift
//  PaimonMenuBar
//
//  Created by Breezewish on 2022/4/30.
//

import Defaults
import Foundation

extension Defaults.Keys {
    static let uid = Key<String>("uid", default: "")

    static let server = Key<GenshinServer>("server", default: .cn_gf01)

    static let cookie = Key<String>("cookie", default: "")

    // render the icon in the status menu view as template (white icon) or original (colored icon)
    static let isStatusIconTemplate = Key<Bool>("is_status_icon_template", default: true)

    // whether or not to render the text next to the resin icon
    static let isShowResinText = Key<Bool>("is_show_resin_text", default: true)

    // notify on parametric transformer ready
    static let isNotifyParametricReady = Key<Bool>("is_notify_parametric_ready", default: true)

    // store a state of whether the notification has been sent, to avoid duplicated notifications
    static let hasNotifiedParametricReady = Key<Bool>("has_notified_parametric_ready", default: false)

    // update every 2 hours to prevent captchas
    static let recordUpdateInterval = Key<Double>("update_interval", default: 2)

    // if the API encounters a failure (fetch failed, mostly because of the new captcha) ...
    static let fetchFailed = Key<Bool>("fetch_failed", default: false)

    static let lastGameRecord = Key<GameRecord>("game_record", default: GameRecord.empty)
}
