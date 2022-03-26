//
//  Bundle.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/26.
//

import Foundation

extension Bundle {
    var appName: String? {
        return object(forInfoDictionaryKey: "CFBundleName") as? String
    }

    var appVersion: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    var buildNumber: String? {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
