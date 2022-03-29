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
        VStack(spacing: 16) {
            Form {
                LaunchAtLogin.Toggle {
                    Text("Launch at Login")
                }
                .formLabel(Text("Start:"))

                Slider(value: $updateInterval, in: 60 ... 12 * 60, step: 60, label: {
                    Text("Update interval:")
                }) { editing in
                    isEditing = editing
                }
                .frame(width: 400)

                Text("Paimon fetches data every \(updateInterval, specifier: "%.0f") seconds*")
                    .font(.caption).opacity(0.6)

                Button("Check for Updates") {
                    print("Hi")
                }
                .formLabel(Text("Updates:"))

                Text("Current version: \(Bundle.main.appVersion ?? "") (\(Bundle.main.buildNumber ?? ""))")
                    .font(.caption).opacity(0.6)
            }

            Divider()

            Label("*Resin replenishes every 6 minutes, for your reference.", image: "FragileResin")
                .font(.caption)
                .opacity(0.6)
        }
    }
}

struct ConfigurationSettingsView: View {
    @AppStorage("uid") private var uid: String = ""
    @AppStorage("server") private var server: GenshinServer = .cn_gf01
    @AppStorage("cookie") private var cookie: String = ""

    @State private var alertText = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

    @State private var isLoading = false

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
                        Text(value == .cn_gf01 ? "天空岛" : "世界树").tag(value)
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
                        isLoading = true
                        if let _ = await GameRecordViewModel.shared.updateGameRecord() {
                            self.alertText = "👌 It's working!"
                            self.alertMessage = "Your config is valid."
                            self.showAlert.toggle()
                        } else {
                            self.alertText = "🚫 Whoooops..."
                            self.alertMessage = "Failed to fetch, check your config."
                            self.showAlert.toggle()
                        }
                        isLoading = false
                    }
                } label: {
                    Label {
                        Text("Test config")
                    } icon: {
                        Image(systemName: "bolt")
                            .opacity(isLoading ? 0 : 1)
                            .overlay(ProgressView().scaleEffect(0.4).opacity(isLoading ? 1 : 0))
                    }
                }
                .alert(isPresented: self.$showAlert, content: {
                    Alert(title: Text(alertText), message: Text(alertMessage))
                })
                .disabled(isLoading)

                Button {
                    self.showAlert.toggle()
                    GameRecordViewModel.shared.clearGameRecord()
                } label: {
                    Label("Clear cached data", systemImage: "trash")
                }
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text("✅ Cached data all cleared!"))
                }
            }

        }.padding()
    }
}

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
            Text(Bundle.main.appName ?? "").font(.headline.bold())
            Text("Build \(Bundle.main.appVersion ?? "") (\(Bundle.main.buildNumber ?? ""))")
                .font(.system(.subheadline, design: .monospaced))

            Divider()

            Text("Made with love @ [SpencerWoo](https://spencerwoo.com)")
                .font(.system(.caption, design: .monospaced))
            Text("Icon by [Chawong](https://www.pixiv.net/en/artworks/92415888)")
                .font(.system(.caption, design: .monospaced))
        }
    }
}

struct SettingsView: View {
    var body: some View {
        TabView {
            PreferenceSettingsView()
                .tabItem {
                    Label("Preferences", systemImage: "gear")
                }
            ConfigurationSettingsView()
                .tabItem {
                    Label("Configuration", systemImage: "square.and.pencil")
                }
            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "person")
                }
        }
        .frame(width: 560, height: 320)
    }
}

/// Alignment guide for aligning a text field in a `Form`.
/// Thanks for Jim Dovey  https://developer.apple.com/forums/thread/126268
extension HorizontalAlignment {
    private enum ControlAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }

    static let controlAlignment = HorizontalAlignment(ControlAlignment.self)
}

// Adapted from https://gist.github.com/marcprux/afd2f80baa5b6d60865182a828e83586
public extension View {
    /// Attaches a label to this view for laying out in a `Form`
    /// - Parameter view: the label view to use
    /// - Returns: an `HStack` with an alignment guide for placing in a form
    func formLabel<V: View>(_ view: V) -> some View {
        HStack {
            view
            self
                .alignmentGuide(.controlAlignment) { $0[.leading] }
        }
        .alignmentGuide(.leading) { $0[.controlAlignment] }
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
