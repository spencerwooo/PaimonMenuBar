//
//  ContentView.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/23.
//

import LaunchAtLogin
import SwiftUI

enum GenshinServer: String, CaseIterable, Identifiable {
    case cn_gf01 // 天空岛
    case cn_qd01 // 世界树
    var id: String { rawValue }
}

struct PreferenceSettingsView: View {
    @AppStorage("update_interval") private var updateInterval: Double = 60 * 6 // Resin restores every 6 minutes
    @State private var isEditing = false

    var body: some View {
        VStack {
            Form {
                LaunchAtLogin.Toggle {
                    Text("Launch at login")
                }

                Slider(value: $updateInterval, in: 60 ... 12 * 60, step: 60, label: {
                    Text("Update interval:")
                }) { editing in
                    isEditing = editing
                }
                .frame(width: 360)

                Text("Paimon fetches data every \(updateInterval, specifier: "%.0f") seconds*")
                    .font(.caption)
            }

            Label("*Resin replenishes every 6 minutes, for your reference.", image: "FragileResin")
                .font(.caption)
                .opacity(0.6)
        }.padding()
    }
}

struct ConfigurationSettingsView: View {
    @AppStorage("uid") private var uid: String = ""
    @AppStorage("server") private var server: GenshinServer = .cn_gf01
    @AppStorage("cookie") private var cookie: String = ""

    @State private var alertText = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

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
            Text("Paste your cookie from [bbs.mihoyo.com/ys](https://bbs.mihoyo.com/ys).")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $cookie)
                .font(.system(.body, design: .monospaced))
                .frame(height: 80)

            Spacer()

            HStack {
                Button {
                    Task {
                        if let _ = await getGameRecord() {
                            self.alertText = "👌 It's working!"
                            self.alertMessage = "Your config is valid."
                            self.showAlert.toggle()
                        } else {
                            self.alertText = "🚫 Whoooops..."
                            self.alertMessage = "Failed to fetch, check your config."
                            self.showAlert.toggle()
                        }
                    }
                } label: {
                    Label("Test config", systemImage: "bolt")
                }
                .alert(isPresented: self.$showAlert, content: {
                    Alert(title: Text(alertText), message: Text(alertMessage))
                })

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
                .frame(width: 500, height: 200)
                .tabItem {
                    Label("Preference", systemImage: "gearshape")
                }
            ConfigurationSettingsView()
                .frame(width: 500, height: 320)
                .tabItem {
                    Label("Configuration", systemImage: "gear")
                }
            AboutSettingsView()
                .frame(width: 500, height: 100)
                .tabItem {
                    Label("About", systemImage: "person")
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
            PreferenceSettingsView()
            ConfigurationSettingsView()
            AboutSettingsView()
        }
    }
}
