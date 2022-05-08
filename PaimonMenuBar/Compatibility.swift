//
//  Compatibility.swift
//  PaimonMenuBar
//
//  Created by DreamPiggy on 2022/5/6.
//

import Foundation
import SwiftUI

extension URLSession {
    @available(macOS, deprecated: 12.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}

extension String {
    @available(macOS, deprecated: 12.0, message: "This extension is no longer necessary. Use API built into SDK")
    static func localized(
        _ keyAndValue: LocalizedStringKey,
        table: String? = nil,
        bundle: Bundle? = nil,
        locale: Locale = .current,
        comment: StaticString? = nil
    ) -> String {
        var language = "en"
        // Region: CN
        // ID: zh-Hans-CN
        // Need: zh-Hans
        if let localRegion = locale.regionCode, let localID = locale.collatorIdentifier,
           let range = localID.range(of: localRegion)
        {
            language = String(localID[..<range.lowerBound])
            language.removeLast()
        }

        var localBundle = Bundle.main
        if let path = (bundle ?? Bundle.main).path(forResource: language, ofType: "lproj") {
            localBundle = Bundle(path: path) ?? .main
        }

        let mirror = Mirror(reflecting: keyAndValue)
        let attributeLabelAndValue = mirror.children.first { arg0 -> Bool in
            let (label, _) = arg0
            if label == "key" {
                return true
            }
            return false
        }
        guard let key = attributeLabelAndValue?.value as? String else {
            fatalError()
        }
        return NSLocalizedString(key, tableName: table, bundle: localBundle, value: "", comment: "\(comment ?? "")")
    }
}

extension Date {
    private static let shortenedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    private static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var shortenedFormatted: String {
        return Date.shortenedFormatter.string(from: self)
    }

    var defaultFormatted: String {
        return Date.defaultFormatter.string(from: self)
    }
}
