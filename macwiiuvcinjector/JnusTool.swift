//
//  JnusTool.swift
//  macwiiuvcinjector
//
//  Created by Andrew Glaze on 2/12/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation

struct JnusTool {
    let java = Process()
    let file = FileManager()
    let jar = Bundle.main.resourcePath! + "/jnustool/JNUSTool.jar"
    let settings = SettingsManager()

    
    func get(titleId: String, titleKey: String) {
        
        print(file.currentDirectoryPath)
        
        java.executableURL = URL(fileURLWithPath: "/usr/bin/java")
        java.arguments = ["-jar", self.jar, titleId, titleKey, "-file", ".*"]
        //java.arguments = ["--version"]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        java.standardOutput = outputPipe
        java.standardError = errorPipe
        
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()

        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) {
            notification in
            let output = outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
            print(outputString)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: errorPipe.fileHandleForReading , queue: nil) {
            notification in
            let error = errorPipe.fileHandleForReading.availableData
            let errorString = String(data: error, encoding: String.Encoding.utf8) ?? ""
            print(errorString)
        }
        
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        errorPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        file.changeCurrentDirectoryPath("jnustool/")
        
        do {
            try java.run()
        } catch {
            print(error)
        }
        
        
        
        /*
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        let output = String(decoding: outputData, as: UTF8.self)
        let error = String(decoding: errorData, as: UTF8.self)
        
        print(output)
        print(error)
        */
        
        
    }
}
