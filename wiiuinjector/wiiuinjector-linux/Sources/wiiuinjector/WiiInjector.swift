//
//  WiiInjector.swift
//  macwiiuvcinjector
//
//  Created by Andrew Glaze on 3/5/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation

struct WiiInjector {
    let file = GetFile()
    let jnustool = JnusTool()
    let filem = FileManager()
    
    func inject(rom: String, iconTex: String, bootTvTex: String, titleId: String, titleKey: String, name: String) throws -> Bool {
        
        //let user define the output directory for final installable files
        let outputDir = file.saveFile(name: name) + "/"
        
        if outputDir == "/" {
            throw InjectorError.noOutDirectory
        }
        
        let base = jnustool.get(titleId: titleId, titleKey: titleKey, console: "wii")
        
        if !filem.fileExists(atPath: String(filem.temporaryDirectory.path) + "/jnustoolBase") {
            throw InjectorError.noJnustoolDownload
        }
        
        do {
            for content in try filem.contentsOfDirectory(atPath: "\(base)/content") {
                if URL(fileURLWithPath: "\(base)/content" + content).pathExtension == "nfs" {
                    try filem.removeItem(atPath: "\(base)/content/" + content)
                }
            }
        }catch {
            print("could not delete .nfs files:")
        }
        
        do {
            try filem.removeItem(atPath: "\(base)/code/rvlt.tik")
            try filem.removeItem(atPath: "\(base)/code/rvlt.tmd")
        }catch {
            print("Could not delete .tik or .tmd file")
            print(error)
        }
        
        let tmpDir = filem.temporaryDirectory.path + "/wit/"
        
        do {
            try filem.createDirectory(atPath: tmpDir, withIntermediateDirectories: true)
            let wit = Process()
            wit.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/tools/wit/bin/wit")
            wit.arguments = ["extract", rom, "--DEST", tmpDir + "extracted/", "--psel", "data", "-vv1"]
            try wit.run()
            wit.waitUntilExit()
        }catch {
            print(error)
        }
        
        do {
            let wit = Process()
            wit.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/tools/wit/bin/wit")
            wit.arguments = ["copy", tmpDir + "extracted/", "--DEST", tmpDir + "game.iso", "-ovv", "--links", "--iso"]
            try wit.run()
            wit.waitUntilExit()
            try filem.removeItem(atPath: tmpDir + "extracted/")
        }catch {
            print(error)
        }
        
        do {
            let wit = Process()
            wit.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/tools/wit/bin/wit")
            wit.arguments = ["extract", tmpDir + "game.iso", "--psel", "data", "--files", "+tmd.bin", "--files", "+ticket.bin", "--dest", tmpDir + "cert/", "-vv1"]
            try wit.run()
            wit.waitUntilExit()
            try filem.moveItem(atPath: tmpDir + "cert/tmd.bin", toPath: "\(base)/code/rvlt.tmd")
            try filem.moveItem(atPath: tmpDir + "cert/ticket.bin", toPath: "\(base)/code/rvlt.tik")
            try filem.moveItem(atPath: tmpDir + "game.iso", toPath: "\(base)/content/game.iso")
            try filem.removeItem(atPath: tmpDir)
        }catch {
            print(error)
        }
        
        do {
            let nfs2iso2nfs = Process()
            nfs2iso2nfs.executableURL = URL(fileURLWithPath: "/usr/bin/mono")
            nfs2iso2nfs.arguments = [Bundle.main.resourcePath! + "/tools/nfs2iso2nfs", "-enc"]
            nfs2iso2nfs.currentDirectoryPath = "\(base)/content/"
            try nfs2iso2nfs.run()
            nfs2iso2nfs.waitUntilExit()
            try filem.removeItem(atPath: "\(base)/content/game.iso")
        }
        
        // Replace xml files with our own
        XmlHandler().appXml(base: base)
        XmlHandler().metaXml(base: base, name: name)
        
        if !(filem.fileExists(atPath: "\(base)/code/app.xml") || filem.fileExists(atPath: "\(base)/meta/meta.xml")) {
            throw InjectorError.noXml
        }
        
        // replace the icon and bootscreens with the ones provided by the user
        ImageHandler().icon(iconTex: iconTex, base: base)
        ImageHandler().bootTv(bootTvTex: bootTvTex, base: base)
        
        if !(filem.fileExists(atPath: "\(base)/meta/icon.xml") || filem.fileExists(atPath: "\(base)/meta/bootTvTex.tga") || filem.fileExists(atPath: "\(base)/meta/bootDrcTex.tga")) {
            throw InjectorError.noIcon
        }
        
        //package and encrypt the game for installation
        NusPacker().pack(base: base, outputDir: outputDir)
        
        if try! filem.contentsOfDirectory(atPath: base) == [] {
            throw InjectorError.noOutput
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
