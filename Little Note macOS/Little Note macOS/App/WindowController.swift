//
//  WindowController.swift
//  Little Note
//
//  Created by Kevin Chromik on 22.05.25.
//

import SwiftUI
import AppKit

class WindowController {

    private var window: NSWindow?

    /// Shows a window with the given SwiftUI content
    func show<V: View>(
        view: V,
        title: String = "",
        allowResize: Bool = true
    ) {
        if let existingWindow = window {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let hostingController = NSHostingController(rootView: view)

        // Determine initial size from the SwiftUI view's ideal size
        let size = hostingController.view.intrinsicContentSize
        let width = max(size.width, 300)
        let height = max(size.height, 200)

        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            allowResize ? .resizable : []
        ]

        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
            styleMask: styleMask,
            backing: .buffered,
            defer: false
        )

        newWindow.contentViewController = hostingController
        newWindow.title = title
        newWindow.isReleasedWhenClosed = false
        newWindow.center()

        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        self.window = newWindow

        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: newWindow,
            queue: .main
        ) { [weak self] _ in
            self?.window = nil
        }
    }
}
