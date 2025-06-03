//
//  WindowController.swift
//  Little Note
//
//  Created by Kevin Chromik on 22.05.25.
//

import SwiftUI
import AppKit

class WindowsController {
    
    private var windowControllers: [String: WindowController] = [:]
    
    func show<V: View>(
        view: V,
        for identifier: String
    ) {
        if let controller = windowControllers[identifier] {
            controller.bringForward()
            return
        }
        
        let windowController = WindowController()
        windowControllers[identifier] = windowController
        
        windowController.show(view: view) { [weak self] in
            guard let self else { return }
            self.windowControllers.removeValue(forKey: identifier)
        }
    }
}

class WindowController {

    private var window: NSWindow?
    private var onClose: (() -> Void)?

    /// Shows a window with the given SwiftUI content
    func show<V: View>(
        view: V,
        allowResize: Bool = true,
        onClose: (() -> Void)? = nil
    ) {
        if let window {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        self.onClose = onClose
        let hostingController = NSHostingController(rootView: view)

        // Determine initial size from the SwiftUI view's ideal size
        let size = hostingController.view.intrinsicContentSize
        let width = max(size.width, 300)
        let height = max(size.height, 200)

        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            .resizable
        ]

        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
            styleMask: styleMask,
            backing: .buffered,
            defer: false
        )

        let customToolbar = NSToolbar()
        customToolbar.showsBaselineSeparator = false
        newWindow.titlebarAppearsTransparent = true
        newWindow.titleVisibility = .hidden
        newWindow.toolbar = customToolbar

        newWindow.contentViewController = hostingController
        newWindow.isReleasedWhenClosed = false
        newWindow.minSize = NSSize(width: 300, height: 200)
        newWindow.maxSize = NSSize(width: 1920, height: 1080)
        newWindow.center()

        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        self.window = newWindow

        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: newWindow,
            queue: .main
        ) { [weak self] _ in
            self?.onClose?()
            self?.window = nil
        }
    }

    func bringForward() {
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
