//
//  AppDelegate.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/10/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
            styleMask: [.titled, .closable, .miniaturizable,  .fullSizeContentView, .resizable],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Injector")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}

