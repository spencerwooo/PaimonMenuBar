//
//  UpdaterViewModel.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/31.
//

import Foundation
import Sparkle

final class UpdaterViewModel: ObservableObject {
    private let updaterController: SPUStandardUpdaterController
    static let shared = UpdaterViewModel()

    @Published var canCheckForUpdates = false

    init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )

        updaterController.updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
    }

    func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }
}
