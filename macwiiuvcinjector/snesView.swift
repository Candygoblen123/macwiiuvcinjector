//
//  snesView.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/10/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import SwiftUI

struct snesView: View {
    let inj = SnesInjector()
    let file = GetFile()
    @State var notFilled = false
    @State var name :String = ""
    @State var romFile :String = "Please choose a Rom File (.sfc format)"
    @State var iconTexFile :String = "Please choose an iconTex file"
    @State var tvTexFile :String = "Please choose a bootTvTex file"
    @State var titleId :String = ""
    @State var titleKey :String = ""
    @State var noCommonKey = false
    
    @Binding var injectorProgress: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Please fill out every field")
            HStack {
                Text("Rom: \(self.romFile)").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Button(action: {
                    self.romFile = self.file.browseFile()
                }){
                    Text("Select file...")
                }
            }
            HStack {
                Text("Icon: \(self.iconTexFile)").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Button(action: {
                    self.iconTexFile = self.file.browseFile()
                }){
                    Text("Select file...")
                }
            }
            HStack {
                Text("Bootscreens: \(self.tvTexFile)").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Button(action: {
                    self.tvTexFile = self.file.browseFile()
                }){
                    Text("Select file...")
                }
            }
            HStack {
                Text("Name:")
                TextField("Please enter a name for your injected game", text: $name)
            }
            HStack {
                Text("Title Id:")
                TextField("Please enter a Title Id", text: $titleId)
            }
            HStack {
                Text("Title Key:")
                TextField("Please enter a Title Key", text: $titleKey)
            }
            Button (action: {
                if self.romFile == "Please choose a Rom File (.sfc format)" || self.romFile == "" {
                    self.notFilled = true
                }else if self.iconTexFile == "Please choose an iconTex file" || self.iconTexFile == "" {
                    self.notFilled = true
                }else if self.tvTexFile == "Please choose a bootTvTex file" || self.tvTexFile == "" {
                    self.notFilled = true
                }else if self.titleId == "" {
                    self.notFilled = true
                }else if self.titleKey == "" {
                    self.notFilled = true
                }else if self.name == "" {
                    self.notFilled = true
                }
                
                let commonKeyData = filem.contents(atPath: "\(AppDelegate().applicationSupportDir)/commonKey")
                let commonKeyString: String = String(data: commonKeyData ?? "".data(using: .utf8)!, encoding: String.Encoding.utf8) ?? ""
                print("common Key :" + commonKeyString)
                
                if commonKeyString == "" || commonKeyString == "Wii U Common Key"
                {
                    self.notFilled = true
                }
                
                if !self.notFilled && !self.noCommonKey {
                    self.inj.inject(rom: self.romFile, iconTex: self.iconTexFile, bootTvTex: self.tvTexFile, titleId: self.titleId, titleKey: self.titleKey, name: self.name)
                }
            }){
                Text("Inject")
            }.alert(isPresented: self.$notFilled) {
                Alert(title: Text("Fields Not Filled"), message: Text("Please fill in every field. Be sure you also provided the Common Key in the settings page."), dismissButton: .default(Text("Got it")))
            }
            
            ZStack(alignment: .leading){
                
                Rectangle()
                  .foregroundColor(Color.gray)
                  .opacity(0.3)
                  .frame(width: 345.0, height: 8.0)
               Rectangle()
                  .foregroundColor(Color.blue)
                  .frame(width: 345.0 * (injectorProgress / 100.0), height: 8.0)
            }
            .cornerRadius(4.0)
                
            }.padding()
    }
}

struct snesView_Previews: PreviewProvider {
    static var previews: some View {
        snesView(injectorProgress: .constant(0.0))
    }
}
