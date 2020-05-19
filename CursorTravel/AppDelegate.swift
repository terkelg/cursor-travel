//
//  AppDelegate.swift
//  CursorTravel
//
//  Created by Terkel on 5/15/20.
//  Copyright © 2020 Terkel.com. All rights reserved.
//

// TODO:
// - [ ] Start on startup
//       https://theswiftdev.com/how-to-launch-a-macos-app-at-login/

import Cocoa
import SwiftUI
import Combine

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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        mouseData.stop()
        mouseData.save()
        eventMonitor?.stop()
    }
    
    // MARK: - Handlers
    
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
    
    // MARK: - Init
    
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

