//
//  SettingsViewModel.swift
//  Little Note
//
//  Created by Kevin Chromik on 16.02.24.
//

import ServiceManagement
import Combine
import SwiftUI

class SettingsViewModel: ObservableObject {

    @Published var launchAtLogin: Bool
    @AppStorage("remindesUser") var remindesUser: Bool = false
    @AppStorage("hotkeyEnabled") var hotkeyEnabled: Bool = true
    @AppStorage("usesLargeFont") var usesLargeFont: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.launchAtLogin = SMAppService.mainApp.status == .enabled

        $launchAtLogin
            .sink { [weak self] newValue in
                self?.setLaunchAtLogin(shouldLaunch: newValue)
            }
            .store(in: &cancellables)
    }

    private func setLaunchAtLogin(shouldLaunch: Bool) {
        do {
            try shouldLaunch ? SMAppService.mainApp.register() : SMAppService.mainApp.unregister()
        } catch {
            print(error.localizedDescription)
        }
    }
}
