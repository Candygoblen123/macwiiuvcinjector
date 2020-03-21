//
//  main.swift
//  injector
//
//  Created by Andrew Glaze on 3/11/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation
import ArgumentParser

struct Inject: ParsableCommand {
    @Argument(help: "The console you are injectong into (e.g. snes, wii, gamecube)")
    var console: Console
    
    @Option(name: .long, help: "The title id of the game you are injecting into.")
    var titleId: String
    
    @Option(name: .long, help: "The title key of the game you are injecting into.")
    var titleKey: String
    
    @Option(name: .shortAndLong, help: "The name of the final injected game.")
    var name: String
    
    @Option(name: .shortAndLong, help: "A iconTex.png file that will be the icon of the injected game")
    var iconTex: String
    
    @Option(name: .shortAndLong, help: "A bootTvTex.png file that will be the loading screen of the injected game")
    var bootTvTex: String
    
    @Option(name: .shortAndLong, help: "The rom file of the game that you are injecting.")
    var rom: String

    func run() throws {
        let filem = FileManager()
        
        try? filem.removeItem(atPath: String(filem.temporaryDirectory.path) + "/jnustoolBase")
        try? filem.removeItem(atPath: String(filem.temporaryDirectory.path) + "/wit")
        
        let applicationSupportDir = String(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.path) + "/macwiiuvcinjector/"
        
        if !filem.fileExists(atPath: "\(applicationSupportDir)/commonKey"){
            print("Please enter the wii u common key")
            let commonKey = readLine()!
            CommonKeyManager().saveCommonKey(commonKey: commonKey)
        }
        
        if !filem.fileExists(atPath: iconTex){
            print("Error: icon file does not exist.")
            Self.exit(withError: InjectorError.noIcon)
        }
        
        if !filem.fileExists(atPath: bootTvTex){
            print("Error: boot-tv file does not exist.")
            Self.exit(withError: InjectorError.noBootTv)
        }
        
        if !filem.fileExists(atPath: rom){
            print("Error: rom file does not exist.")
            Self.exit(withError: InjectorError.noRom)
        }
        
        if console == Console(rawValue: "snes"){
            do{
                if try SnesInjector().inject(rom: rom, iconTex: iconTex, bootTvTex: bootTvTex, titleId: titleId, titleKey: titleKey, name: name) {
                    Self.exit()
                }
            }
            
        }
        if console == Console(rawValue: "wii"){
            do{
                if try WiiInjector().inject(rom: rom, iconTex: iconTex, bootTvTex: bootTvTex, titleId: titleId, titleKey: titleKey, name: name) {
                    Self.exit()
                }
            }
        }
        if console == Console(rawValue: "gamecube"){
            do{
                if try GcInjector().inject(rom: rom, iconTex: iconTex, bootTvTex: bootTvTex, titleId: titleId, titleKey: titleKey, name: name) {
                    Self.exit()
                }
            }
        }
    }
}

class CommonKeyManager {
    let filem = FileManager()
    var applicationSupportDir = String(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.path) + "/macwiiuvcinjector/"
    
    func saveCommonKey(commonKey: String){
        // Saves the common key to all places it is required, as well as configure appsupport dir and working dirs for
        if filem.fileExists(atPath: "\(applicationSupportDir)/commonKey") || filem.fileExists(atPath: "\(applicationSupportDir)/jnustool/") || filem.fileExists(atPath: "\(applicationSupportDir)/nuspacker/"){
            do {
                try filem.removeItem(atPath: "\(applicationSupportDir)/commonKey")
                try filem.removeItem(atPath: "\(applicationSupportDir)/jnustool/")
                try filem.removeItem(atPath: "\(applicationSupportDir)/nuspacker/")
            }catch {
                print("Unable to delete common Key Files")
            }
        }
        
        // create working dirs
        do {
            try filem.createDirectory(atPath: "\(applicationSupportDir)/jnustool/", withIntermediateDirectories: true)
            try filem.createDirectory(atPath: "\(applicationSupportDir)/nuspacker/", withIntermediateDirectories: true)
        } catch {
            print("Could not create jnustool and nuspacker directory.")
        }
        
        //write the common key to a file and store it & do the same for nuspacker's encryptKeyWith
        let commonKeyData: Data? = commonKey.data(using: .utf8)
        filem.createFile(atPath: "\(applicationSupportDir)/commonKey", contents: commonKeyData)
        filem.createFile(atPath: "\(applicationSupportDir)/nuspacker/encryptKeyWith", contents: commonKeyData)
        
        // write the jnustool config to a file with the common key in it and save it to a jnustool working dir
        let config: Data? = """
        http://ccs.cdn.wup.shop.nintendo.net/ccs/download
        \(commonKey)
        updatetitles.csv
        https://tagaya.wup.shop.nintendo.net/tagaya/versionlist/EUR/EU/latest_version
        https://tagaya-wup.cdn.nintendo.net/tagaya/versionlist/EUR/EU/list/%d.versionlist
        """.data(using: .utf8)
        filem.createFile(atPath: "\(applicationSupportDir)/jnustool/config", contents: config)
        
        // copy updatetitles.csv to the jnustool workingdir
        do {
            try filem.copyItem(atPath: Bundle.main.resourcePath! + "/tools/jnustool/updatetitles.csv", toPath: "\(applicationSupportDir)/jnustool/updatetitles.csv")
        } catch {
            print("updatetitles.csv not copied to jnustool directory")
        }
        
            
    }
    
}

enum Console: String, ExpressibleByArgument {
    case snes, wii, gamecube
}

enum InjectorError: Error {
    case noRom
    case noOutDirectory
    case noJnustoolDownload
    case noXml
    case noIcon
    case noBootTv
    case noOutput
}

print(Bundle.main.resourcePath!)

Inject.main()
