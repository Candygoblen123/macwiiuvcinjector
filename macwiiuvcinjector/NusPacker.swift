//
//  NusPacker.swift
//  macwiiuvcinjector
//
//  Created by Andrew Glaze on 2/28/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation

struct NusPacker {
    let java = Process()
    let filem = FileManager()
    let jar = Bundle.main.resourcePath! + "/nuspacker/NUSPacker.jar"
    func pack(base: String, outputDir: String){
        do {
            try filem.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        }catch {
            print("Could not create output directory")
        }
        
        java.executableURL = URL(fileURLWithPath: "/usr/bin/java")
        java.arguments = ["-jar", jar, "-in", base, "-out", outputDir]
        java.currentDirectoryPath = "\(AppDelegate().applicationSupportDir)/nuspacker/"
        
        do {
            try java.run()
        }catch {
            print(error)
        }
        
        java.waitUntilExit()
        
    }
}
