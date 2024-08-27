//
//  SettingsViewModel.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 26.08.24.
//

import UIKit
import Foundation

@Observable
class SettingsViewModel {

    var versionString: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
    }

    func openMail() {
        if let url = supportEmailURL(),
           UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func supportEmailURL() -> URL? {
        let subject = "Little Note - Support"
        let body = "\n\nLittle Notes App Version: \(versionString)"
        let email = "support@kevinchromik.de"
        let encodedParams = "subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "mailto:\(email)?\(encodedParams)"

        return URL(string: url)
    }
}
