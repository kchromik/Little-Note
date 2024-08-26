//
//  SettingsViewModel.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 26.08.24.
//

import Foundation

class SettingsViewModel: ObservableObject {

    var versionString: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
    }

}
