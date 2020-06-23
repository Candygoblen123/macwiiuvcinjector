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
        try? filem.removeItem(atPath: String(filem.temporaryDirectory.path) + "/wit")
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 720, height: 373),
            styleMask: [.titled, .closable, .miniaturizable,  .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Injector")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    
}


enum InjectorError: Error {
    case noOutDirectory
    case noJnustoolDownload
    case noXml
    case noIcon
    case noOutput
    case noJava
}
