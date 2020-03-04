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
    // a variable that gives the appiclation support directory for the user
    @State var applicationSupportDir = String(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.path) + "/macwiiuvcinjector/"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // delete a downloaded base, if it exists
        try? filem.removeItem(atPath: String(filem.temporaryDirectory.path) + "/jnustoolBase")
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 10000, height: 5000),
            styleMask: [.titled, .closable, .miniaturizable,  .fullSizeContentView, .resizable],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Injector")
        let settings = SettingsManager()
        window.contentView = NSHostingView(rootView: contentView.environmentObject(settings))
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    
}

