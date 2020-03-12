//
//  NusPacker.swift
//  macwiiuvcinjector
//
//  Created by Andrew Glaze on 2/28/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation

struct NusPacker {
    
    let filem = FileManager()
    let jar = Bundle.main.resourcePath! + "/nuspacker/NUSPacker.jar"
    var applicationSupportDir = String(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.path) + "/macwiiuvcinjector/"
    func pack(base: String, outputDir: String){
        let java = Process()
        do {
            try filem.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        }catch {
            print("Could not create output directory")
        }
        
        java.executableURL = URL(fileURLWithPath: "/usr/bin/java")
        java.arguments = ["-jar", jar, "-in", base, "-out", outputDir]
        java.currentDirectoryPath = "\(applicationSupportDir)/nuspacker/"
        
        do {
            try java.run()
        }catch {
            print(error)
        }
        
        java.waitUntilExit()
        
        
    }
}
