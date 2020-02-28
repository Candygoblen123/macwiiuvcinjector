//
//  GetFile.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/11/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation
import SwiftUI

class GetFile {
    func browseFile() -> String {
        let dialog = NSOpenPanel()
        
        dialog.title = "Choose a file:"
        dialog.showsResizeIndicator = false
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.canChooseFiles = true
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK){
            let result = dialog.url
            
            if (result != nil) {
                return result!.path
            }
        }
        return ""
    }
    
    func saveFile(name: String) -> String {
        let dialog = NSSavePanel()
        
        dialog.title = "Choose a save location:"
        dialog.showsResizeIndicator = false
        dialog.showsHiddenFiles = false
        dialog.canCreateDirectories = true
        dialog.nameFieldStringValue = name
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK){
            let result = dialog.url
            
            if (result != nil) {
                return result!.path
            }
        }
        return ""
    }
}
