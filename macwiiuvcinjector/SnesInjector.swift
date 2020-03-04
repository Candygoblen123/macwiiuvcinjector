//
//  SnesInjector.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/12/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation

struct SnesInjector {
    let file = GetFile()
    let jnustool = JnusTool()
    let filem = FileManager()
    
    func inject(rom: String, iconTex: String, bootTvTex: String, titleId: String, titleKey: String, name: String) throws -> Bool {
        //let user define the output directory for final installable files
        let outputDir = file.saveFile(name: name) + "/"
        
        if outputDir == "/" {
            throw SnesInjectorError.noOutDirectory
        }
        
        let base = jnustool.get(titleId: titleId, titleKey: titleKey)
        
        if base == "\(AppDelegate().applicationSupportDir)/jnustool/" {
            throw SnesInjectorError.noJnustoolDownload
        }
        
        
        
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
        
        // Replace xml files with our own
        XmlHandler().appXml(base: base)
        XmlHandler().metaXml(base: base, name: name)
        
        if !(filem.fileExists(atPath: "\(base)/code/app.xml") || filem.fileExists(atPath: "\(base)/meta/meta.xml")) {
            throw SnesInjectorError.noXml
        }
        
        // replace the icon and bootscreens with the ones provided by the user
        ImageHandler().icon(iconTex: iconTex, base: base)
        ImageHandler().bootTv(bootTvTex: bootTvTex, base: base)
        
        if !(filem.fileExists(atPath: "\(base)/meta/icon.xml") || filem.fileExists(atPath: "\(base)/meta/bootTvTex.tga") || filem.fileExists(atPath: "\(base)/meta/bootDrcTex.tga")) {
            throw SnesInjectorError.noIcon
        }
        
        //package and encrypt the game for installation 
        NusPacker().pack(base: base, outputDir: outputDir)
        
        if try! filem.contentsOfDirectory(atPath: base) == [] {
            throw SnesInjectorError.noOutput
        }
        
        // delete the base folder
        do {
            try filem.removeItem(atPath: base)
        } catch {
            print("Could not delete the base folder.")
        }
        
        return true
    }
}

enum SnesInjectorError: Error {
    case noOutDirectory
    case noJnustoolDownload
    case noXml
    case noIcon
    case noOutput
}
