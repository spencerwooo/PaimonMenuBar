//
//  Networking.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/24.
//

import CryptoKit
import Foundation
import SwiftUI

extension String {
    // MD5 hash from: https://powermanuscript.medium.com/swift-5-2-macos-md5-hash-for-some-simple-use-cases-66be9e274182
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

func getDS(uid: String, server: String) -> String {
    // Part 1: current unix timestamp
    let timestamp = Int(Date().timeIntervalSince1970)

    // Part 2: a random integer from 100,000 to 200,000
    let randomString = Int.random(in: 100000 ..< 200000)

    // Part 3: MD5 hash of salt
    let salt = "xV8v4Qu54lUKrEYFZkJhB8cuOh9Asafs"
    let sign = "salt=\(salt)&t=\(timestamp)&r=\(randomString)&b=&q=role_id=\(uid)&server=\(server)".MD5

    return "\(timestamp),\(randomString),\(sign)"
}

func getGameRecord() async -> GameRecord? {
    // API to query Genshin game record
    let api = "https://api-takumi-record.mihoyo.com/game_record/app/genshin/api/dailyNote"

    // Saved properties for constructing the query
    guard let uid: String = UserDefaults.standard.string(forKey: "uid"),
          let server: String = UserDefaults.standard.string(forKey: "server"),
          let cookie: String = UserDefaults.standard.string(forKey: "cookie")
    else { return nil }

    guard let url = URL(string: "\(api)?role_id=\(uid)&server=\(server)") else { return nil }

    // Reverse engineering Mihoyo API ;)
    let DS = getDS(uid: uid, server: server)

    // Construct request with query parameters and relevant headers
    var req = URLRequest(url: url)
    req.httpMethod = "GET"

    // Add required headers
    req.setValue(cookie, forHTTPHeaderField: "Cookie")
    req.setValue(DS, forHTTPHeaderField: "DS")
    req.setValue("2.19.1", forHTTPHeaderField: "x-rpc-app_version")
    req.setValue("5", forHTTPHeaderField: "x-rpc-client_type")
    req.setValue("https://webstatic.mihoyo.com/", forHTTPHeaderField: "Referer")
    req.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) miHoYoBBS/2.11.1", forHTTPHeaderField: "User-Agent")

    // Perform HTTP request
    do {
        let (data, _) = try await URLSession.shared.data(for: req)
//        if let string = String(bytes: data, encoding: .utf8) {
//            print(string)
//        }
        let gameRecord = try? JSONDecoder().decode(GameRecord.self, from: data)
        return gameRecord
    } catch {
        print("Invalid data")
        return nil
    }
}
