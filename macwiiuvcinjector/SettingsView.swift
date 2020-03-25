//
//  SettingsView.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/13/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    let settings = SettingsManager()
    @State var tmpCommonKey = ""
    @State var commonKey = ""
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Please enter the Wii U Common Key:")
            Text("(If you have already done this, you will not need to do it again.)")
            TextField("\(commonKey)", text: $tmpCommonKey)
        }.padding().onAppear(perform: {
            self.commonKey = self.settings.loadCommonKey()
            
        }).onDisappear(perform: {
            if self.tmpCommonKey != "" {
                self.settings.saveCommonKey(commonKey: self.tmpCommonKey)
            }
            
        })
    }
}

class SettingsManager {
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
    
    
    func loadCommonKey() -> String{
        // load the common key as a string and return it so that it can be used as a var
        if let commonKeyData = filem.contents(atPath: "\(AppDelegate().applicationSupportDir)/commonKey") {
            let commonKeyString: String = String(data: commonKeyData, encoding: String.Encoding.utf8) ?? ""
            return commonKeyString
        }
        return "Please enter the Wii U common Key"
    }
    
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
