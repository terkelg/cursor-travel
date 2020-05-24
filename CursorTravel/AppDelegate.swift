//
//  AppDelegate.swift
//  CursorTravel
//
//  Created by Terkel on 5/15/20.
//  Copyright © 2020 Terkel.com. All rights reserved.
//

// MARK: TODO
// - [ ] Fix start on startup

import Cocoa
import SwiftUI
import Combine
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    let mouseData = Mouse()
    let popover = NSPopover()
    
    private var cancellableDistance: AnyCancellable?
    private var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initStatusItem()
        initPopover()
        
        cancellableDistance = mouseData.objectWillChange.sink(receiveValue: { item in
            self.statusItem.button?.title = self.mouseData.formatted()
        })
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { event in
            self.togglePopover(nil)
        }
        
        // Launcher
        let launcherAppId = "com.terkel.LauncherApplication"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty

        SMLoginItemSetEnabled(launcherAppId as CFString, true)

        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        mouseData.stop()
        mouseData.save()
        eventMonitor?.stop()
    }
    
    // MARK: Handlers
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusItem.button {
            if popover.isShown {
                eventMonitor?.stop()
                popover.performClose(sender)
            } else {
                eventMonitor?.start()
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    // MARK: Init
    
    func initStatusItem() {
        if let button = statusItem.button {
            button.title = mouseData.formatted()
            button.font = NSFont.monospacedDigitSystemFont(ofSize: 14.0, weight: .regular)
            button.action = #selector(togglePopover(_:))
        }
    }
    
    func initPopover() {
        let contentView = ContentView().environmentObject(mouseData)
        popover.behavior = .applicationDefined
        popover.contentViewController = NSHostingController(rootView: contentView)
    }
}

// MARK: - Extensions

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}
