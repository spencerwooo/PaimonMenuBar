//
//  ContentView.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/23.
//

import Defaults
import LaunchAtLogin
import SwiftUI
import UserNotifications

// This additional view is needed for the disabled state on the menu item to work properly before Monterey.
// See https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug for more information
struct CheckForUpdatesView: View {
    @ObservedObject var updaterViewModel: UpdaterViewModel

    var body: some View {
        Button("Check for Updates", action: updaterViewModel.checkForUpdates)
            .disabled(!updaterViewModel.canCheckForUpdates)
    }
}

struct PreferenceSettingsView: View {
    @Default(.recordUpdateInterval) private var recordUpdateInterval
    @Default(.isStatusIconTemplate) private var isStatusIconTemplate
    @Default(.isNotifyParametricReady) private var isNotifyParametricReady

    @StateObject var updaterViewModel = UpdaterViewModel.shared

    @State private var isEditing = false

    var body: some View {
        VStack(spacing: 20) {
            Form {
                LaunchAtLogin.Toggle {
                    Text("Launch at Login")
                }
                .formLabel(Text("Start:"))

                CheckForUpdatesView(updaterViewModel: updaterViewModel)
                    .formLabel(Text("Updates:"))
                Text("Current version: \(Bundle.main.appVersion ?? "") (\(Bundle.main.buildNumber ?? ""))")
                    .font(.caption).opacity(0.6)

                Defaults.Toggle(key: .isStatusIconTemplate) {
                    Image("FragileResin")
                        .renderingMode(isStatusIconTemplate ? .template : .original)
                        .frame(width: 19, height: 19)
                }
                .onChange { _ in
                    AppDelegate.shared.updateStatusIcon()
                }
                .formLabel(Text("Menubar icon:"))
                Text(isStatusIconTemplate ? "Native macOS adaptive icon." : "Colored icon.").font(.caption).opacity(0.6)

                Defaults.Toggle(key: .isNotifyParametricReady) {
                    Image(
                        systemName: isNotifyParametricReady ? "bell.badge" : "bell.slash"
                    )
                }
                .formLabel(Text("Notify:"))
                Text("... when parametric transformer is ready.").font(.caption).opacity(0.6)

                Slider(value: $recordUpdateInterval, in: 60 ... 16 * 60, step: 60, label: {
                    Text("Update interval:")
                }) { editing in
                    isEditing = editing
                }
                .frame(width: 360)

                Text("Paimon fetches data every \(recordUpdateInterval, specifier: "%.0f") seconds*")
                    .font(.caption).opacity(0.6)
            }

            Divider()

            Label("*Resin replenishes every 8 minutes, for your reference.", image: "FragileResin")
                .font(.caption)
                .opacity(0.6)
        }
    }
}

struct ConfigurationSettingsView: View {
    @Default(.uid) private var uid
    @Default(.server) private var server
    @Default(.cookie) private var cookie

    @State private var alertText = ""
    @State private var alertMessage = ""
    @State private var showConfigValidAlert = false

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
                        Text(value.serverName).tag(value)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }.padding([.bottom])

            Text("Cookie")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text("Paste your cookie from:")
                    .font(.subheadline)
                Link(destination: URL(string: server.cookieSiteUrl)!) {
                    Text(server.cookieSiteUrl)
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $cookie)
                .font(.system(.body, design: .monospaced))
                .frame(height: 88)

            Spacer()

            HStack {
                Spacer()
                Button {
                    GameRecordUpdater.shared.clearGameRecord()
                    Task {
                        isLoading = true
                        if let _ = await GameRecordUpdater.shared.fetchGameRecordAndRenderNow() {
                            self.alertText = String.localized("👌 It's working!")
                            self.alertMessage = String.localized("Your config is valid.")
                        } else {
                            self.alertText = String.localized("🚫 Whoooops...")
                            self.alertMessage = String.localized("Failed to fetch, check your config.")
                        }
                        self.showConfigValidAlert.toggle()
                        isLoading = false
                    }
                } label: {
                    Label {
                        Text("Test config")
                    } icon: {
                        Image(systemName: "bolt")
                            .opacity(isLoading ? 0 : 1)
                            .overlay(isLoading ? ProgressView().scaleEffect(0.4) : nil)
                    }
                }
                .alert(isPresented: self.$showConfigValidAlert, content: {
                    Alert(title: Text(alertText), message: Text(alertMessage))
                })
                .disabled(isLoading)

                Link(destination: URL(string: "https://paimon.swo.moe/#how-to-get-my-cookie")!) {
                    Button("?") {
                        print("Navigating to help page.")
                    }.clipShape(Circle()).shadow(radius: 1)
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

            Text(
                "Made with love @ [SpencerWoo](https://spencerwoo.com) | Check [Paimon's website](https://paimon.swo.moe)"
            )
            .font(.system(.caption, design: .monospaced))
            Text(
                "Icon by [Chawong](https://www.pixiv.net/en/artworks/92415888) | GitHub: [spencerwooo/PaimonMenuBar](https://github.com/spencerwooo/PaimonMenuBar)"
            )
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
        .frame(width: 560, height: 360)
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
