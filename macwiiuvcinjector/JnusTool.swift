//
//  JnusTool.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/12/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation

struct JnusTool {
    
    let filem = FileManager()
    let jar = Bundle.main.resourcePath! + "/tools/jnustool/JNUSTool.jar"
    var applicationSupportDir = String(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.path) + "/macwiiuvcinjector/"
    
    func get(titleId: String, titleKey: String, console: String? = nil) -> String {
        let java = Process()
        let java1 = Process()
        let java2 = Process()
        // Lets us download decrypted game files from nintendo's servers with a titleid and titleKey
        // the tool is ran with java, so we set up a java process here
        java.executableURL = URL(fileURLWithPath: "/usr/bin/java")
        java1.executableURL = URL(fileURLWithPath: "/usr/bin/java")
        java2.executableURL = URL(fileURLWithPath: "/usr/bin/java")
        // set arguements to download the entire base
        if console == nil {
            java.arguments = ["-jar", self.jar, titleId, titleKey, "-file", ".*"]
        }
        if console == "wii" || console == "gamecube" {
            java.arguments = ["-jar", self.jar, titleId, titleKey, "-file", "/code/.*"]
            java1.arguments = ["-jar", self.jar, titleId, titleKey, "-file", "/content/assets/.*"]
            java2.arguments = ["-jar", self.jar, titleId, titleKey, "-file", "/meta/.*"]
        }
        // Jnustool requires the current directory to be the one with the config file
        java.currentDirectoryPath = "\(applicationSupportDir)/jnustool/"
        java1.currentDirectoryPath = "\(applicationSupportDir)/jnustool/"
        java2.currentDirectoryPath = "\(applicationSupportDir)/jnustool/"
        
        do {
            // try running java
            try java.run()
            
            //wait until jnustool is done downloading the files
            java.waitUntilExit()
            if console == "wii" || console == "gamecube" {
                try java1.run()
                java1.waitUntilExit()
                try java2.run()
                java2.waitUntilExit()
            }

        } catch {
            print(error)
        }
        
        // Find the downdloaded game files, located in a foleder with the games name, a.k.a completely random as far as we know
        var base :String = "\(applicationSupportDir)/jnustool/"
        
        do {
            let contents = (try filem.contentsOfDirectory(atPath: "\(applicationSupportDir)/jnustool/"))
            for content in contents {
                if !(content == ".DS_Store" || content == "updatetitles.csv" || content == "config") {
                    base += content
                }
            }
            //move item to a system tmp directory
            try filem.moveItem(atPath: base, toPath: String(filem.temporaryDirectory.path) + "/jnustoolBase")
            base = String(filem.temporaryDirectory.path) + "/jnustoolBase"
        }catch {
            print(error)
        }
        
        // returns the path of the base game
        return base
        
    }
}
