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

        let initialSize = NSSize(width: 400, height: 300)

        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            .miniaturizable,
            .resizable
        ]

        let newWindow = NSWindow(
            contentRect: NSRect(origin: .zero, size: initialSize),
            styleMask: styleMask,
            backing: .buffered,
            defer: false
        )

        // Optional toolbar styling
        let customToolbar = NSToolbar()
        customToolbar.showsBaselineSeparator = false
        newWindow.titlebarAppearsTransparent = true
        newWindow.titleVisibility = .hidden
        newWindow.toolbar = customToolbar

        // Embed hosting controller manually
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let contentView = NSView()
        contentView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        newWindow.contentView = contentView

        newWindow.setContentSize(initialSize)
        newWindow.minSize = NSSize(width: 400, height: 280)

        newWindow.center()
        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        newWindow.isReleasedWhenClosed = false
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
