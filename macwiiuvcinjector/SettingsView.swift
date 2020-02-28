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
    let file = FileManager()
    
    func saveCommonKey(){
        if file.fileExists(atPath: "commonKey") || file.fileExists(atPath: "jnustool/"){
            do {
                try file.removeItem(atPath: "commonKey")
                try file.removeItem(atPath: "jnustool/")
            }catch {
                print("Unable to delete commonKeyFiles")
            }
        }
        
        let commonKeyData: Data? = commonKey.data(using: .utf8)
        file.createFile(atPath: "commonKey", contents: commonKeyData)
        
        do {
            try file.createDirectory(atPath: "jnustool/", withIntermediateDirectories: true)
        } catch {
            print("Could not create jnustool directory.")
        }
        
        let config: Data? = """
        http://ccs.cdn.wup.shop.nintendo.net/ccs/download
        \(commonKey)
        updatetitles.csv
        https://tagaya.wup.shop.nintendo.net/tagaya/versionlist/EUR/EU/latest_version
        https://tagaya-wup.cdn.nintendo.net/tagaya/versionlist/EUR/EU/list/%d.versionlist
        """.data(using: .utf8)
            
        file.createFile(atPath: "jnustool/config", contents: config)
        
        do {
            try file.copyItem(atPath: Bundle.main.resourcePath! + "/jnustool/updatetitles.csv", toPath: "jnustool/updatetitles.csv")
        } catch {
            print("updatetitles.csv not copied to jnustool directory")
        }
        
            
    }
    
    func loadCommonKey() {
        guard let commonKeyData = file.contents(atPath: "commonKey") else { return  }
        let commonKeyString: String = String(data: commonKeyData, encoding: String.Encoding.utf8) ?? ""
        self.commonKey = commonKeyString
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
