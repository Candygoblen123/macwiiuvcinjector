//
//  SettingsView.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/13/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsManager
    @State var tmpCommonKey = ""
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Please enter the Wii U Common Key:")
            Text("(If you have already done this, you will not need to do it again.)")
            HStack{
                TextField("\(settings.commonKey)", text: $tmpCommonKey)
                Button(action: {
                    self.settings.commonKey = self.tmpCommonKey
                    self.settings.saveCommonKey()
                }){
                    Text("Save")
                }
            }
        }.padding().onAppear(perform: settings.loadCommonKey)
    }
}

class SettingsManager: ObservableObject {
    @Published var commonKey: String = "Wii U Common Key"
    let filem = FileManager()
    
    func saveCommonKey(){
        // Saves the common key to all places it is required, as well as configure appsupport dir and working dirs for
        if filem.fileExists(atPath: "commonKey") || filem.fileExists(atPath: "jnustool/") || filem.fileExists(atPath: "nuspacker/"){
            do {
                try filem.removeItem(atPath: "\(AppDelegate().applicationSupportDir)/commonKey")
                try filem.removeItem(atPath: "\(AppDelegate().applicationSupportDir)/jnustool/")
                try filem.removeItem(atPath: "\(AppDelegate().applicationSupportDir)/nuspacker/")
            }catch {
                print("Unable to delete common Key Files")
            }
        }
        
        // create working dirs
        do {
            try filem.createDirectory(atPath: "\(AppDelegate().applicationSupportDir)/jnustool/", withIntermediateDirectories: true)
            try filem.createDirectory(atPath: "\(AppDelegate().applicationSupportDir)/nuspacker/", withIntermediateDirectories: true)
        } catch {
            print("Could not create jnustool and nuspacker directory.")
        }
        
        //write the common key to a file and store it & do the same for nuspacker's encryptKeyWith
        let commonKeyData: Data? = commonKey.data(using: .utf8)
        filem.createFile(atPath: "\(AppDelegate().applicationSupportDir)/commonKey", contents: commonKeyData)
        filem.createFile(atPath: "\(AppDelegate().applicationSupportDir)/nuspacker/encryptKeyWith", contents: commonKeyData)
        
        // write the jnustool config to a file with the common key in it and save it to a jnustool working dir
        let config: Data? = """
        http://ccs.cdn.wup.shop.nintendo.net/ccs/download
        \(commonKey)
        updatetitles.csv
        https://tagaya.wup.shop.nintendo.net/tagaya/versionlist/EUR/EU/latest_version
        https://tagaya-wup.cdn.nintendo.net/tagaya/versionlist/EUR/EU/list/%d.versionlist
        """.data(using: .utf8)
        filem.createFile(atPath: "\(AppDelegate().applicationSupportDir)/jnustool/config", contents: config)
        
        // copy updatetitles.csv to the jnustool workingdir
        do {
            try filem.copyItem(atPath: Bundle.main.resourcePath! + "/jnustool/updatetitles.csv", toPath: "\(AppDelegate().applicationSupportDir)/jnustool/updatetitles.csv")
        } catch {
            print("updatetitles.csv not copied to jnustool directory")
        }
        
            
    }
    
    
    func loadCommonKey() {
        // load the common key as a string and return it so that it can be used as a var
        guard let commonKeyData = filem.contents(atPath: "\(AppDelegate().applicationSupportDir)/commonKey") else { return }
        let commonKeyString: String = String(data: commonKeyData, encoding: String.Encoding.utf8) ?? ""
        self.commonKey = commonKeyString
    }
    
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
