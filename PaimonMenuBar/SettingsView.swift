//
//  ContentView.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/23.
//

import SwiftUI

enum GenshinServer: String, CaseIterable, Identifiable {
    case cn_gf01 // 天空岛
    case cn_qd01 // 世界树
    var id: String { rawValue }
}

struct PreferenceSettingsView: View {
    @AppStorage("uid") private var uid: String = ""
    @AppStorage("server") private var server: GenshinServer = .cn_gf01
    @AppStorage("cookie") private var cookie: String = ""

    var body: some View {
        VStack {
            Text("Personal information")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Form {
                TextField("UID:", text: $uid)
                    .textFieldStyle(.roundedBorder)
                Picker("Server:", selection: $server) {
                    ForEach(GenshinServer.allCases, id: \.id) { value in
                        Text(value.rawValue).tag(value)
                    }
                }
            }.padding([.bottom])

            Text("Cookie")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Paste your cookie from [bbs.mihoyo.com/ys](https://bbs.mihoyo.com/ys)")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $cookie)
                .font(.system(.body, design: .monospaced))
                .frame(height: 80)

            Spacer()

            HStack {
                Button {
                    print("Hi!")
                } label: {
                    Label("Test config", systemImage: "bolt")
                }
                Button {
                    uid = ""
                    server = .cn_gf01
                    cookie = ""
                } label: {
                    Label("Clear all", systemImage: "trash")
                }
            }
        }.padding()
    }
}

struct AboutSettingsView: View {
    var body: some View {
        Text("About")
            .font(.title)
    }
}

struct SettingsView: View {
    var body: some View {
        TabView {
            PreferenceSettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "person")
                }
        }.frame(width: 500, height: 320)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
            PreferenceSettingsView()
            AboutSettingsView()
        }
    }
}
