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
    let jar = Bundle.main.resourcePath! + "/jnustool/JNUSTool.jar"
    
    func get(titleId: String, titleKey: String) -> String {
        let java = Process()
        // Lets us download decrypted game files from nintendo's servers with a titleid and titleKey
        // the tool is ran with java, so we set up a java process here
        java.executableURL = URL(fileURLWithPath: "/usr/bin/java")
        java.arguments = ["-jar", self.jar, titleId, titleKey, "-file", ".*"]
        //java.arguments = ["--version"]
        
        // Jnustool requires the current directory to be the one with the config file
        java.currentDirectoryPath = "\(AppDelegate().applicationSupportDir)/jnustool/"
        
        do {
            try java.run()
        } catch {
            print(error)
        }
        
        java.waitUntilExit()
        
        java.terminate()
        
        //print("java done now")
        
        var base :String = "\(AppDelegate().applicationSupportDir)/jnustool/"
        
        // Find the downdloaded game files, located in a foledr with the games name, a.k.a completely random as far as we care
        
        do {
            let contents = (try filem.contentsOfDirectory(atPath: "\(AppDelegate().applicationSupportDir)/jnustool/"))
            for content in contents {
                if !(content == ".DS_Store" || content == "updatetitles.csv" || content == "config") {
                    base += content
                }
            }
        }catch {
            print("could not get contents of jnustool directory")
        }
            
        // returns the path of the base game
        return base
        
    }
}
