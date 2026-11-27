//
//  CloudKitSyncMonitor.swift
//  LittleBase
//
//  Created by Kevin Chromik on 08.12.24.
//

import Foundation
import SwiftData
import CoreData
import os
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

private let logger = Logger(subsystem: "com.kchromik.littlenote", category: "CloudKitSync")

/// Monitors CloudKit sync events, ensures data is saved before lifecycle transitions,
/// and keeps SwiftUI views up-to-date with remote changes.
@MainActor
@Observable
public final class CloudKitSyncMonitor {
    /// Timestamp of the last detected remote sync event
    public private(set) var lastSyncDate: Date?

    @ObservationIgnored
    private var observers: [NSObjectProtocol] = []

    @ObservationIgnored
    private let modelContainer: ModelContainer

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        setupObservers()
        logger.info("CloudKitSyncMonitor initialized")
    }

    private func setupObservers() {
        // Listen for remote CloudKit changes merged into the persistent store
        let remoteChangeObserver = NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleRemoteChange()
            }
        }
        observers.append(remoteChangeObserver)

        #if os(iOS)
        // Save pending changes when app enters background
        let backgroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.saveIfNeeded()
            }
        }
        observers.append(backgroundObserver)
        #endif

        #if os(macOS)
        // Save pending changes when app loses focus
        let resignObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.saveIfNeeded()
            }
        }
        observers.append(resignObserver)
        #endif
    }

    private func handleRemoteChange() {
        lastSyncDate = Date()
        logger.debug("Remote CloudKit change detected")
    }

    /// Explicitly save any unsaved changes to trigger CloudKit sync
    public func saveIfNeeded() {
        let context = modelContainer.mainContext
        guard context.hasChanges else { return }
        do {
            try context.save()
            logger.debug("Saved pending changes on lifecycle event")
        } catch {
            logger.error("Failed to save on lifecycle event: \(error.localizedDescription)")
        }
    }

    deinit {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
