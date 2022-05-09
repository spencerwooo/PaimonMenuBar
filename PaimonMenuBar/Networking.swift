//
//  Networking.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/24.
//

import CryptoKit
import Defaults
import Foundation

extension String {
    // MD5 hash from: https://powermanuscript.medium.com/swift-5-2-macos-md5-hash-for-some-simple-use-cases-66be9e274182
    var MD5: String {
        let computed = Insecure.MD5.hash(data: data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

func getDS(uid: String, server: GenshinServer) -> String {
    // Part 1: current unix timestamp
    let timestamp = Int(Date().timeIntervalSince1970)

    // Part 2: a random integer from 100,000 to 200,000
    let randomString = Int.random(in: 100_000 ..< 200_000)

    // Part 3: MD5 hash of salt
    let salt = server.isCNServer ? "xV8v4Qu54lUKrEYFZkJhB8cuOh9Asafs" : "okr4obncj8bw5a65hbnn5oo6ixjc3l9w"
    let sign = "salt=\(salt)&t=\(timestamp)&r=\(randomString)&b=&q=role_id=\(uid)&server=\(server)".MD5

    return "\(timestamp),\(randomString),\(sign)"
}

func getGameRecord() async -> GameRecord? {
    // API to query Genshin game record
    let apiCn = "https://api-takumi-record.mihoyo.com/game_record/app/genshin/api/dailyNote"
    let apiGlobal = "https://bbs-api-os.hoyolab.com/game_record/app/genshin/api/dailyNote"

    let uid = Defaults[.uid]
    let server = Defaults[.server]
    let cookie = Defaults[.cookie]
    guard !uid.isEmpty, !cookie.isEmpty else {
        print("Fetch skipped, because cookie is not set")
        return nil
    }

    print("Fetching game record data...", uid, server)

    let api = server.isCNServer ? apiCn : apiGlobal
    guard let url = URL(string: "\(api)?role_id=\(uid)&server=\(server)") else { return nil }

    // Reverse engineering Mihoyo API ;)
    let DS = getDS(uid: uid, server: server)
    let appVersion = server.isCNServer ? "2.26.1" : "2.9.1"
    let clientType = server.isCNServer ? "5" : "2"

    // Construct request with query parameters and relevant headers
    var req = URLRequest(url: url)
    req.httpMethod = "GET"

    // Add required headers
    req.setValue(cookie, forHTTPHeaderField: "Cookie")
    req.setValue(DS, forHTTPHeaderField: "DS")
    req.setValue(appVersion, forHTTPHeaderField: "x-rpc-app_version")
    req.setValue(clientType, forHTTPHeaderField: "x-rpc-client_type")

    // Perform HTTP request
    do {
        let (data, _) = try await URLSession.shared.data(for: req)
//        if let string = String(bytes: data, encoding: .utf8) {
//            print(string)
//        }
        var gameRecord = try? JSONDecoder().decode(GameRecord.self, from: data)
        gameRecord?.fetchAt = Date()
        return gameRecord
    } catch {
        print("Invalid data")
        return nil
    }
}
