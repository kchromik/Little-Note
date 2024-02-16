//
//  HotKeyViewModel.swift
//  Little Note
//
//  Created by Kevin Chromik on 16.02.24.
//

import HotKey
import SwiftUI

class HotKeyViewModel: ObservableObject {

    @AppStorage("hotkeyEnabled") var hotkeyEnabled: Bool = true
    @Published var isMenuPresented: Bool = false
    let hotkey = HotKey(key: .l, modifiers: [.control, .option, .command])

    init() {
        hotkey.keyDownHandler = { [weak self] in
            guard self?.hotkeyEnabled == true else { return }
            self?.isMenuPresented.toggle()
        }
    }
}
