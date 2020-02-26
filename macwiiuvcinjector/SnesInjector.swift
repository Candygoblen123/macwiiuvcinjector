//
//  SnesInjector.swift
//  macwiiuvcinjector
//
//  Created by Andrew Glaze on 2/12/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation

struct SnesInjector {
    let file = GetFile()
    let jnustool = JnusTool()
    let filem = FileManager()
    
    func inject(rom: String, iconTex: String, tvTex: String, titleId: String, titleKey: String){
        //let user define the output directory for final installable files
        let outputDir = file.saveFile() + "/"
        
        let base = jnustool.get(titleId: titleId, titleKey: titleKey)
        
        // attempt to find the .rpx file in the code folder
        var rpxFile :String = ""
        
        do {
            let contents = (try filem.contentsOfDirectory(atPath: base + "/code/"))
            for content in contents {
                if !(content == "app.xml" || content == "cos.xml" || content == "preload.txt" || content == "in.elf" || content == "out.elf") {
                    rpxFile = content
                }
            }
        }catch {
            print("could not get contents of jnustool directory")
        }
        
        print(rpxFile)
        
        // Decompress the .rpx file into an .elf file, so that we can edit the contents
        let wiiurpxtool = Process()
        
        wiiurpxtool.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/wiiurpxtool")
        
        wiiurpxtool.arguments = [ "-d", "\(base)/code/\(rpxFile)", "\(base)/code/in.elf"]
        
        do {
            try wiiurpxtool.run()
        } catch {
            print(error)
        }
        
        wiiurpxtool.waitUntilExit()
        
        print("wiiurpxtool done 1")
        
        wiiurpxtool.terminate()
        
        // Set up a retroinject process to inject the rom into the decompressed "in.elf" file
        let retroinject = Process()
        
        retroinject.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/retroinject")
        
        retroinject.arguments = ["\(base)/code/in.elf", rom, "\(base)/code/out.elf"]
        
        //print(retroinject.arguments)
        
        do{
            try retroinject.run()
        }catch {
            print(error)
        }
        
        retroinject.waitUntilExit()
        
        print("retroinject done")
        
        retroinject.terminate()
        
        // run wiiurpxtool again to compress the modified .elf file into a .rpx file
        let wiiurpxtool2 = Process()
        
        wiiurpxtool2.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/wiiurpxtool")
        wiiurpxtool2.arguments = [ "-c", "\(base)/code/out.elf", "\(base)/code/\(rpxFile)"]
        
        //print(wiiurpxtool2.arguments)
        
        do {
            try wiiurpxtool2.run()
        } catch {
            print(error)
        }
        
        wiiurpxtool2.waitUntilExit()
        
        print("wiiurpxtool done 2")
        
        wiiurpxtool2.terminate()
        
        //cleanup tempaory .elf files
        do {
            try filem.removeItem(atPath: "\(base)/code/in.elf")
            try filem.removeItem(atPath: "\(base)/code/out.elf")
        }catch {
            print("could not delete .elf files")
        }
        
        let newTitleId = ("00050000" + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10))).data(using: .utf8)!
        
        var appXml = filem.contents(atPath: "\(base)/code/app.xml")
        appXml?.replaceSubrange(242...257, with: newTitleId)
        
        
        
    }
}
